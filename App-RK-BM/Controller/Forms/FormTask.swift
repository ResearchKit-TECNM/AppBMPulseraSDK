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
        
        // formatos de respuestas
        
        let numericDaysWeekFormat = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: nil)
        numericDaysWeekFormat.minimum = 0
        numericDaysWeekFormat.maximum = 7
        
        let numericMinutesOfActivityFormat = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: nil)
        numericMinutesOfActivityFormat.minimum = 0
        numericMinutesOfActivityFormat.maximum = 1000
        
        
        // Instrucciones iniciales
        let formInstructionsStep = ORKInstructionStep(identifier: "formInstructions")
        formInstructionsStep.title = "Cuestionario Internacional de Actividad Física - IPAQ"
        formInstructionsStep.text = "El presente formulario es un cuestionario que evalua su nivel de actividad física en base a la version corta del cuestionario internacional IPAQ. Por favor llenelo con total honestidad. La información ingresada es completamente privada."
        formInstructionsStep.image = UIImage(systemName: "figure.walk")
        steps.append(formInstructionsStep)
        
        // instrucciones de las actividades vigorosas
        let vigorousQuestionsInstructionsStep = ORKInstructionStep(identifier: "vigorousQuestionsInstructions")
        vigorousQuestionsInstructionsStep.title = "Actividades vigorosas"
        vigorousQuestionsInstructionsStep.text = "Piense en todas las actividades VIGOROSAS que usted realizó en los últimos 7 días. Las actividades físicas intensas se refieren a aquellas que implican un esfuerzo físico intenso y que lo hacen respirar mucho más intensamente que lo normal. Piense sólo en aquellas actividades físicas que realizó durante por lo menos 10 minutos seguidos"
        steps.append(vigorousQuestionsInstructionsStep)
        
        // actividad vigorosa
        
        let firstQuestionStep = ORKQuestionStep(identifier: "firstQuestionVigorous", title: "Actividades Vigorosas", question: "1. Durante los últimos 7 días ¿En cuántos realizo actividades físicas vigorosas tales como levantar pesos pesados, cavar, hacer ejercicios aeróbicos o andar rápido en bicicleta?", answer: numericDaysWeekFormat)
        steps.append(firstQuestionStep)
        
        let secondQuestionStep = ORKQuestionStep(identifier: "secondQuestionVigorous", title: "Actividades vigorosas", question: "2. Habitualmente, ¿Cuánto tiempo en total en minutos dedicó a una actividad física intensa en uno de esos días? (ejemplo: si practicó 1 hora y 20 minutos ingrese 80 minutos)", answer: numericMinutesOfActivityFormat)
        steps.append(secondQuestionStep)
        
        // actividad moderada
        
        // instrucciones de las acitividades moderadas
        let moderateQuestionsInstructionsStep = ORKInstructionStep(identifier: "moderateQuestionsInstructions")
        moderateQuestionsInstructionsStep.title = "Actividades moderadas"
        moderateQuestionsInstructionsStep.text = "Piense en todas las actividades MODERADAS que usted realizó en los últimos 7 días. Las actividades moderadas son aquellas que requieren un esfuerzo físico moderado que lo hace respirar algo más intensamente que lo normal. Piense solo en aquellas actividades que realizó durante por lo menos 10 minutos seguidos."
        steps.append(moderateQuestionsInstructionsStep)
        
        let thirdQuestionStep = ORKQuestionStep(identifier: "thirdQuestionModerate", title: "Actividades moderadas", question: "3. Durante los últimos 7 días, ¿En cuántos días hizo actividades físicas moderadas como transportar pesos livianos, andar en bicicleta a velocidad regular o jugar a dobles en tenis? No incluya caminar.", answer: numericDaysWeekFormat)
        steps.append(thirdQuestionStep)
        
        let fourthQuestionStep = ORKQuestionStep(identifier: "fourthQuestionModerate", title: "Actividades moderadas", question: "4. Habitualmente, ¿Cuánto tiempo en total en minutos dedicó a una actividad física moderada en uno de esos días? (ejemplo: si practicó 1 hora y 20 minutos ingrese 80 minutos)", answer: numericMinutesOfActivityFormat)
        steps.append(fourthQuestionStep)
        
        // caminar
        let walkQuestionsInstructionsStep = ORKInstructionStep(identifier: "walkQuestionsInstructions")
        walkQuestionsInstructionsStep.title = "Caminar"
        walkQuestionsInstructionsStep.text = "Piense en el tiempo que usted dedicó a CAMINAR en los últimos 7 días. Esto incluye caminar en el trabajo o en la casa, para trasladarse de un lugar a otro, o cualquier otra caminata que usted podría hacer solamente para la recreación, el deporte, el ejercicio o el ocio."
        steps.append(walkQuestionsInstructionsStep)
        
        let fifthQuestionStep = ORKQuestionStep(identifier: "fifthQuestionWalk", title: "Caminar", question: "5. Durante los últimos 7 días, ¿En cuántos caminó por lo menos 10 minutos seguidos?", answer: numericDaysWeekFormat)
        steps.append(fifthQuestionStep)
        
        let sixthQuestionStep = ORKQuestionStep(identifier: "sixthQuestionWalk", title: "Caminar", question: "6. Habitualmente, ¿Cuánto tiempo en total en minutos dedicó a caminar en uno de esos días?", answer: numericMinutesOfActivityFormat)
        steps.append(sixthQuestionStep)
        
        // sedentarismo
        let sedentaryInstructionsStep = ORKInstructionStep(identifier: "sedentaryQuestionsInstructions")
        sedentaryInstructionsStep.title = "Sedentarismo"
        sedentaryInstructionsStep.text = "La ultima pregunta es acerca del tiempo que pasó usted SENTADO durante los días hábiles de los últimos 7 dias. Esto incluye el tiempo dedicado al trabajo, en la casa, en una clase, y durante el tiempo libre. Puede incluir el tiempo que paso sentado ante un escritorio, leyendo, viajando en autobús, o sentado o recostado mirando tele."
        steps.append(sedentaryInstructionsStep)
        
        let seventhQuestionStep = ORKQuestionStep(identifier: "seventhQuestionSedentary", title: "Sedentarismo", question: "7. Habitualmente, ¿Cuánto tiempo en minutos pasó sentado durante un día hábil?", answer: numericMinutesOfActivityFormat)
        steps.append(seventhQuestionStep)
        
        //Fin de la prueba
        let completionStep = ORKCompletionStep(identifier: "completion")
        completionStep.title = "Fin del formulario!"
        completionStep.text = "Gracias por completar el formulario"
        steps.append(completionStep)
        
        return ORKOrderedTask(identifier: "IPAQ", steps: steps)
    }
}
