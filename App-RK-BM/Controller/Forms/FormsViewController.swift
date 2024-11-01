//
//  FormsViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 14/10/24.
//

import UIKit
import Foundation
import ResearchKitActiveTask
import FirebaseAuth
import CoreLocation
import FirebaseFirestore

class FormsViewController: UIViewController, CLLocationManagerDelegate {
    
    var userCountry: String?
    var userState: String?
    var userLocality:String?
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()

    @IBOutlet weak var ipaqButton: UIButton!
    @IBOutlet weak var mmseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Formularios"
        
        // solicitar permisos para usar la ubicación
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        UserManager.shared.user.madeIPAQ = true
        
        self.buttonsFormsManager()
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
    // Método llamado cuando el estado de autorización cambia
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // Comenzar a obtener la ubicación solo si se ha otorgado el permiso
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Permiso de ubicación denegado o restringido")
        default:
            break
        }
    }
        
    // Método para manejar la ubicación obtenida
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
            
        // Realizar la geocodificación en una cola de fondo
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchLocationDetails(location: location) { country, state, locality in
                DispatchQueue.main.async {
                    if let country = country, let state = state, let locality = locality {
                        print("País: \(country), Estado: \(state), Localidad: \(locality)")
                        // Aquí puedes actualizar la UI o pasar los datos a otra parte
                        self.userCountry = country
                        self.userState = state
                        self.userLocality = locality
                    } else {
                        print("No se pudieron obtener los detalles de ubicación")
                    }
                }
            }
        }
            
        // Detener las actualizaciones para ahorrar batería
        locationManager.stopUpdatingLocation()
    }
        
    // Función para obtener detalles de ubicación usando CLGeocoder
    func fetchLocationDetails(location: CLLocation, completion: @escaping (String?, String?, String?) -> Void) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error al obtener los detalles de la ubicación: \(error.localizedDescription)")
                completion(nil, nil, nil)
                return
            }
                
            if let placemark = placemarks?.first {
                let country = placemark.country
                let state = placemark.administrativeArea
                let locality = placemark.locality
                completion(country, state, locality)
            } else {
                completion(nil, nil, nil)
            }
        }
    }
    
        
    // Manejo de errores en caso de falla
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicación: \(error.localizedDescription)")
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
        
        updateFormToFirestore(type: typeForm, questions: questionsList, answers: answersList)
    }
    
    // cambios a futuro
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
                // fecha
                data["currentYear"] = currentDate.year
                data["currentMonth"] = currentDate.month
                data["currentDay"] = currentDate.dayNumber
                data["currentDayWeek"] = currentDate.dayName
                // localización
                data["currentCountry"] = self.userCountry ?? "unknown"
                data["currentState"] = self.userState ?? "unknown"
                data["currentLocality"] = self.userLocality ?? "unknown"
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
