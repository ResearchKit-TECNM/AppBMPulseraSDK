//
//  MMSETask.swift
//  App-RK-BM
//
//  Created by Luis Mora on 17/10/24.
//

import ResearchKit

class FormTask {
    static let shared = FormTask()
    
    private init() {}
    
    func createMMSETask() -> ORKOrderedTask {
        
        var steps = [ORKStep]()
        
        // Instrucciones
        let instructionStep = ORKInstructionStep(identifier: "instruction")
        instructionStep.title = "Mini examen del estado mental (MMSE)"
        instructionStep.text = "El presente formulario es de una prueba que evalua las funciones congnitivas. Por favor tomese su tiempo y complete este formulario en un lugar libre de distracciones."
        steps.append(instructionStep)
        
        // Orientación temporal
        let orientationTimeStep = ORKQuestionStep(identifier: "orientationTime", title: "Orientación temporal", question: "¿En qué año estamos?", answer: ORKTextAnswerFormat(maximumLength: 4))
        steps.append(orientationTimeStep)
        
        // Orientación espacial
        let orientationPlaceStep = ORKQuestionStep(identifier: "orientationPlace", title: "Orientación espacial", question: "¿En que país estamos?", answer: ORKTextAnswerFormat(maximumLength: 30))
        steps.append(orientationPlaceStep)
        
        // Fijación
        // Atención y calculo
        // Memoria
        // Nominación
        // Repetición
        // Comprensión
        // Lectura
        // Escritura
        // Dibujo
        
        // Fin de la prueba
        let completionStep = ORKCompletionStep(identifier: "completion")
        completionStep.title = "Fin de la prueba!"
        completionStep.text = "Gracias por completar el formulario."
        steps.append(completionStep)
        
        return ORKOrderedTask(identifier: "MMSE", steps: steps)
    }
}
