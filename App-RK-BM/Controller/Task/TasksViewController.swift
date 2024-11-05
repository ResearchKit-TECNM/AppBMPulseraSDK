//
//  TasksViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 11/10/24.
//

import UIKit
import ResearchKitUI
import GoogleSignIn
import FirebaseAuth

class TasksViewController: UIViewController {

    @IBOutlet weak var documentButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var activitiesButton: UIButton!
    @IBOutlet weak var formsButton: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = Auth.auth().currentUser {
            if let name = user.displayName {
                self.userLabel.text = "Bienvenid@: \(name)"
            } else {
                print("El usuario no tiene un nombre asociado.")
            }
            UserManager.shared.user.uid = user.uid
        } else {
            print("No hay un usuario autenticado.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leaveButtonTapped(_ sender: UIButton) {
        showAlertSignOut()
    }
    
    func showAlertSignOut() {
        let alert = UIAlertController(title: "Alerta", message: "Al salir del estudio tambien cierras sesión con Google, ¿Deseas continuar?", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Continuar", style: .default) {_ in
            self.signOut()
            ORKPasscodeViewController.removePasscodeFromKeychain()
            self.performSegue(withIdentifier: "returnToConsent", sender: nil)
        }
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel) {_ in
            print("Cancelar")
        }
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func signOut() {
        // cerrar sesion en Firebase
        do {
            try Auth.auth().signOut()
            print("Sesion cerrada en Firebase")
        } catch let signOutError as NSError {
            print("Error al cerrar sesion en Firebase: \(signOutError)")
        }
        // cerrar sesion de google
        GIDSignIn.sharedInstance.signOut()
        print("Sesión cerrada en Google")
    }
    
    @IBAction func documentButtonTapped(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: consentPDFViewerTask(), taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    func consentPDFViewerTask() -> ORKOrderedTask{
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
        docURL = docURL?.appendingPathComponent("consent.pdf")
        let PDFViewerStep = ORKPDFViewerStep.init(identifier: "ConsentPDFViewer", pdfURL: docURL)
        PDFViewerStep.title = "Consentimiento del estudio"
        return ORKOrderedTask(identifier: String("ConsentPDF"), steps: [PDFViewerStep])
    }
    
    func toForms() {
        performSegue(withIdentifier: "toForms", sender: self)
    }
    
    func toActivities() {
        performSegue(withIdentifier: "toActivities", sender: self)
    }
    
    @IBAction func formsButtonTapped(_ sender: UIButton) {
        toForms()
    }
    
    @IBAction func activitiesButtonTapped(_ sender: UIButton) {
        toActivities()
    }
    
    @IBAction func unwindToTaskView(_ sender: UIStoryboardSegue) {
    }
    
}

extension TasksViewController: ORKTaskViewControllerDelegate{
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskFinishReason, error: Error?) {
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
