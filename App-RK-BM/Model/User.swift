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
    private var stateIPAQ: Bool = false
    private var stateMMSE: Bool = false
    
    init(name: String, surname: String, email: String, stateIPAQ: Bool, stateMMSE: Bool) {
        self.name = name
        self.surname = surname
        self.email = email
        self.stateIPAQ = stateIPAQ
        self.stateMMSE = stateMMSE
    }
    
    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
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
    
    public func setName(name: String) {
        self.name = name
    }
    
    public func setSurname(surname: String) {
        self.surname = surname
    }
    
    public func setEmail(email: String) {
        self.email = email
    }
    
    // formularios
    public func setStateIPAQ(state: Bool) {
        self.stateIPAQ = state
    }
    
    public func setStateMMSE(state: Bool) {
        self.stateMMSE = state
    }
    
    public func didFillOutIPAQ() -> Bool {
        return self.stateIPAQ
    }
    
    public func didFillOutMMSE() -> Bool {
        return self.stateMMSE
    }
    
}
