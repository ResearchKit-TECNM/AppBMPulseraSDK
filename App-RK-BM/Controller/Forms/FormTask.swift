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
    
    func createIPAQTask() -> ORKOrderedTask {
        
        var steps = [ORKStep]()
        
        // Instrucciones
        let instructionStep = ORKInstructionStep(identifier: "instruction")
        instructionStep.title = "Cuestionario Internacional de Actividad Física IPAQ"
        instructionStep.text = "El presente formulario es un cuestionario que evalua su nivel de actividad física. Por favor llenelo con total honestidad. La información ingresada es completamente privada."
        steps.append(instructionStep)
        
        // actividad intensa
        let intenseActivityStep = ORKQuestionStep(identifier: "hardActivityQuestion", title: "Actividad física intensa", question: "Durante los últimos 7 días, ¿cuántos días ha realizado actividad física intensa, como levantar cosas pesadas, cavar, hacer aeróbicos, o montar en bicicleta rápido?", answer: ORKTextAnswerFormat(maximumLength: 1))
        steps.append(intenseActivityStep)
        
        // actividad moderada
        let moderateActivityStep = ORKQuestionStep(identifier: "moderateActivityQuestion", title: "Actividad física moderada", question: "Durante los últimos 7 días, ¿cuántos días ha realizado actividad física moderada, como cargar cosas ligeras, andar en bicicleta a velocidad moderada o hacer trabajos domésticos?", answer: ORKTextAnswerFormat(maximumLength: 1))
        steps.append(moderateActivityStep)
        
        //Fin de la prueba
        let completionStep = ORKCompletionStep(identifier: "completion")
        completionStep.title = "Fin del formulario!"
        completionStep.text = "Gracias por completar el formulario"
        steps.append(completionStep)
        
        return ORKOrderedTask(identifier: "IPAQ", steps: steps)
    }
}
