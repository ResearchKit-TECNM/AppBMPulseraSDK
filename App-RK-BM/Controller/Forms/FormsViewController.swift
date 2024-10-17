//
//  FormsViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 14/10/24.
//

import UIKit

protocol UserDelegate: AnyObject {
    func didUpdateUser(_ user: User)
}

class FormsViewController: UIViewController {
    
    var userDelegate: User? // objeto recibido de Tasks
    weak var delegate: UserDelegate? // declarar el delegado

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Formularios"
        
        if let user = self.userDelegate {
            print("Recibido: \(user.name) \(user.surname)")
        }
    }
    
    @IBAction func updateUser(_ sender: UIButton) {
        userDelegate?.name = "Daira"
        userDelegate?.surname = "Garcia"
        
        if let user = userDelegate {
            delegate?.didUpdateUser(user) // enviar los datos de vuelta
            
        }
    }
    
}
