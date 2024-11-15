//
//  Alerts.swift
//  App-RK-BM
//
//  Created by Luis Mora on 11/11/24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, mmessage: String, actionTitle: String = "OK", accionHandler: ((UIAlertAction) -> Void)? = nil) {
            let alerta = UIAlertController(title: title, message: mmessage, preferredStyle: .alert)
            let accion = UIAlertAction(title: actionTitle, style: .default, handler: accionHandler)
            alerta.addAction(accion)
            self.present(alerta, animated: true, completion: nil)
        }
}
