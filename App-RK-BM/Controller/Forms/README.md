# Controlador de la vista de formularios
En esta sección del modelo MVC se encuentran dos archivos, _FormsViewController.swift_ y _FormTask.swift_. 

## FormTask
En este archivo se encuentran los formularios MMSE y IPAQ dentro de la clase con el mismo nombre del archivo, misma que esta establecida como un singleton class, _static let shared = FormTask()_, para ser posible acceder a ella desde cualquier punto.

El modo de acceder a los metodos de la clase es el siguiente: 
* FormTask.shared.---

Los formularios son devueltos como un _ORKOrderedTask_ de ResearchKit, esto permite presentar las preguntas del formulario de una manera secuencial, ordenada y bien estructurada.
La versión elegida para cada formulario se muestra a continuación y es importante ya que en base a ella y a su orden es como se muestran las preguntas.
<img src="">
<img src="">

Las respuestas del usuario a cada pregunta se ven ligadas a la pregunta en la cual se registraron, se este modo son filtradas y subidas a Firebase

## Formulario MMSE
Este es creado en la función _createMMSETask()_. en la siguiente tabla se relacionan las preguntas y los identificadores que les corresponden.
| Pregunta | Identificador |
|--------------|--------------|
| ¿Qué dia de la semana es? | timeQuestionWeekDay |
| ¿En qué año estamos? | timeQuestionYear |
| ¿En qué mes? | timeQuestionMonth |
| ¿Cuál es el número del dia de hoy? | timeQuestionDay |
| ¿En qué pais se encuentra? | spaceQuestionCountry |
| ¿En qué estado? | spaceQuestionArea |
| ¿En que cuidad o localidad? | spaceQuestionLocality |
| ¿100 menos 7? | concentrationQuestionOne |
| ¿Menos 7? | concentrationQuestionTwo |
| ¿Menos 7? | concentrationQuestionThree |
| ¿Menos 7? | concentrationQuestionFour |
| ¿Menos 7? | concentrationQuestionFive |
| ¿Cuál es el nombre del objeto de la imagen (Reloj)? | watchImageQuestion |
| ¿Cuál es el nombre del objeto de la imagen (boligráfo)? | pencilImageQuestion |
| Escriba una frase como si estuviera contando algo en una carta | letterQuestion |
| Recuerda el ultimo resultado que le di o en la sección de Concentración y cálculo? Escribalo | memoryQuestion |

Cabe decir que no todas las preguntas fueron incorporadas ya que de momento no hay forma de registrar requerida por el momento, como la pregunta de la sección "Fijación" y algunas otras de "Lenguaje y construcción".

Este formulario recibe el identificador "MMSE". Los identificadores tienen un papel importante ya que ayudan a filtrar e identificar las respuestas especificas del usuario a cada pregunta y formulario, la importancia de esto se ve mas a detalle en el archivo _FormsViewController_.

## Formulario IPAQ
Este es creado en la función _createIPAQTask()_ y sigue la misma lógica que el formulario MMSE. Los identificadores de cada pregunta se muestran a continuación
| Pregunta | Identificador |
|----------|---------------|
| 1. Durante los últimos 7 días ¿En cuántos realizo actividades físicas vigorosas tales como levantar pesos pesados, cavar, hacer ejercicios aeróbicos o andar rápido en bicicleta? | firstQuestionVigorous |
| 2. Habitualmente, ¿Cuánto tiempo en total en minutos dedicó a una actividad física intensa en uno de esos días? (ejemplo: si practicó 1 hora y 20 minutos ingrese 80 minutos) | secondQuestionVigorous |
| 3. Durante los últimos 7 días, ¿En cuántos días hizo actividades físicas moderadas como transportar pesos livianos, andar en bicicleta a velocidad regular o jugar a dobles en tenis? No incluya caminar. | thirdQuestionModerate |
| 4. Habitualmente, ¿Cuánto tiempo en total en minutos dedicó a una actividad física moderada en uno de esos días? (ejemplo: si practicó 1 hora y 20 minutos ingrese 80 minutos) | fourthQuestionModerate |
| 5. Durante los últimos 7 días, ¿En cuántos caminó por lo menos 10 minutos seguidos? | fifthQuestionWalk |
| 6. Habitualmente, ¿Cuánto tiempo en total en minutos dedicó a caminar en uno de esos días? | sixthQuestionWalk |
| 7. Habitualmente, ¿Cuánto tiempo en minutos pasó sentado durante un día hábil? | seventhQuestionSedentary |

Las respuesas a este formulario se dan en enteros, ello permite el cálculo de la clasificación de los niveles de actividad física, ya sea alto, moderado o bajo.

Finalmente este recibe el identificador "IPAQ"

## FormsViewController
Las principales funciones de este archivo es, en primer lugar, asegurarse que se los usuarios solo pueden llenar una unica vez cada formulario, esto se logra verificando los estados de la depencencia _UserManager_ en la función _buttonsFormsManager()_.
Cuando cada boton es presionado, si es que se encuentra activo, se presenta una vista generada por ResearchKit en base al ORKOrderedTask correspondiente generada en _FormTask.swift_ como se menciono anteriormente, ResearchKit se encarga de la presentación visual de las preguntas.

En `extension FormsViewController: ORKTaskViewControllerDelegate` se encuentra el código donde se gestionan los resultados de las vistas generadas por ResearchKit antes mencionadas.
El flujo de trabajo se esta sección es el siguiente: