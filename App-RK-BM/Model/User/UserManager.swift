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
    
    func loadUser(_ uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection(self.collectionName).document(uid).getDocument { (document, error) in
            if let document = document, document.exists, let data = document.data() {
                // cargar datos a user
                self.user.consentDocumentURL = data ["consentDocumentURL"] as? String ?? ""
                self.user.hasAccepted = data["hasAccepted"] as? Bool ?? false
                self.user.madeIPAQ = data["madeIPAQ"] as? Bool ?? false
                self.user.madeMMSE = data["madeMMSE"] as? Bool ?? false
                // enviar user
                completion(.success(self.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func saveUser(_ uid: String) {
        let db = Firestore.firestore()
        
        let data = [
            "consentDocumentURL": self.user.consentDocumentURL,
            "hasAccepted": self.user.hasAccepted,
            "madeIPAQ": self.user.madeIPAQ,
            "madeMMSE": self.user.madeMMSE
        ] as [String : Any]
        
        db.collection(self.collectionName).document(uid).setData(data) { error in
            if let error = error {
                print("Error al guardar el user: \(error)")
            } else {
                print("User guardado exitosamente")
            }
        }
    }
}
