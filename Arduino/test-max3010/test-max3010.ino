#include <Wire.h>
#include "MAX30105.h"
#include "heartRate.h"

MAX30105 particleSensor;

#define MAX_INT 2
#define MAX_SDA 4
#define MAX_SCL 5

unsigned long lastBeat = 0; // Variable para almacenar el tiempo del último latido

void setup() {
  Serial.begin(115200);
  delay(1000); // Espera para la configuración
  
  // Configuración I2C de pines personalizados
  Wire.begin(MAX_SDA, MAX_SCL);

  // Iniciar sensor
  if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) {
    Serial.println("No se encontró el sensor MAX30102");
    while(1);
  }

  // Configurar el sensor
  particleSensor.setup();
  particleSensor.setPulseAmplitudeRed(0x0A); // Led rojo baja amplitud
  particleSensor.setPulseAmplitudeGreen(0);  // Led verde apagado (no necesario)

  Serial.println("Sensor MAX30102 inicializado. Esperando datos...");
}

void loop() {
  // Lectura de datos del sensor
  long irValue = particleSensor.getIR();     // Luz infrarroja detectada por el sensor
  long redValue = particleSensor.getRed();   // Luz roja detectada por el sensor

  // Verifica si se detecta un dedo
  if (irValue > 50000) {  // Umbral de detección, puede variar
    Serial.println("Dedo detectado. Procesando datos...");

    // Cálculo de frecuencia cardíaca
    if (checkForBeat(irValue)) {
      float heartRate = 60.0 / ((millis() - lastBeat) / 1000.0);
      lastBeat = millis();

      if (heartRate < 255 && heartRate > 20) {  // Rango típico de frecuencia cardíaca
        Serial.print("Frecuencia cardíaca: ");
        Serial.print(heartRate);
        Serial.println(" BPM");
      } else {
        Serial.println("Frecuencia cardíaca fuera de rango.");
      }
    }

    // Cálculo del nivel de oxígeno en sangre (SpO₂)
    float ratio = (float)redValue / (float)irValue;   // Relación entre señal roja e infrarroja
    float spO2 = 110.0 - 25.0 * ratio;                // Fórmula aproximada para SpO₂

    if (spO2 > 100.0) spO2 = 100.0;                   // Limitar valor máximo a 100%
    else if (spO2 < 0.0) spO2 = 0.0;                  // Limitar valor mínimo a 0%

    Serial.print("Nivel de oxígeno en sangre (SpO₂): ");
    Serial.print(spO2);
    Serial.println(" %");

  } else {
    Serial.println("No se detectó dedo. Coloque el dedo en el sensor.");
  }

  delay(1000);  // Intervalo entre lecturas
}
