//
//  User.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 11/10/24.
//

class User: Codable {
    // variables
    public var stateIPAQ: Bool = false
    public var stateMMSE: Bool = false
    
    init(stateIPAQ: Bool, stateMMSE: Bool) {
        self.stateIPAQ = stateIPAQ
        self.stateMMSE = stateMMSE
    }
    
}
