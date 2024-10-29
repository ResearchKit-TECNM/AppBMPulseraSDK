//
//  ActivitiesViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 14/10/24.
//

import UIKit

class ActivitiesViewController: UIViewController, BluetoothManagerDelegate {
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var endSensingButton: UIButton!
    @IBOutlet weak var startSensingButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Actividades"
        
        BluetoothManager.shared.delegate = self
    }
    
    @IBAction func connectButtonTapped(_ sender: UIButton) {
        BluetoothManager.shared.startScanning()
    }
    
    @IBAction func disconnectButtonTapped(_ sender: UIButton) {
        BluetoothManager.shared.disconnect()
    }
    
    @IBAction func startSensingButtonTapped(_ sender: UIButton) {
        BluetoothManager.shared.sendCommand("start_sensing")
    }
    @IBAction func endSensingButtonTapped(_ sender: UIButton) {
        BluetoothManager.shared.sendCommand("end_sensing")
    }
    
    // BluetoothManagerDelegate - Actualizar estado de conexión
    func didUpdateConnectionStatus(isConnected: Bool) {
        let status = isConnected ? "Conectado": "Desconectado"
        print("Estado de conexión: \(status)")
        print("En activities view controller")
        DispatchQueue.main.async {
            self.stateLabel.text = "Estado: " + status
        }
    }
    
    // BluetoothManagerDelegate - Datos recibidos
    func didReceiveData(_ data: String) {
        print("Datos recibidos: \(data)")
        print("En activities view controller")
        DispatchQueue.main.async {
            self.dataLabel.text = "Datos recibidos: " + data
        }
    }
}
