//
//  FormsViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 14/10/24.
//

import UIKit
import ResearchKitActiveTask
import FirebaseAuth

class FormsViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var ipaqButton: UIButton!
    @IBOutlet weak var mmseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Formularios"
        
        // solicitar permisos para usar la ubicación
        LocationUtility.shared.locationManager.delegate = self
        LocationUtility.shared.requestLocationAuthorization()
        
        // observador para saber cuando los datos estan listos
        NotificationCenter.default.addObserver(self, selector: #selector(locationDataIsReady), name: .locationReady, object: nil)
        
        UserManager.shared.user.madeIPAQ = true
        
        self.buttonsFormsManager()
    }
    
    @objc func locationDataIsReady() {
        print("Los datos de ubicación están listos y almacenados en LocationUtility.")
    }
    
    func buttonsFormsManager() {
        // habilitar o deshabilitar botones
        if UserManager.shared.user.madeIPAQ {
            self.ipaqButton.isEnabled = false
        } else {
            self.ipaqButton.isEnabled = true
        }
        if UserManager.shared.user.madeMMSE {
            self.mmseButton.isEnabled = false
        } else {
            self.mmseButton.isEnabled = true
        }
    }
    
    @IBAction func mmseButtonTapped(_ sender: UIButton) {
        let formTask = FormTask.shared.createMMSETask()
        let formTaskViewController = ORKTaskViewController(task: formTask, taskRun: nil)
        formTaskViewController.delegate = self
        present(formTaskViewController, animated: true, completion: nil)
    }
    
    @IBAction func ipaqButtonTapped(_ sender: UIButton) {
        let formTask = FormTask.shared.createIPAQTask()
        let formTaskViewController = ORKTaskViewController(task: formTask, taskRun: nil)
        formTaskViewController.delegate = self
        present(formTaskViewController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        // seguir con el unwindSegue
        performSegue(withIdentifier: "unwindToTaskView", sender: self)
    }
    
    // ubicación
    // Opcional: Método delegado para manejar cambios en el estado de autorización
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            LocationUtility.shared.startUpdatingLocation()
        } else {
            print("Permiso de ubicación denegado o restringido")
        }
    }
    
    // guardar user al cerrar la pantalla por precaución
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("La vista Forms está a punto de desaparecer")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserManager.shared.saveUser(uid)
    }

}

extension FormsViewController: ORKTaskViewControllerDelegate {
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskFinishReason, error: (any Error)?) {
        // cerrar la ventana
        taskViewController.dismiss(animated: true, completion: nil)
        
        // verificar si hay un error
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        // obtener los resultados
        switch reason {
        case .completed:
            let result = taskViewController.result
            processResults(result: result)
            self.buttonsFormsManager()
        case .discarded, .failed, .earlyTermination, .saved:
            print("No se completo con exito")
            
        @unknown default:
            print("No se completo con exito")
        }
    }
    
    func processResults(result: ORKTaskResult) {
        var typeForm = ""
        var questionsList: [String] = []
        var answersList: [String] = []
        
        if result.identifier == "MMSE" {
            typeForm = "MMSE"
            UserManager.shared.user.madeMMSE = true
        } else if result.identifier == "IPAQ" {
            typeForm = "IPAQ"
            UserManager.shared.user.madeIPAQ = true
        }
        
        // Desempaquetar result.results con guard let
        guard let stepResults = result.results else {
            print("No se encontraron resultados.")
            return
        }
        
        // Iterar sobre los resultados desempaquetados
        for stepResult in stepResults {
            // Verificar si stepResult es de tipo ORKStepResult
            guard let stepResult = stepResult as? ORKStepResult else {
                print("El stepResult no es de tipo ORKStepResult.")
                continue
            }
            
            // Iterar sobre los resultados individuales dentro del ORKStepResult
            for result in stepResult.results ?? [] {
                // Verificar si result es de tipo ORKQuestionResult
                guard let questionResult = result as? ORKQuestionResult else {
                    print("El resultado no es de tipo ORKQuestionResult.")
                    continue
                }
                
                // Desempaquetar la respuesta
                guard let answer = questionResult.answer else {
                    print("Pregunta: \(questionResult.identifier), no se encontró respuesta.")
                    continue
                }
                
                // Imprimir pregunta y respuesta
                print("Pregunta: \(questionResult.identifier), Respuesta: \(answer)")
                
                // agregar pregunta
                questionsList.append(questionResult.identifier)
                // agregar respuesta
                if let stringAnswer = answer as? String {
                    answersList.append(stringAnswer)
                } else if let numericAnswer = answer as? NSNumber {
                    answersList.append(numericAnswer.stringValue)
                } else if let arrayAnswer = answer as? [String] {
                    answersList.append(arrayAnswer.joined(separator: ", "))
                } else {
                    answersList.append("Tipo de respuesta desconocido")
                }
            }
        }
        
        guard let user = Auth.auth().currentUser else {
            print("No hay usuario autenticado para subir el formulario")
            return
        }
        
        StorageManager.shared.updateFormToFirestore(type: typeForm, questions: questionsList, answers: answersList, uid: user.uid)
    }
}
