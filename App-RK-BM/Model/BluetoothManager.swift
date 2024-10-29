//
//  BluetoothManager.swift
//  App-RK-BM
//
//  Created by Luis Mora on 28/10/24.
//

import CoreBluetooth

protocol BluetoothManagerDelegate: AnyObject {
    func didUpdateConnectionStatus(isConnected: Bool)
    func didReceiveData(_ data: String)
}

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BluetoothManager() // Singleton para un acceso fácil
    
    // Define los UUIDs
    private let SERVICE_UUID = CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
    private let CHARACTERISTIC_UUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")
    
    private var centralManager: CBCentralManager!
    private var esp32Peripheral: CBPeripheral?
    private var esp32Characteristic: CBCharacteristic?
    
    weak var delegate: BluetoothManagerDelegate? // delegado para notificaciones
    
    override init () {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // inicia el escaneo de dispositivos
    func startScanning() {
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [SERVICE_UUID], options: nil)
            centralManager.scanForPeripherals(withServices: nil, options: nil)
            print("Buscando ESP32...")
        }
    }
    
    // detiene la conexión manualmente
    func disconnect() {
        if let esp32Peripheral = esp32Peripheral {
            centralManager.cancelPeripheralConnection(esp32Peripheral)
            print("Desconectando el ESP32...")
        }
    }
    
    // CBCentralManagerDelegate - Estado de Bluetooth
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("BT no esta disponible")
            delegate?.didUpdateConnectionStatus(isConnected: false)
        }
    }
    
    // CBCentralManagerDelegate - Detectar y conectar al ESP32
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if peripheral.name == "ESP32_BLE_Serial" {
            self.esp32Peripheral = peripheral
            self.esp32Peripheral?.delegate = self
            centralManager.stopScan()
            centralManager.connect(esp32Peripheral!, options: nil)
            print("Conectando a \(peripheral.name ?? "ESP32")")
        }
    }
    
    // CBCentralManagerDelegate - Conexión exitosa
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Conectado al ESP32")
        delegate?.didUpdateConnectionStatus(isConnected: true)
        esp32Peripheral?.discoverServices([SERVICE_UUID])
    }
    
    // CBCentralManagerDelegate - Desconexión
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == esp32Peripheral {
            print("Se ha desconectado el ESP32")
            delegate?.didUpdateConnectionStatus(isConnected: false)
        }
    }
    
    // Descubrir servicios en el ESP32
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services where service.uuid == SERVICE_UUID {
            peripheral.discoverCharacteristics([CHARACTERISTIC_UUID], for: service)
        }
    }
        
    // Característica encontrada y lista para recibir notificaciones
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics where characteristic.uuid == CHARACTERISTIC_UUID {
            esp32Characteristic = characteristic
            peripheral.setNotifyValue(true, for: characteristic)
            print("Característica lista para notificaciones")
        }
    }
        
    // Leer datos recibidos
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value, let receivedString = String(data: data, encoding: .utf8) else { return }
        // print("Datos recibidos: \(receivedString)")
        delegate?.didReceiveData(receivedString)
    }
        
    // Enviar un comando al ESP32
    func sendCommand(_ command: String) {
        guard let characteristic = esp32Characteristic else { return }
        let data = Data(("!" + command + "$").utf8)
        esp32Peripheral?.writeValue(data, for: characteristic, type: .withResponse)
        print("Comando enviado: \(command)")
    }
}
