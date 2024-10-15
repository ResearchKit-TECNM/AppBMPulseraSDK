//  Created by Luis Mora on 15/10/24.
//

# Documentación del proyecto
El presente archivo tiene como finalidad documentar el desarrollo de la aplicación final del proyecto **Desarrollo de bases de datos y un dispositivo wearable para el estudio del sedentarismo y su relación con el deterioro cognitivo**. Este repositorio es el proyecto integrador de los otros proyectos en los cuales se realizarón las pruebas de las diferentes herramientas requeridas para su realización.

## Instalación de dependencias

### ResearchKit
En esta version del proyecto, la instalación de las dependencias se realizó mediante el gestor de paquetes de Xcode y no mediante Cocoapods, ya que este ultimo presento multiples errores de incompatibilidad con la versión 16 de Xcode.

Primero, para instalar ResearchKit se descargó del siguiente link: *[ResearchKit/ResearchKit][1]*. Una vez descargado y descomprimido en una carpeta de donde no lo vayamos a mover, se seleciona el archivo **.xcodeproj** y se referencia a nuestro proyecto en la ventana de xcode de la siguiente manera:

<img src="./src/img/Captura de pantalla 2024-10-10 a la(s) 1.24.13 p.m..png">.

Una vez hecho esto, añadimos los siguientes frameworks al target de nuestro proyecto como en la siguiente imagen:

<img src="./src/img/Captura de pantalla 2024-10-15 a la(s) 1.43.09 p.m..png">

Y como media de prevención de errores se desactivo el sandbox del proyecto en **Built Settings / Built Options** como en la imagen:

<img src = "./src/img/Captura de pantalla 2024-10-15 a la(s) 1.43.27 p.m..png">

### Firebase
Para añadir las dependencias de Firebase, primero necesitamos tener un proyecto creado en el sitio oficial de *[Firebase][4]*

## Obteniendo el consentimiento del usuario
La primera tarea que el usuario realize cuando abra la aplicación es llenar y firmar el documento de consentimiento, lo cual puede llegar a ser algo complejo si no se tiene un buen dominio de ResearchKit, debido a esto y para llevar a cabo este punto se tomo como referencia el siguiente repositorio *[Research Kit + Apple Watch Tutorial (Swift 3) - Part 1: Obtaining Consent and Generating PDF][2]*. Cabe decir que este es un proyecto generado en el 2018 con la versión de 2.X de ResearchKit, aunque gran parte del código aun funciona, han habido algunos cambios puntuales en la dependencia, por lo cual el código generado en el presente punto puede estar sujeto a cambios para un optimo funcionamiento.

Antes de empezar es importante mencionar que el desarrollo del código del proyecto se realizó bajo el patrón de diseño *[MVC][3]* (Modelo, Vista, Controlador) con el fin de garantizar que el código sea escalable y mantenible a travez del tiempo


[1]: https://github.com/researchkit/researchkit
[2]: https://gist.github.com/sye8/5472c425439e134ecd4afeee0957e38b
[3]: https://developer.mozilla.org/es/docs/Glossary/MVC
[4]: https://firebase.google.com/?hl=es-419
