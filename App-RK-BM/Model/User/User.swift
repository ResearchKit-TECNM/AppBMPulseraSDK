//
//  User.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 11/10/24.
//

struct User: Codable {
    var consentDocumentURL: String
    var hasAccepted: Bool
    var madeMMSE: Bool
    var madeIPAQ: Bool
    
    // constructor principal
    init(consentDocumentURL: String, hasAccepted: Bool, madeMMSE: Bool, madeIPAQ: Bool) {
        self.consentDocumentURL = consentDocumentURL
        self.hasAccepted = hasAccepted
        self.madeMMSE = madeMMSE
        self.madeIPAQ = madeIPAQ
    }
    
    // constructor vacio con valores iniciales
    init() {
        self.consentDocumentURL = ""
        self.hasAccepted = false
        self.madeIPAQ = false
        self.madeMMSE = false
    }
    
}
