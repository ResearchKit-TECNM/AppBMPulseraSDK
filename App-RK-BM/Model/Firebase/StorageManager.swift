//
//  StorageManager.swift
//  App-RK-BM
//
//  Created by Luis Mora on 31/10/24.
//

import FirebaseStorage
import FirebaseFirestore

class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    func uploadPDFConsent(fileURL: URL,uid: String) {
        let storageRef = Storage.storage().reference()
        // ruta en Storage
        let pdfRef = storageRef.child("userDocuments/\(uid)/consent.pdf")
        
        // subir el archivo
        pdfRef.putFile(from: fileURL, metadata: nil) { metadata, error in
            if let error = error {
                print("Error al subir el PDF: \(error.localizedDescription)")
                return
            }
            
            // obtener la URL de descarga
            pdfRef.downloadURL { url, error in
                if let error = error {
                    print("Error al obtener la URL de descarga: \(error.localizedDescription)")
                    return
                }
                if let downloadURL = url {
                    print("Archivo subido exitosamente. URL: \(downloadURL.absoluteString)")
                    
                    UserManager.shared.user.consentDocumentURL = downloadURL.absoluteString
                }
            }
        }
    }
    
    func updateFormToFirestore(type: String, questions: [String], answers: [String], uid: String) {
        DispatchQueue.global(qos: .background).async {
            var data: [String: String] = [:]
            
            for (index, question) in questions.enumerated() {
                if index < answers.count {
                    data[question] = answers[index]
                }
            }
            
            // añadir respueas de MMSE
            if (type == "MMSE") {
                let country = LocationUtility.shared.userCountry
                let state = LocationUtility.shared.userState
                let locality = LocationUtility.shared.userLocality
                
                let currentDate = DateUtility.getCurrentDate()
                // fecha
                data["currentYear"] = currentDate.year
                data["currentMonth"] = currentDate.month
                data["currentDay"] = currentDate.dayNumber
                data["currentDayWeek"] = currentDate.dayName
                // localización
                if !country.isEmpty, !state.isEmpty, !locality.isEmpty {
                    data["currentCountry"] = LocationUtility.shared.userCountry
                    data["currentState"] = LocationUtility.shared.userState
                    data["currentLocality"] = LocationUtility.shared.userLocality
                } else {
                    print("\tLa ubicación aún no estaba disponible")
                }
            }
            
            print(data)
            
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

