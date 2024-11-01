//
//  UserPersistence.swift
//  App-RK-BM
//
//  Created by Luis Mora on 22/10/24.
//
/*
import Foundation

class UserPersistence {
    
    // obtener la ruta del archivo en documents directory
    private func getPathFileJson() -> URL? {
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return documentsURL.appendingPathComponent("user.json", conformingTo: .archive)
        }
        return nil
    }
    
    // guardar el objeto en un archivo json
    func saveUserInJson(user: User) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // hace el json legible
        do {
            let jsonData = try encoder.encode(user)
            
            // obtener la ruta del archivo
            if let fileURL = self.getPathFileJson() {
                // escribir los datos en el json
                try jsonData.write(to: fileURL)
                print("usuario guardado en: \(fileURL)")
            }
        } catch {
            print("Error al guardar el usuario en JSON: \(error)")
        }
    }
    
    // cargar el usuario desde un archivo json
    func loadUserFromJSON() -> User? {
        if let fileURL = self.getPathFileJson() {
            do {
                let jsonData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: jsonData)
                print("Usuario cargado desde JSON: \(user.stateIPAQ), \(user.stateMMSE)")
                return user
            } catch {
                print("Error al cargar el usuario desde el json: \(error)")
            }
        }
        return nil
    }
}
*/
