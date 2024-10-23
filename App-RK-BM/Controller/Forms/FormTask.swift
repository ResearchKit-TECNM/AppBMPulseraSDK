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
        
        let textLetterAnswerFormat = ORKTextAnswerFormat(maximumLength: 200)
        textLetterAnswerFormat.multipleLines = true
        let textAnswerFormat = ORKTextAnswerFormat(maximumLength: 40)
        textAnswerFormat.multipleLines = false
        let numericAnswerFormat = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: nil)
        
        // Instrucciones
        let instructionStep = ORKInstructionStep(identifier: "instruction")
        instructionStep.title = "Mini examen del estado mental (MMSE)"
        instructionStep.text = "El presente formulario es de una prueba que evalua las funciones congnitivas. Por favor tomese su tiempo y complete este formulario en un lugar libre de distracciones."
        steps.append(instructionStep)
        
       // Orientación del tiempo y del espacio
        let orientationInstructionsStep = ORKInstructionStep(identifier: "orientationInstructions")
        orientationInstructionsStep.title = "Orientación en el tiempo y el espacio"
        orientationInstructionsStep.text = "Las siguientes preguntas son de evaluación de la orientación del tiempo y del espacio."
        steps.append(orientationInstructionsStep)
        
        
        let timeOrientationForm = ORKFormStep(identifier: "timeOrientationForm", title: "Orientación del tiempo", text: "De información de la fecha actual")
        
        // Pregunta 1
        let timeQuestionYear = ORKFormItem(identifier: "timeQuestionYear", text: "¿En qué año estamos?", answerFormat: textAnswerFormat)
        // Pregunta 2
        let timeQuestionMonth = ORKFormItem(identifier: "timeQuestionMonth", text: "¿En qué mes?", answerFormat: textAnswerFormat)
        // Pregunta 3
        let timeQuestionDay = ORKFormItem(identifier: "timeQuestionDay", text: "¿Cuál es el número del dia de hoy?", answerFormat: textAnswerFormat)
        // Pregunta 4
        let timeQuestionWeekDay = ORKFormItem(identifier: "timeQuestionWeekDay", text: "¿Qué dia de la semana es?", answerFormat: textAnswerFormat)
        
        timeOrientationForm.formItems = [timeQuestionYear, timeQuestionMonth,timeQuestionDay, timeQuestionWeekDay]
        steps.append(timeOrientationForm)
        
        
        let spaceOrientationForm = ORKFormStep(identifier: "spaceOrientationForm", title: "Orientación del espacio", text: "De información del lugar donde se encuentra ahora.")
        
        // pregunta 5
        let spaceQuestionCountry = ORKFormItem(identifier: "spaceQuestionCountry", text: "¿En qué país se encuentra?", answerFormat: textAnswerFormat)
        // pregunta 6
        let spaceQuestionArea = ORKFormItem(identifier: "spaceQuestionArea", text: "¿En qué estado?", answerFormat: textAnswerFormat)
        // pregunta 7
        let spaceQuestionLocality = ORKFormItem(identifier: "spaceQuestionLocality", text: "¿En que ciudad o localidad?", answerFormat: textAnswerFormat)
        
        spaceOrientationForm.formItems = [spaceQuestionCountry, spaceQuestionArea, spaceQuestionLocality]
        steps.append(spaceOrientationForm)
        
        // fijación?
        
        // concentración y cálculo
        let concentrationInstructionsStep = ORKInstructionStep(identifier: "concentrationInstructions")
        concentrationInstructionsStep.title = "Concentración y cálculo"
        concentrationInstructionsStep.text = "Ahora se ha de evalular su capacidad de concentración al realizar unas operaciones matemáticas"
        steps.append(concentrationInstructionsStep)
        
        let concentrationForm = ORKFormStep(identifier: "concentrationForm", title: "Concentración y cálculo", text: "Comenzemos desde el número 100, usted tiene que ir dando el resultado de dicha operación.")
        
        let concentrationQuestionOne = ORKFormItem(identifier: "concentrationQuestionOne", text: "100 menos 7", answerFormat: numericAnswerFormat)
        
        let concentrationQuestionTwo = ORKFormItem(identifier: "concentrationQuestionTwo", text: "Menos 7", answerFormat: numericAnswerFormat)
        
        let concentrationQuestionThree = ORKFormItem(identifier: "concentrationQuestionThree", text: "Menos 7", answerFormat: numericAnswerFormat)
        
        let concentrationQuestionFour = ORKFormItem(identifier: "concentrationQuestionFour", text: "Menos 7", answerFormat: numericAnswerFormat)
        
        let concentrationQuestionFive = ORKFormItem(identifier: "concentrationQuestionFive", text: "Menos 7", answerFormat: numericAnswerFormat)
        
        concentrationForm.formItems = [concentrationQuestionOne, concentrationQuestionTwo, concentrationQuestionThree, concentrationQuestionFour, concentrationQuestionFive]
        steps.append(concentrationForm)
        
        // lenguaje y construcción
        let languajeInstructionsStep = ORKInstructionStep(identifier: "languajeInstructions")
        languajeInstructionsStep.title = "Lenguaje y construcción"
        languajeInstructionsStep.text = "Ahora se va a evaluar su capacidad de lenguaje, construcción y reconocimiento de objetos."
        steps.append(languajeInstructionsStep)
        
        let watchImageInstructionStep = ORKInstructionStep(identifier: "watchImageInstructionStep")
        watchImageInstructionStep.title = "Lenguaje y construcción"
        watchImageInstructionStep.text = "Observa la imagen"
        watchImageInstructionStep.image = UIImage(named: "Watch")
        watchImageInstructionStep.imageContentMode = .scaleAspectFit
        steps.append(watchImageInstructionStep)
        
        let watchImageQuestion = ORKQuestionStep(identifier: "watchImageQuestion", title: "Lenguaje y construcción", question: "Cuál es el nombre del objeto de la imagen?", answer: textAnswerFormat)
        steps.append(watchImageQuestion)
        
        let pencilImageInstructionStep = ORKInstructionStep(identifier: "pencilImageInstructionStep")
        pencilImageInstructionStep.title = "Lenguaje y construcción"
        pencilImageInstructionStep.text = "Observa la imagen"
        pencilImageInstructionStep.image = UIImage(named: "Pencil")
        pencilImageInstructionStep.imageContentMode = .scaleAspectFit
        steps.append(pencilImageInstructionStep)
        
        let pencilImageQuestion = ORKQuestionStep(identifier: "pencilImageQuestion", title: "Lenguaje y construcción", question: "Cuál es el nombre del objeto de la imagen?", answer: textAnswerFormat)
        steps.append(pencilImageQuestion)
        
        let letterQuestion = ORKQuestionStep(identifier: "letterQuestion", title: "Lenguaje y construcción", question: "Escriba una frase como si estuviera contando algo en una carta.", answer: textLetterAnswerFormat)
        steps.append(letterQuestion)
        
        // dibujo
        //let drawInstructionsStep = ORKInstructionStep(identifier: "drawInstrctionsStep")
        //drawInstructionsStep.title = "Lenguaje y construcción"
        //drawInstructionsStep.text = "A continuación, se te mostrará una figura. Por favor, cópiala en el área de dibujo a continuación."
        //drawInstructionsStep.image = UIImage(named: "Geometric Draw")
        //drawInstructionsStep.imageContentMode = .scaleAspectFit
        //steps.append(drawInstructionsStep)
        
        //let drawingStep = ORKFormStep(identifier: "drawingStep", title: "Lenguaje y construcción", text: "Dibuja la figura aquí:")
        //drawingStep.formItems = [ORKFormItem(identifier: "drawingItem", text: nil, answerFormat: ORKAnswerFormat.imageAnswerFormat())]
        //steps.append(drawingStep)

        // memoria
        let memoryQuestion = ORKQuestionStep(identifier: "memoryQuestion", title: "Memoria", question: "Recuerda el ultimo resultado que le dio en la sección de Concentración y cálculo? Escribalo.", answer: textAnswerFormat)
        steps.append(memoryQuestion)
        
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
        formInstructionsStep.imageContentMode = .scaleAspectFit
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
