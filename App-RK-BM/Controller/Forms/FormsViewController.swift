//
//  FormsViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 14/10/24.
//

import UIKit
import ResearchKitActiveTask
import FirebaseFirestore
import FirebaseAuth

class FormsViewController: UIViewController {
    
    var user: User?
    var userPersistence = UserPersistence() // instancia del servicio de persistencia

    @IBOutlet weak var ipaqButton: UIButton!
    @IBOutlet weak var mmseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Formularios"
        
        // cargar el objeto user desde el json
        if let userLoaded = self.userPersistence.loadUserFromJSON() {
            self.user = userLoaded
            print("User cargado = \(self.user?.stateIPAQ) º \(self.user?.stateMMSE)")
        } else {
            // de no haber datos guardados, se inicializa un usuario por defecto
            self.user = User(stateIPAQ: false, stateMMSE: false)
            print("User inicializado = \(self.user?.stateIPAQ) º \(self.user?.stateMMSE)")
        }
        // self.buttonsFormsManager()
    }
    
    func buttonsFormsManager() {
        // habilitar o deshabilitar botones
        if (self.user?.stateIPAQ == true) {
            // si ya lo ha hecho
            self.ipaqButton.isEnabled = false
        } else {
            self.ipaqButton.isEnabled = true
        }
        if (self.user?.stateMMSE == true) {
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
        // guardar el user en el json
        if let currentUser = user {
            // guardar el usuario en el json en un hilo secundario de fondo
            DispatchQueue.global(qos: .background).async {
                self.userPersistence.saveUserInJson(user: currentUser)
            }
        }
        
        // seguir con el unwindSegue
        performSegue(withIdentifier: "unwindToTaskView", sender: self)
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
            // Desempaquetar result.results con guard let
            guard let stepResults = result.results else {
                print("No se encontraron resultados.")
                return
            }
            
            // Iterar sobre los resultados desempaquetados
            for stepResult in stepResults {
                // Verificar si stepResult es de tipo ORKStepResult
                if let stepResult = stepResult as? ORKStepResult {
                    // Iterar sobre los resultados individuales dentro del ORKStepResult
                    for result in stepResult.results ?? [] {
                        if let questionResult = result as? ORKQuestionResult {
                            // Desempaquetar la respuesta
                            if let answer = questionResult.answer {
                                print("Pregunta: \(questionResult.identifier), Respuesta: \(answer)")
                                questionsList.append(questionResult.identifier)
                                answersList.append(answer as! String)
                            } else {
                                print("Pregunta: \(questionResult.identifier), no se encontró respuesta.")
                            }
                        } else {
                            print("El resultado no es de tipo ORKQuestionResult.")
                        }
                    }
                }
            }
            self.user?.stateMMSE = true
            
        } else if result.identifier == "IPAQ" {
            typeForm = "IPAQ"
            // Desempaquetar result.results con guard let
            guard let stepResults = result.results else {
                print("No se encontraron resultados.")
                return
            }
            
            // Iterar sobre los resultados desempaquetados
            for stepResult in stepResults {
                // Verificar si stepResult es de tipo ORKStepResult
                if let stepResult = stepResult as? ORKStepResult {
                    // Iterar sobre los resultados individuales dentro del ORKStepResult
                    for result in stepResult.results ?? [] {
                        if let questionResult = result as? ORKQuestionResult {
                            // Desempaquetar la respuesta
                            if let answer = questionResult.answer {
                                print("Pregunta: \(questionResult.identifier), Respuesta: \(answer)")
                                questionsList.append(questionResult.identifier)
                                answersList.append(answer.description)
                            } else {
                                print("Pregunta: \(questionResult.identifier), no se encontró respuesta.")
                            }
                        } else {
                            print("El resultado no es de tipo ORKQuestionResult.")
                        }
                    }
                }
            }
            self.user?.stateIPAQ = true
        }
        updateFormToFirestore(type: typeForm, questions: questionsList, answers: answersList)
    }
    
    func updateFormToFirestore(type: String, questions: [String], answers: [String]) {
        DispatchQueue.global(qos: .background).async {
            var data: [String: String] = [:]
            
            for (index, question) in questions.enumerated() {
                if index < answers.count {
                    data[question] = answers[index]
                }
            }
            print(data)
            
            guard let user = Auth.auth().currentUser else {
                print("No hay usuario autenticado")
                return
            }
            
            let uid = user.uid
            
            let db = Firestore.firestore()
            
            db.collection(type).document(uid).setData(data) { error in
                if let error = error {
                    print("Error al subir el formulario: \(error.localizedDescription)")
                } else {
                    print("Formulario subido exitosamente para el usuario con UID \(uid).")
                }
            }
        }
    }
}
