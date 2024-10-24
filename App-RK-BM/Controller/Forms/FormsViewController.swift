//
//  FormsViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 14/10/24.
//

import UIKit
import Foundation
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
            self.user?.stateMMSE = true
        } else if result.identifier == "IPAQ" {
            typeForm = "IPAQ"
            self.user?.stateIPAQ = true
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
            
            // añadir respueas de MMSE
            if (type == "MMSE") {
                let currentDate = self.getCurrentDate()
                data["currentYear"] = currentDate.year
                data["currentMonth"] = currentDate.month
                data["currentDay"] = currentDate.dayNumber
                data["currentDayWeek"] = currentDate.dayName
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
    
    func getCurrentDate() -> (year: String, month: String, dayNumber: String, dayName: String) {
        let date = Date()
        let calendar = Calendar.current
        
        let year1 = calendar.component(.year, from: date).description.capitalized
        let dayNumber1 = calendar.component(.day, from: date).description.capitalized
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        
        dateFormatter.dateFormat = "MMMM"
        let monthName1 = dateFormatter.string(from: date).capitalized
        dateFormatter.dateFormat = "EEEE"
        let dayName1 = dateFormatter.string(from: date).capitalized
        
        return (year: year1, month: monthName1, dayNumber: dayNumber1, dayName: dayName1)
    }
}
