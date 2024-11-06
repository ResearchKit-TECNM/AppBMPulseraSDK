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
        let memoryQuestion = ORKQuestionStep(identifier: "memoryQuestion", title: "Memoria", question: "Recuerda el ultimo resultado que le di o en la sección de Concentración y cálculo? Escribalo.", answer: textAnswerFormat)
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
    
    func createMedicalRecordTask() -> ORKOrderedTask {
        var steps = [ORKStep]()
        
        let textAnswerFormat = ORKTextAnswerFormat(maximumLength: 80)
        
        // Instrucciones iniciales
        let formInstructionsStep = ORKInstructionStep(identifier: "instructions")
        formInstructionsStep.title = "Cuestionario de historial médico."
        formInstructionsStep.text = "El presente cuestionario tiene como objetivo conocer sus capacidades físicas y reunir información revelante para el estudio. Toda la información que ingrese es privada y solo será utilizada para el mismo."
        formInstructionsStep.image = UIImage(systemName: "heart.fill")
        formInstructionsStep.imageContentMode = .scaleAspectFit
        steps.append(formInstructionsStep)
        
        let personalInfoStep = ORKInstructionStep(identifier: "personalInfoStep")
        personalInfoStep.title = "Información personal"
        personalInfoStep.text = "Acontinuación se te pedirá datos de tu información personal"
        personalInfoStep.image = UIImage(systemName: "person.fill")
        steps.append(personalInfoStep)
        
        let nameQuestionStep = ORKQuestionStep(identifier: "nameQuestion", title: "Nombre", question: "¿Cuál es tu nombre?", answer: textAnswerFormat)
        steps.append(nameQuestionStep)
        
        let gendChoices = [
            ORKTextChoice(text: "Hombre", value: "male" as NSString),
            ORKTextChoice(text: "Mujer", value: "female" as NSString),
            ORKTextChoice(text: "Prefiero no decirlo", value: "Inf" as NSString)]
        let genderChoiceFormat = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: gendChoices)
        let sexGenderQuestionStep = ORKQuestionStep(identifier: "sexQuestion", title: "¿Sexo", question: "¿Cuál es tu sexo?", answer: genderChoiceFormat)
        sexGenderQuestionStep.isOptional = false
        steps.append(sexGenderQuestionStep)
        
        let ageQuestion = ORKFormItem(sectionTitle: "¿Cuántos años tienes?")
        let ageAnswerFormat = ORKNumericAnswerFormat(style: .integer, unit: nil, minimum: 16, maximum: 120)
        let ageQuestionFormItem = ORKFormItem(identifier: "ageQuestion", text: nil, answerFormat: ageAnswerFormat)
        ageQuestionFormItem.placeholder = "Presiona aquí"
        ageQuestionFormItem.isOptional = false
        let ageForm = ORKFormStep(identifier: "ageQuestion", title: "Edad", text: " ")
        ageForm.formItems = [ageQuestion, ageQuestionFormItem]
        ageForm.isOptional = false
        steps.append(ageForm)
        
        // peso
        let weightChoices = (35...200).map { ORKTextChoice(text: "\($0) kg", value: "\($0) kg" as NSString) }
        let weightAnswerFormat = ORKValuePickerAnswerFormat(textChoices: weightChoices)
        let weightQuestionStep = ORKQuestionStep(identifier: "weightQuestion", title: "Peso", question: "¿Cuál es tu peso?", answer: weightAnswerFormat)
        weightQuestionStep.isOptional = false
        steps.append(weightQuestionStep)

        // estatura
        let heightChoices = (130...210).map { ORKTextChoice(text: "\($0) cm", value: "\($0) cm" as NSString) }
        let heightAnswerFormat = ORKValuePickerAnswerFormat(textChoices: heightChoices)
        let heightQuestionStep = ORKQuestionStep(identifier: "heightQuestion", title: "Estatura", question: "¿Cuánto mides?", answer: heightAnswerFormat)
        heightQuestionStep.isOptional = false
        steps.append(heightQuestionStep)
        
        // residencia
        let residenceChoice = "Residencia"
        let residenceChoices = [
            ORKTextChoice(text: "Urbana", value: "urban" as NSString),
            ORKTextChoice(text: "Sub-Urbana", value: "sub-urban" as NSString),
            ORKTextChoice(text: "Rural", value: "rural" as NSString)]
        let residenceChoiceFormat = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: residenceChoices)
        let residenceQuestionStep = ORKQuestionStep(identifier: "residenceQuestion", title: residenceChoice,question: "¿En que tipo de zona vives?", answer: residenceChoiceFormat)
        residenceQuestionStep.isOptional = false
        steps.append(residenceQuestionStep)
        
        // ocupación
        let occupationQuestionTitle = "Ocupación"
        let occupationChoices = [
            ORKTextChoice(text: "Estudiante", value: "student" as NSString),
            ORKTextChoice(text: "Empleado", value: "employee" as NSString),
            ORKTextChoice(text: "Emprendedor", value: "entrepreneur" as NSString),
            ORKTextChoice(text: "Desempleado", value: "unemployed" as NSString),
            ORKTextChoice(text: "Retirado", value: "retired" as NSString),
            ORKTextChoice(text: "Hogar", value: "home" as NSString),
            ORKTextChoice(text: "Otro", value: "other" as NSString)]
        let occupationChoiceFormat = ORKValuePickerAnswerFormat(textChoices: occupationChoices)
        let occupationQuestionStep = ORKQuestionStep(identifier: "occupationQuestion", title: occupationQuestionTitle, question: "¿A que te dedicas?", answer: occupationChoiceFormat)
        occupationQuestionStep.isOptional = false
        steps.append(occupationQuestionStep)
        
        // información adicional de ocupación
        let specifyOccupationAnswerFormat = ORKTextAnswerFormat(maximumLength: 200)
        specifyOccupationAnswerFormat.multipleLines = true // Permitir múltiples líneas para detalles extensos
        let occupationFormStep = ORKFormStep(identifier: "07Ocupacion", title: "Ocupación", text: "Especifica si es necesario.")
        occupationFormStep.formItems = [
            ORKFormItem(identifier: "occupationQuestion2", text: nil, answerFormat: occupationChoiceFormat),
            ORKFormItem(identifier: "occupationQuestion3", text: nil, answerFormat: specifyOccupationAnswerFormat)
        ]
        steps.append(occupationFormStep)

        //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-

        // Heredo Familiares
        let hereditaryInfoStepTitle = "Historial Patológico Heredofamiliar"
        let hereditaryInfoStep = ORKInstructionStep(identifier: "hereditaryInfoStep")
        hereditaryInfoStep.title = hereditaryInfoStepTitle
        hereditaryInfoStep.text = "En esta área te preguntaremos acerca de las enfermedades que padecen en tu familia"
        hereditaryInfoStep.image = UIImage(systemName: "person.3.fill")

        // patologias hereditarias
        let patologyChoice = "Patologías"
        let patologyChoices = [
            ORKTextChoice(text: "Diabetes", value: "diabetes" as NSString),
            ORKTextChoice(text: "Cardiopatias", value: "cardiopatias" as NSString),
            ORKTextChoice(text: "Hipertensión", value: "hypertension" as NSString),
            ORKTextChoice(text: "Cáncer", value: "cancer" as NSString),
            ORKTextChoice(text: "Asma", value: "asthma" as NSString),
            ORKTextChoice(text: "Otro", value: "other" as NSString),
            ORKTextChoice(text: "Ninguna", value: "none" as NSString)
        ]
        let patologyChoiceFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice, textChoices: patologyChoices)
        let patologyQuestionStep = ORKQuestionStep(identifier: "pathologiesQuestion", title: patologyChoice, question: "Selecciona unicamente las patologías que tienen o hayan tenido tus padres o tus abuelos", answer: patologyChoiceFormat)
        patologyQuestionStep.isOptional = false
        steps.append(patologyQuestionStep)
        
        // patologías mentales hereditarias
        let mentalPatologyChoice = "Patologías Mentales"
        let mentalPatologyChoices = [
            ORKTextChoice(text: "Bipolaridad", value: "bipolarity" as NSString),
            ORKTextChoice(text: "Autismo", value: "autism" as NSString),
            ORKTextChoice(text: "Depresión", value: "depression" as NSString),
            ORKTextChoice(text: "TDAH", value: "TDAH" as NSString),
            ORKTextChoice(text: "Ansiedad", value: "anxiety" as NSString),
            ORKTextChoice(text: "Otro", value: "other" as NSString),
            ORKTextChoice(text: "Ninguna", value: "none" as NSString)
        ]
        let mentalPatologyChoiceFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice, textChoices: mentalPatologyChoices)
        let mentalPatologyQuestionStep = ORKQuestionStep(identifier: "mentalPathologiesQuestion", title: mentalPatologyChoice, question: "Selecciona solo las patologías mentales que tienen o tuvieron tus familiares cercanos como padre, madre, abuelo o abuela.", answer: mentalPatologyChoiceFormat)
        mentalPatologyQuestionStep.isOptional = false
        steps.append(mentalPatologyQuestionStep)

        //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
              
        // antecedentes personales patológicos
        let persInfoStepTitle = "Historial Patológico Personal"
        let persInfoStep = ORKInstructionStep(identifier: "persInfoStep")
        persInfoStep.title = persInfoStepTitle
        persInfoStep.text = "En esta sección te haremos preguntas con respecto a las enfermedades que has padecido o padeces"
        persInfoStep.image = UIImage(systemName: "person.crop.circle")
        steps.append(persInfoStep)
        
        // enfermedades propias
        let diseasesChoice = "Enfermedades"
        let diseasesChoices = [
            ORKTextChoice(text: "Diabetes", value: "diabetes" as NSString),
            ORKTextChoice(text: "Cardiopatías", value: "cardiopatias" as NSString),
            ORKTextChoice(text: "Hipertension", value: "hypertension" as NSString),
            ORKTextChoice(text: "Cáncer", value: "cancer" as NSString),
            ORKTextChoice(text: "Asma", value: "asthma" as NSString),
            ORKTextChoice(text: "Hepatitis", value: "hepatitis" as NSString),
            ORKTextChoice(text: "Covid", value: "covid" as NSString),
            ORKTextChoice(text: "Tuberculosis", value: "tuberculosis" as NSString),
            ORKTextChoice(text: "SIDA", value: "SIDA" as NSString),
            ORKTextChoice(text: "Bipolaridad", value: "bipolarity" as NSString),
            ORKTextChoice(text: "Autismo", value: "autism" as NSString),
            ORKTextChoice(text: "Depresión", value: "depression" as NSString),
            ORKTextChoice(text: "TDAH", value: "TDAH" as NSString),
            ORKTextChoice(text: "Ansiedad", value: "anxiety" as NSString),
            ORKTextChoice(text: "Otro", value: "other" as NSString),
            ORKTextChoice(text: "Ninguna", value: "none" as NSString)]
        
        let diseasesChoiceFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice, textChoices: diseasesChoices)
        let diseasesQuestionStep = ORKQuestionStep(identifier: "personalPathologiesQuestion", title: diseasesChoice, question: "Selecciona las enfermedades que has padecido o padeces.", answer: diseasesChoiceFormat)
        diseasesQuestionStep.isOptional = false
        steps.append(diseasesQuestionStep)
        
        // vacunación
        let vaccinationQuestionTitle = "Vacunación"
        let vaccinationChoices = [
            ORKTextChoice(text: "Si", value: "yes" as NSString),
            ORKTextChoice(text: "No", value: "no" as NSString),
            ORKTextChoice(text: "No recuerdo", value: "dont remember" as NSString)
        ]
        let vaccinationChoiceFormat = ORKValuePickerAnswerFormat(textChoices: vaccinationChoices)
        let vaccinationQuestionStep = ORKQuestionStep(identifier: "vaccinationQuestion", title: vaccinationQuestionTitle, question: "¿Tienes tu esquema de vacunación completo?", answer: vaccinationChoiceFormat)
        vaccinationQuestionStep.isOptional = false
        steps.append(vaccinationQuestionStep)

        // bebe alcohol?
        let alcoholQuestionTitle = "Bebedor de Alcohol"
        let alcoholChoices = [
            ORKTextChoice(text: "No bebo alcohol", value: "no alcohol" as NSString),
            ORKTextChoice(text: "Bebedor Social", value: "social drinker" as NSString),
            ORKTextChoice(text: "Bebedor Ocasional", value: "occasional drinker" as NSString),
            ORKTextChoice(text: "Dependiente del Alcohol", value: "dependent drinker" as NSString)]
        let alcoholChoiceFormat = ORKValuePickerAnswerFormat(textChoices: alcoholChoices)
        let alcoholQuestionStep = ORKQuestionStep(identifier: "alcoholQuestion", title: alcoholQuestionTitle, question: "¿Que tipo de bebedor de alcohol eres?", answer: alcoholChoiceFormat)
         alcoholQuestionStep.isOptional = false
        steps.append(alcoholQuestionStep)
        
        // tabaco
        let smokeQuestionTitle = "Fumador de Tabaco"
        let smokeChoices = [
            ORKTextChoice(text: "No fumador", value: "no smoker" as NSString),
            ORKTextChoice(text: "Fumador Social", value: "social smoker" as NSString),
            ORKTextChoice(text: "Fumador Ocasional", value: "occasional smoker" as NSString),
            ORKTextChoice(text: "Dependiente del tabaco", value: "dependent smoker" as NSString)
        ]
        let smokeChoiceFormat = ORKValuePickerAnswerFormat(textChoices: smokeChoices)
        let smokeQuestionStep = ORKQuestionStep(identifier: "tobaccoQuestion", title: smokeQuestionTitle, question: "¿Que tipo de fumador eres?", answer: smokeChoiceFormat)
         smokeQuestionStep.isOptional = false
        steps.append(smokeQuestionStep)

        // drogas
        // cambiar la pregunta a una menos comprometedora y aclaracion del uso de la informacion
        let drugsPatologyChoice = "Drogas"
        let drugsPatologyChoices = [
            ORKTextChoice(text: "No consumo drogas", value: "no drugs" as NSString),
            ORKTextChoice(text: "Marihuana", value: "marihuana" as NSString),
            ORKTextChoice(text: "Cocaina", value: "cocaine" as NSString),
            ORKTextChoice(text: "MDMA (Extasis)", value: "MDMA" as NSString),
            ORKTextChoice(text: "Heroina", value: "heroina" as NSString),
            ORKTextChoice(text: "Metanfetaminas", value: "methamphetamine" as NSString),
            ORKTextChoice(text: "LSD", value: "LSD" as NSString),
            ORKTextChoice(text: "Hongos Alucionógenos", value: "hallucinogenic mushrooms" as NSString),
            ORKTextChoice(text: "Otro", value: "other" as NSString)
        ]
        let drugsPatologyChoiceFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice, textChoices: drugsPatologyChoices)
        let drugsPatologyQuestionStep = ORKQuestionStep(identifier: "drugsQuestion", title: drugsPatologyChoice, question: "Selecciona la sustancia o sustancias que consumes", answer: drugsPatologyChoiceFormat)
            drugsPatologyQuestionStep.isOptional = false
        steps.append(drugsPatologyQuestionStep)
        
        let frecuencyDrugsQuestionTitle = "Frecuencia de uso de sustancias"
        let frecuencyDrugsChoices = [
            ORKTextChoice(text: "Nunca", value: "never" as NSString),
            ORKTextChoice(text: "Poco", value: "bit" as NSString),
            ORKTextChoice(text: "Moderado", value: "moderate" as NSString),
            ORKTextChoice(text: "Mucho", value: "a lot" as NSString)
        ]
        let frecuencyDrugsChoiceFormat = ORKValuePickerAnswerFormat(textChoices: frecuencyDrugsChoices)
        let frecuencyDrugsQuestionStep = ORKQuestionStep(identifier: "drugsFrecuencyQuestion", title: frecuencyDrugsQuestionTitle, question: "¿Con que frecuencia consumes dichas sustancias?", answer: frecuencyDrugsChoiceFormat)
        frecuencyDrugsQuestionStep.isOptional = false
        steps.append(frecuencyDrugsQuestionStep)

        //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
            
        // Antecedentes no patológicos
                
        let noPersInfoStepTitle = "Historial No Patológico"
        let noPersInfoStep = ORKInstructionStep(identifier: "NoPathological")
        noPersInfoStep.title = noPersInfoStepTitle
        noPersInfoStep.text = "En esta sección, encontrará preguntas sobre sus antecedentes no patológicos, como sus actividades diarias y hábitos personales."
        noPersInfoStep.image = UIImage(systemName: "book.fill")
        steps.append(noPersInfoStep)

        // pregunta de actividad física en escala de likert
        let scaleQuestionStepTitle = "Actividad Física"
        let scaleAnswerFormat = ORKScaleAnswerFormat(maximumValue: 10, minimumValue: 0, defaultValue: 0, step: 1)
        let scaleQuestionStep = ORKQuestionStep(identifier: "physicalActivityQuestion", title: scaleQuestionStepTitle,question: "¿Que tan activo eres?", answer: scaleAnswerFormat)
        scaleQuestionStep.isOptional = false
        steps.append(scaleQuestionStep)
        
        // Tipo de actividad fisica que realizas.
        let multiChoiceQuestionStepTitle = "¿Que tipo de actividades físicas realizas?"
        let textChoices = [
            ORKTextChoice(text: "Caminar", value: "walk" as NSString),
            ORKTextChoice(text: "Correr", value: "run" as NSString),
            ORKTextChoice(text: "Nadar", value: "swim" as NSString),
            ORKTextChoice(text: "Ciclismo", value: "cycling" as NSString),
            ORKTextChoice(text: "Futbol", value: "soccer" as NSString),
            ORKTextChoice(text: "Basquetbol", value: "basketball" as NSString),
            ORKTextChoice(text: "Tenis", value: "tennis" as NSString),
            ORKTextChoice(text: "Beisbol", value: "baseball" as NSString),
            ORKTextChoice(text: "Golf", value: "golf" as NSString),
            ORKTextChoice(text: "Atletismo", value: "athletics" as NSString),
            ORKTextChoice(text: "Futbol Americano", value: "american soccer" as NSString),
            ORKTextChoice(text: "Artes Marciales", value: "martial arts" as NSString),
            ORKTextChoice(text: "Otro", value: "other" as NSString),
            ORKTextChoice(text: "Ninguno", value: "none" as NSString)
        ]
        
        let multiChoiceAnswerFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice, textChoices: textChoices)
        let multiChoiceQuestionStep = ORKQuestionStep(identifier: "typePhysicalActivityQuestion", title: multiChoiceQuestionStepTitle, question: "Selecciona las actividades que hagas regularmente", answer: multiChoiceAnswerFormat)
        multiChoiceQuestionStep.isOptional = false
        steps.append(multiChoiceQuestionStep)
        
        // hobbies
        let hobbieQuestionStepTitle = "¿Cuales son tus Hobbies?"
        let hobbietextChoices = [
            ORKTextChoice(text: "Leer", value: "read" as NSString),
            ORKTextChoice(text: "Ver Películas y Series", value: "watch movies and series" as NSString),
            ORKTextChoice(text: "Jugar videojuegos", value: "play videogames" as NSString),
            ORKTextChoice(text: "Cocinar y hornear", value: "cook" as NSString),
            ORKTextChoice(text: "Viajar", value: "travel" as NSString),
            ORKTextChoice(text: "Jardinería", value: "gardening" as NSString),
            ORKTextChoice(text: "Artes", value: "arts" as NSString),
            ORKTextChoice(text: "Musica", value: "music" as NSString),
            ORKTextChoice(text: "Fotografía", value: "photography" as NSString),
            ORKTextChoice(text: "Escribir", value: "write" as NSString),
            ORKTextChoice(text: "Bailar", value: "dance" as NSString),
            ORKTextChoice(text: "Otro", value: "other" as NSString),
            ORKTextChoice(text: "Ninguno", value: "none" as NSString)]
        let hobbieAnswerFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice, textChoices: hobbietextChoices)
        let hobbieQuestionStep = ORKQuestionStep(identifier: "hobbieQuestion", title: hobbieQuestionStepTitle, question: "Selecciona los hobbies que hagas con regularidad", answer: hobbieAnswerFormat)
        hobbieQuestionStep.isOptional = false
        steps.append(hobbieQuestionStep)

        // level of study
        let studyQuestionTitle = "Nivel de estudios"
        let studyChoices = [
            ORKTextChoice(text: "Primaria", value: "primaria" as NSString),
            ORKTextChoice(text: "Secundaria", value: "secundaria" as NSString),
            ORKTextChoice(text: "Preparatoria", value: "preparatoria" as NSString),
            ORKTextChoice(text: "Universidad", value: "univesidad" as NSString),
            ORKTextChoice(text: "Maestría", value: "maestría" as NSString),
            ORKTextChoice(text: "Doctorado", value: "doctorado" as NSString),
            ORKTextChoice(text: "Otro", value: "other" as NSString)
        ]
        let studyChoiceFormat = ORKValuePickerAnswerFormat(textChoices: studyChoices)
        let studyQuestionStep = ORKQuestionStep(identifier: "studyQuestion", title: studyQuestionTitle, question: "¿Cuál es tu nivel de estudios?", answer: studyChoiceFormat)
        studyQuestionStep.isOptional = false
        steps.append(studyQuestionStep)
        
        // transporte
        let transportationQuestionTitle = "Medios de transporte"
        let transportationChoices = [
            ORKTextChoice(text: "Trabajo desde casa", value: "telecommuting" as NSString),
            ORKTextChoice(text: "Carro", value: "car" as NSString),
            ORKTextChoice(text: "Transporte público (autobus, metro, tren, otro)", value: "public transport" as NSString),
            ORKTextChoice(text: "Bicicleta", value: "bicycle" as NSString),
            ORKTextChoice(text: "Motocicleta", value: "motorcycle" as NSString),
            ORKTextChoice(text: "Caminando", value: "walking" as NSString),
            ORKTextChoice(text: "Scooter electrica", value: "electricscooter" as NSString),
            ORKTextChoice(text: "Skateboard", value: "skateboard" as NSString),
            ORKTextChoice(text: "Otro", value: "other" as NSString)]
        let transportationChoiceFormat = ORKValuePickerAnswerFormat(textChoices: transportationChoices)
        let transportationQuestionStep = ORKQuestionStep(identifier: "transportationQuestion", title: transportationQuestionTitle, question: "¿Cuál es el medio de transporte que utiliza desde su casa al trabajo o escuela?", answer: transportationChoiceFormat)
        transportationQuestionStep.isOptional = false
        steps.append(transportationQuestionStep)

        //Alimentación
        // cuantas veces comes
        let alimentationQuestionStepTitle = "Alimentación"
        let alimentationAnswerFormat = ORKScaleAnswerFormat(maximumValue: 10, minimumValue: 0, defaultValue: 0, step: 1)
        let feedingQuestionStep = ORKQuestionStep(identifier: "feedingQuestion", title: alimentationQuestionStepTitle,question: "¿Cuantas comidas haces por día?", answer: alimentationAnswerFormat)
        feedingQuestionStep.isOptional = false
        steps.append(feedingQuestionStep)

        // tipo de alimento
        //modificar la pregunta
        let typeFoodChoice = "Tipos de comida"
        let typeFoodChoices = [
            ORKTextChoice(text: "Pollo", value: "chicken" as NSString),
                ORKTextChoice(text: "Res", value: "beef" as NSString),
                ORKTextChoice(text: "Cerdo", value: "pig" as NSString),
                ORKTextChoice(text: "Marina", value: "marina" as NSString),
                ORKTextChoice(text: "Frutas/Vegetales", value: "fruits/vegetables" as NSString),
                ORKTextChoice(text: "Otros", value: "other" as NSString)]
        let typeFoodChoiceFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice, textChoices: typeFoodChoices)
        let typeFoodQuestionStep = ORKQuestionStep(identifier: "typeFoodQuestion", title: typeFoodChoice, question: "¿Que tipo de comida consumes?", answer: typeFoodChoiceFormat)
        typeFoodQuestionStep.isOptional = false
        steps.append(typeFoodQuestionStep)

        //Fin de la prueba
        let completionStep = ORKCompletionStep(identifier: "completion")
        completionStep.title = "Fin del cuestionario!"
        completionStep.text = "Gracias por completar el cuestionario y por tomarte tu tiempo!"
        completionStep.iconImage = UIImage(systemName: "checkmark.seal")
        completionStep.detailText = "Historia clinica completa."
        steps.append(completionStep)
        
        return ORKOrderedTask(identifier: "MedicalRecord", steps: steps)
    }
}
