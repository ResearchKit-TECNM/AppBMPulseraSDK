//
//  User.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 11/10/24.
//

class User {
    // variables
    private var name: String = ""
    private var surname: String = ""
    private var email: String = ""
    private var accepted: Bool = false
    
    init(name: String, surname: String, email: String, accepted: Bool) {
        self.name = name
        self.surname = surname
        self.email = email
        self.accepted = accepted
    }
    
    init() {
        
    }
    
    // getters y setters
    public func getName() -> String {
        return self.name
    }
    
    public func getSurname() -> String {
        return self.surname
    }
    
    public func getEmail() -> String {
        return self.email
    }
    
    public func getAccepted() -> Bool {
        return self.accepted
    }
    
    public func setName(name: String) {
        self.name = name
    }
    
    public func setSurname(surname: String) {
        self.surname = surname
    }
    
    public func setEmail(email: String) {
        self.email = email
    }
    
    public func setAccepted(status: Bool) {
        self.accepted = status
    }
    
}
