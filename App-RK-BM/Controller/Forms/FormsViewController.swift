//
//  FormsViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 14/10/24.
//

import UIKit
import ResearchKitActiveTask

protocol UserDelegate: AnyObject {
    func didUpdateUser(_ user: User)
}

class FormsViewController: UIViewController {
    
    var userDelegate: User? // objeto recibido de Tasks
    weak var delegate: UserDelegate? // declarar el delegado

    @IBOutlet weak var ipaqButton: UIButton!
    @IBOutlet weak var mmseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Formularios"
        
        if let user = self.userDelegate {
            print("Recibido: \(user.name) \(user.surname)")
        }
    }
    @IBAction func mmseButtonTapped(_ sender: UIButton) {
        let formTask = FormTask.shared.createMMSETask()
        let formTaskViewController = ORKTaskViewController(task: formTask, taskRun: nil)
        formTaskViewController.delegate = self
        present(formTaskViewController, animated: true, completion: nil)
    }
    
    @IBAction func updateUser(_ sender: UIButton) {
        userDelegate?.name = "Daira"
        userDelegate?.surname = "Garcia"
        
        if let user = userDelegate {
            delegate?.didUpdateUser(user) // enviar los datos de vuelta
            
        }
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
            
        case .discarded, .failed, .earlyTermination, .saved:
            print("No se completo con exito")
            
        @unknown default:
            print("No se completo con exito")
        }
    }
    
    func processResults(result: ORKTaskResult) {
        if result.identifier == "MMSE" {
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
                            } else {
                                print("Pregunta: \(questionResult.identifier), no se encontró respuesta.")
                            }
                        } else {
                            print("El resultado no es de tipo ORKQuestionResult.")
                        }
                    }
                }
            }
        }
    }
}
