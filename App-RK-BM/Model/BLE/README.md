# Documentación BluetoothManager

## Protocolo BluetoothManagerDelegate
Este protocolo funciona como un intermediario entre la comunicación de la clase **BluetoothManager** y otros puntos del proyecto donde sea requerido su uso para poder ser notificados de cambios o eventos existentes.
Los métodos definidos en este son los siguientes:
* **didUpdateConnectionStatus**: este método tiene como función detectar la conexión o desconexión de un dispositivo Bluetooth.
* **didReceiveData**: este método es llamado cuando cuando se recibe información entrante otro dispositivo mediante Bluetooth.

Este ha de ser implementado en la clase tipo _ViewController_ donde se ha de hacer uso de la conexión Bluetooth, aunque no se limita a una sola ya que permite el uso de **BluetoothManager** en diferentes _ViewControllers_.

## Clase BluetoothManager
Esta clase es una implementación de un gestor de Bluetooth centralizado para la comunicación con dispositivos BLE e implementa los protocolos **CBCentralManagerDelegate** y **CBPeripheralDelegate** encargados de la exploración, conexión (CBCentralManagerDelegate) y transferencia de datos (CBPeripheralDelegate).

### Propiedades
* **shared**: implementación unica de clase en todo el proyecto con el modelo _singleton_ para un acceso facil a los metodos de la misma.
* **centralManager**: gestor central de Bluetooth encargado de la detección y conexión de dispositivos BLE.
* **esp32Peripheral**: definición de la referencia al periférico del ESP32.
* **esp32Characteristic**: definición de la comunicación de lectura y escritura con el ESP32.
* **delegate**: definición del delegado opcional conforme al protocolo **BluetoothManagerDelegate** descrito anteriormente para ser notificados de eventos de conexión, desconexión y entrada de datos.

### Constantes
* **SERVICE_UUID**: uuid de identificación del servicio del ESP32.
* **CHARACTERISTIC_UUID**: uuid de identificación de la caracteristica del ESP32.

> [!NOTE]
> Ambos UUIDs deben de coincidir con los definidos en el código del ESP32 para que la conexión sea posible y unica con la aplicación.

### Métodos
* **override init ()**: inicializa la instancia unica de la clase y configura a _centralManager_ como el delegado.
* **startScanning()**: comienza la busqueda de dispositivos BLE con el _SERVICE_UUID_ definido anteriormente, de no contar con este entonces se buscará la conexión con cualquier dispositivo disponible, cabe decir que el Bluetooth del dispositivo debe de estar encendido.
* **disconnect()**: desconecta el oeriférico _esp32Peripheral_ de manera manual.
* **centralManagerDidUpdateState(_ central: CBCentralManager)**: maneja los cambios de la conexión Bluetooth mediante el _centralManager_.
* **centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber)**: al conectar un dispositivo BLE, este perifica el nombre del periférico, y si coincide con el que busca entonces establece la conexión.
* **centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)**: si la conexión ha sido exitosa entonces pone el estado de la conexión del delegate en _true_ y busca el servicio uuid requerido en el esp32.
* **centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?)**: si la conexión ha sido cancelada, entonces cambia el estado de la conexión del delegate a _false_
* **peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)**: busca los servicios del ESP32, y si este coincide con el requerido, entonces busca características.
* **peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)**: si se ha encontrado la caracteristica requerida, entonces habilita las notificaciones de eventos para enviar y recibir datos entre la aplicación y el ESP32.
* **peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)**: si hay un evento de entrada de datos a la aplicación, entonces leé la información obtenida y lo convierte a un String con el formato _UTF-8_
* **sendCommand(_ command: String)**: envia un comando tipo String al ESP32 mediante la caracteristica, en este caso se ha optado por seguir la siguiente estrucura -> **!comando$**.

> Peripheral (periférico): es un dispositivo que proporciona datos y servicios a otros dispositivos (centrales). En este caso el periférico es el ESP32 y la central es la aplicación.

> Characteristic (característica): es un atributo que contiene un valor (datos enviados y recibidos) asi como propiedades asociadas (lectura, escritura o notificaciones), esta se encuentra asociada a un servicio específico del periférico.

Un ejemplo del funcionamiento del protocolo y de la clase se encuentra en _ActivitiesViewController.swift_.
