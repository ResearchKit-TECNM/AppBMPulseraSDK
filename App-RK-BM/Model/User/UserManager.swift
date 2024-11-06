//
//  UserManager.swift
//  App-RK-BM
//
//  Created by Luis Mora on 31/10/24.
//

import FirebaseFirestore

class UserManager {
    static let shared = UserManager() // crea una instancia unica del objeto
    
    var user = User()
    let collectionName = "users"
    
    private init() {} // evitar crear instancias
    
    func loadUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection(self.collectionName).document(uid).getDocument { (document, error) in
            if let error = error {
                // Caso de error en la conexión o consulta
                completion(.failure(error))
                return
            }
            if let document = document, document.exists, let data = document.data() {
                // cargar datos a user
                self.user.consentDocumentURL = data ["consentDocumentURL"] as? String ?? ""
                self.user.hasAccepted = data["hasAccepted"] as? Bool ?? false
                self.user.madeIPAQ = data["madeIPAQ"] as? Bool ?? false
                self.user.madeMMSE = data["madeMMSE"] as? Bool ?? false
                self.user.madeMR = data["madeMR"] as? Bool ?? false
                self.user.uid = data["uid"] as? String ?? ""
                // enviar user
                completion(.success(self.user))
            } else {
                // Caso en que el documento no existe
                let notFoundError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Documento no encontrado"])
                completion(.failure(notFoundError))
            }
        }
    }
    
    func saveUser(completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        let data = [
            "consentDocumentURL": self.user.consentDocumentURL,
            "hasAccepted": self.user.hasAccepted,
            "madeIPAQ": self.user.madeIPAQ,
            "madeMMSE": self.user.madeMMSE,
            "madeMR": self.user.madeMR,
            "uid": self.user.uid
        ] as [String : Any]
        
        db.collection(self.collectionName).document(self.user.uid).setData(data) { error in
            if let error = error {
                print("Error al guardar el user: \(error)")
                completion(false) // el guardado falló
            } else {
                print("User guardado exitosamente")
                completion(true) // el guardado fue exitoso
            }
        }
    }
}
