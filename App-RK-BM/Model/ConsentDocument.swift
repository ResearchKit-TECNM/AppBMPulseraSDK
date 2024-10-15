//
//  ConsentDocument.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 10/10/24.
//

import ResearchKit

public var ConsentDocument: ORKConsentDocument{
    
    let consentDocument = ORKConsentDocument()
    consentDocument.title = "Formulario de consentimiento del estudio" //Or other title you prefer
    
    let sectionTypes: [ORKConsentSectionType] = [
        .overview,
        .dataGathering,
        .privacy,
        .dataUse,
        .studySurvey,
        .studyTasks,
        .withdrawing
    ]
    
    let titles = [
        "Descripción general",
        "Recopilación de datos",
        "Privacidad",
        "Uso de datos",
        "Encuesta de estudio",
        "Tareas de estudio",
        "Retirarse del estudio"
    ]
    
    var index = 0
    
    //Section contents
    let text = [
        "Sección 1: Descripción general. El presente estudio busca establecer una relación entre el sedentarismo y el deterioro cognitivo, asi como los beneficios que trae el realizar actividad física a padecimientos mentales diversos como la ansiedad o la depresión.",
        "Sección 2: Recopilación de datos. Los datos a recopilar de momento son el pulso cardiaco, la variabilidad de la frecuencia cardiaca y el tiempo de actividad e inactividad del participante.",
        "Sección 3: Privacidad. Todos los datos y la información recolectada durante el presente estudio del participante son privados y no serán publicos con la identidad del mismo.",
        "Sección 4: Uso de datos. Los datos y la información recolectada será usada para entrenar una inteligencia artifical con el fin de establecer una relación entre el sedentarismo y el deterioro cognitivo y el como realizar una actividad física permite controlar o reducir malestares de padecimientos mentales como la depresión y la ansiedad.",
        "Sección 5: Encuesta de estudio. Para el presente estudio, se requiere llenar un formulario con diversas preguntas relacionadas con el mismo si acepta participar en el mismo.",
        "Sección 6: Tareas de estudio. Durante el presente estudio se le pedirá que realice actividades diversas como caminar, correr o simplemente estar sentado para registrar información de los sensores de sus dispositivos.",
        "Sección 7: Retirarse del estudio. El participante podrá retirarse del estudio en cualquier momento sin repercusión alguna."
    ]
    
    consentDocument.sections = []
    
    //Add sections
    for sectionType in sectionTypes {
        let section = ORKConsentSection(type: sectionType)
                
        let localizedText = NSLocalizedString(text[sectionTypes.firstIndex(of: sectionType)!], comment: "")
        let localizedSummary = localizedText.components(separatedBy: ".")[0] + "."
                
        section.title = NSLocalizedString(titles[index], comment: "")
        section.summary = localizedSummary
        section.content = localizedText
                
        if consentDocument.sections == nil {
            consentDocument.sections = [section]
        } else {
            consentDocument.sections!.append(section)
        }
        index += 1
    }
    
    //Signature
    consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: "Participant", dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))
    
    return consentDocument
}
