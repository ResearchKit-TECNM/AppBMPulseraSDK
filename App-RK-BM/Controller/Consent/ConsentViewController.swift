//
//  ConsentViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 10/10/24.
//

import UIKit
import ResearchKitUI
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class ConsentViewController: UIViewController {

    @IBOutlet weak var joinButton: UIView!
    @IBOutlet weak var googleButton: UIButton!
    
    private var status: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func googleButtonTapped(_ sender: UIButton) {
        // codigo de inicio de sesion con google
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            if let error = error {
                print("Error al iniciar sesión con Google: \(error.localizedDescription)")
                return
            }

            // El inicio de sesión fue exitoso
            guard let result = result else { return }
            let user = result.user
            let idToken = user.idToken?.tokenString ?? ""
            let accessToken = user.accessToken.tokenString
               
            // Autenticación con Firebase
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
               
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error al autenticar con Firebase: \(error.localizedDescription)")
                    return
                }
                // Usuario autenticado con éxito
                print("Usuario autenticado en Firebase: \(authResult?.user.displayName ?? "")")
            }
        }
            
        // habilitar boton de inicio de sesion
        self.status = true
        showAlert(title: "Autenticación", message: "Sesión iniciada correctamente.")
        
    }
    
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        if status == true {
            let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
            taskViewController.delegate = self
            present(taskViewController, animated: true, completion: nil)
        } else {
            showAlert(title: "Alerta", message: "Para unirse al estudio, primero debe iniciar sesión.")
        }
    }
    
    func showAlert(title: String, message: String) {
            // Crear el controlador de alerta
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            // Añadir una acción (botón) al controlador de alerta
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                print("El usuario presionó OK")
            }
            alertController.addAction(okAction)
            
            // Mostrar la alerta
            present(alertController, animated: true, completion: nil)
        }
    
}

extension ConsentViewController: ORKTaskViewControllerDelegate{
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskFinishReason, error: Error?) {
        switch reason {
        case .completed:
            // imprimir el documento de consentimiento
            let signatureResult: ORKConsentSignatureResult = taskViewController.result.stepResult(forStepIdentifier: "ConsentReviewStep")?.firstResult as! ORKConsentSignatureResult
            let consentDocument = ConsentDocument.copy() as! ORKConsentDocument
            signatureResult.apply(to: consentDocument)
            consentDocument.makePDF{ (data, error) -> Void in
                guard let pdfData = data else {
                    print("No se generó el pdf corectamente")
                    return
                }
                print("Tamaño del PDF: \(pdfData.count) bytes")  // Solo para confirmar que el archivo se ha generado
                
                var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
                docURL = docURL?.appendingPathComponent("consent.pdf")
                try? data?.write(to: docURL!, options: .atomicWrite)
                self.uploadPDFCosent(fileURL: docURL!)
            }
            // segue
            performSegue(withIdentifier: "unwindToTasks", sender: nil)
        case .discarded, .failed, .saved:
            dismiss(animated: true, completion: nil)
        case .earlyTermination:
            print("\tError en early termination")
        @unknown default:
            print("\tError en default")
        }
        
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, viewControllerFor step: ORKStep) -> ORKStepViewController? {
        if step is HealthDataAuthStep {
            let healthStepViewController = HealthDataAuthStepViewController(step: step)
            return healthStepViewController
        }
        return nil
    }
    
    func uploadPDFCosent(fileURL: URL) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Usuario no autenticado para subir el documento!")
            return
        }
        
        let storageRef = Storage.storage().reference()
        // ruta en FireStorage
        let pdfRef = storageRef.child("userDocuments/\(userID)/consent.pdf")
        
        // subir el archivo
        pdfRef.putFile(from: fileURL, metadata: nil) {metadata, error in
            if let error = error {
                print("Error al subir el PDF: \(error.localizedDescription)")
                return
            }
            
            // obtener la URL de descarga
            pdfRef.downloadURL {url, error in
                if let error = error {
                    print("Error al obtener la URL de descarga: \(error.localizedDescription)")
                    return
                }
                
                if let downloadURL = url {
                    print("Archivo subido exitosamente. URL: \(downloadURL.absoluteString)")
                    // Aquí puedes guardar la URL en Firestore o Realtime Database para asociarla con el usuario
                }
            }
        }
    }
    
    func saveConsentDocumentURLToFirestore(_ downloadURL: URL) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("El usuario no está autenticado")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(userID).setData(["cosentDocumentURL": downloadURL.absoluteString], merge: true) {error in
            if let error = error {
                print("Error al guardar la URL del documento: \(error.localizedDescription)")
            } else {
                print("URL del documento guardada")
            }
        }
    }
}
