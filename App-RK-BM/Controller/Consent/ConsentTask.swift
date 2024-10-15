//
//  ConsentTask.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 11/10/24.
//

import ResearchKit
import ResearchKitUI
import ResearchKitActiveTask

public var ConsentTask: ORKOrderedTask{
    
    var steps = [ORKStep]()

    //Visualization
    //This step is where Apple will help us present the consent document with animations
    let consentDocument = ConsentDocument
    
    //Request Health Data
    //We will need the user to grant us access to health data for collection
    let healthDataStep = HealthDataAuthStep(identifier: "Health")
    steps += [healthDataStep]
    
    //Review & Sign
    //The whole document will be shown to the user and the user will draw their signature on the touch screen
    let signature = consentDocument.signatures!.first!
    let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
    reviewConsentStep.text = "Revise el formulario de consentimiento."
    reviewConsentStep.reasonForConsent = "Consentimiento para unirse al estudio"
    steps += [reviewConsentStep]
    
    //Passcode/TouchID Protection
    //Because it is personal data
    let passcodeStep = ORKPasscodeStep(identifier: "Passcode")
    passcodeStep.text = "Ahora crea un código de acceso a la app para proteger tu información."
    steps += [passcodeStep]
    
    //Completion
    //A thank you message
    let completionStep = ORKCompletionStep(identifier: "CompletionStep")
    completionStep.title = "Bienvenido a bordo!"
    completionStep.text = "Muchas gracias por formar parte del estudio y poner tu granito de arena para contribuir a la mejora de la salud mental."
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}
