//  30/10/2024 Test de conexión i2c
// LuisMoraEL

// conexión BLE
#include <Arduino.h>   
#include <BLEDevice.h> // libreria para manejo BLE
#include <BLEUtils.h>  // funciones de utilidad para BLE
#include <BLEServer.h> // crear un servidor BLE
#include <BLE2902.h>   // descriptor para habilitar notificaciones
// sensor BMP180
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BMP085_U.h>

// Crear una instancia del sensor bmp180
Adafruit_BMP085_Unified bmp = Adafruit_BMP085_Unified(10085);

// variables requeridas
const String startSensing = "start_sensing"; // iniciar senso
const String stopSensing = "end_sensing"; // finalizar senso
const int timeBetweenSense = 100; // tiempo en ms entre lecturas
bool sensingActive = false; // activar lecturas
double sumTemperature = 0.0; // suma de temperatura
double sumPressure = 0.0; // suma de presion
double sumAltitude = 0.0; // suma de altitud
long sensingCounter = 0; // contador de lecturas
const float seaLevelPressure = 1013.25; // constante del nivel del mar
float promTemperature;
float promPreassure;
float promAltitude;


// UUIDs del servicio y de la caracteristica BLE
#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

BLECharacteristic *pCharacteristic; // caracteristica BLE para enviar y recibir datos
bool deviceConnected = false;       // estado de conexión del dispositivo
String command = "";                // almacena el comando recibido
String cmd = "";                    // almacena el comando procesado
bool cmdReceived = false;           // bandera de si ha llegado un comando

// clase de callback para el servidor BLE, detecta una conexión y desconexió de dispositivos
class MyServerCallbacks: public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    Serial.println("Nuevo dispositivo conectado!");
  }

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
    Serial.println("Dispositivo desconectado!");

    // reiniciar la publicidad BLE
    pServer->getAdvertising()->start();
    Serial.println("Reiniciando publicidad BLE...");
  }
};

// clase de callback para la caracteristica BLE, detecta la escritura en la caracteristica
class MyCallbacks: public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue(); // obtener el valor escrito desde el dispositivo
    Serial.print("Mensaje recibido desde el dispositivo: ");
    Serial.println(value.c_str());
    command = String(value.c_str()); // convirtiendo el comando a string
    cmdReceived = true; // activar bandera de comando recibido
  }
};

void setup() {
  Serial.begin(115200);

  // establecer la frecuencia del CPU a 80 MHz para optimizar el consumo energético
  setCpuFrequencyMhz(80);

  // Imprimir la frecuencia del cristal XTAL
  Serial.print("Frecuencia del Cristal XTAL: ");
  Serial.print(getXtalFrequencyMhz());
  Serial.println(" MHz");

  // Imprimir la frecuencia de la CPU
  Serial.print("Frecuencia de la CPU: ");
  Serial.print(getCpuFrequencyMhz());
  Serial.println(" MHz");

  // Imprimir la frecuencia del bus APB
  Serial.print("Frecuencia del Bus APB: ");
  Serial.print(getApbFrequency());
  Serial.println(" Hz");

  // iniciando bmp180
  if (!bmp.begin()) {
    Serial.println("No se encontró el sensor BMP180.");
    while(1);
  }

  // inicializar el dispositivo BLE
  BLEDevice::init("ESP32_BLE_Serial");
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // crear el servicio BLE
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // crear la caracteristica BLE con permisos de lectura y escritura
  pCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ |    // lectura
    BLECharacteristic::PROPERTY_WRITE |   // escritura
    BLECharacteristic::PROPERTY_NOTIFY    // noficiaciones para envio de datos
  );
  pCharacteristic->setCallbacks(new MyCallbacks);

  // añadir descriptor para habilitar notificaciones
  pCharacteristic->addDescriptor(new BLE2902());

  // iniciar el servicio y la publicidad
  pService->start();
  pServer->getAdvertising()->start();
  Serial.println("Publicidad BLE iniciada, esperando conexión...");
}

void loop() {
  // procesar comandos cuando se reciba uno
  if (cmdReceived && deviceConnected) {
    int init = command.indexOf('!');
    if (init != -1) {
      int end = command.indexOf('$', init);
      if (end != -1) {
        cmd = command.substring(init + 1, end); // extraer el comando entre '!' y '$'
      }
    }

    // ejecutar acción según el comando recibido
    if (cmd.equals(startSensing)) {
      Serial.println("Iniciando sensado de datos...");
      // va la demas lógica
      sensingActive = true;
    } else if (cmd.equals(stopSensing)) {
      Serial.println("Deteniendo el sensado de datos");
      // va la demas lógica
      sensingActive = false;

      promPreassure = sumPressure / sensingCounter;
      promTemperature = sumTemperature / sensingCounter;
      promAltitude = sumAltitude / sensingCounter;

      String txt = "sumPreassure: " + String(sumPressure, 2) + " SumTemperature: " + String(sumTemperature, 2) + " SumAltitude: " + String(sumAltitude, 2) + " sensingCounter: " + String(sensingCounter, 1);
      Serial.println(txt); 

      sumPressure = 0;
      sumTemperature = 0;
      sumAltitude = 0;
      sensingCounter = 0;

      // enviar datos
      String dataToSend = "temp(" + String(promTemperature, 2) + " ºc) press(" + String(promPreassure, 2) + " hPa) alt(" + String(promAltitude, 2) + " m)"; 
      pCharacteristic->setValue(dataToSend.c_str()); // configurar el valor de la caracteristica
      pCharacteristic->notify(); // enviar la información
      Serial.println("Notificación con datos enviada: " + dataToSend);
    }
    cmdReceived = false; // reiniciar bandera
  }

  // si las lecturas estan activas
  if (sensingActive) {
    // tomar y almacenar lecturas
    sensors_event_t event;
    bmp.getEvent(&event);

    if (event.pressure) {
      // obtener presion, temperatura y altitud
      float pressure = event.pressure;
      float temperature;
      bmp.getTemperature(&temperature);
      float altitude = bmp.pressureToAltitude(seaLevelPressure, pressure);

      // sumar los valores para obtener el promedio
      sumPressure += pressure;
      sumTemperature += temperature;
      sumAltitude += altitude;
      sensingCounter += 1;

      // Mostrar lecturas actuales
      Serial.print("Presión: ");
      Serial.print(pressure);
      Serial.println(" hPa");
      
      Serial.print("Temperatura: ");
      Serial.print(temperature);
      Serial.println(" *C");

      Serial.print("Altitud: ");
      Serial.print(altitude);
      Serial.println(" metros");
    } else {
      Serial.println("Error al leer los datos del sensor.");
    }
  } 

  delay(timeBetweenSense); // retraso para evitar la sobrecarga en el loop
}