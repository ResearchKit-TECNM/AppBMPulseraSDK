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
import FirebaseCore

class TasksViewController: UIViewController {

    @IBOutlet weak var documentButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var signInGoogle: UIButton!
    @IBOutlet weak var signOutGoogle: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // comprobar autenticación
        if let user = Auth.auth().currentUser {
            print("\t\(user.email)")
            self.signOutGoogle.isEnabled = true
        } else {
            self.signOutGoogle.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leaveButtonTapped(_ sender: UIButton) {
        ORKPasscodeViewController.removePasscodeFromKeychain()
        performSegue(withIdentifier: "returnToConsent", sender: nil)
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
        PDFViewerStep.title = "Consent"
        return ORKOrderedTask(identifier: String("ConsentPDF"), steps: [PDFViewerStep])
    }
    
    @IBAction func googleSignInTapped(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("No se encontró el clientID")
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    // Maneja el error
                    print("Error al iniciar sesion con Google: \(error.localizedDescription)")
                    return
                }
                // El usuario ha iniciado sesión exitosamente
                print("Usuario autenticado con Google")
            }
        }
        viewDidLoad()
    }
    
    @IBAction func googleSignOutTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            print("Sesión cerrada correctamente!")
        } catch let signOutError as NSError {
            print("Error al cerrar la sesión: \(signOutError.localizedDescription)")
        }
        viewDidLoad()
    }
    
}

extension TasksViewController: ORKTaskViewControllerDelegate{
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskFinishReason, error: Error?) {
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
