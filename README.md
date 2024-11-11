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
Para añadir las dependencias de Firebase, primero necesitamos tener un proyecto creado en el sitio oficial de *[Firebase][4]*. Luego nos dirigimos a la consola _(Go to console)_, una vez ahí seleccionamos la opción de crear un nuevo proyecto e ingresamos un nombre, en este caso es _FirebaseBiomarkers_, agregamos **Google Analytics** para obtener metricas del proyecto, esto es importante ya que ayudará a testear el proyecto y las aplicaciones integradas.

Ya una vez hecho esto seleccionamos la opción de agregar una app, en este caso es de Apple. Luego ingresamos el ID del paquete de apple, este puede ser como el siguiente: **com.group.AppWithFirebase**

imagen 

Posteriormente descargamos el archivo **GoogleService-Info.plist** y lo agregamos a nuestro proyecto tal cual se nos indica en el ejemplo.

> [!IMPORTANT]  
> Siempre que se agregen, muevan o eliminen archivos en el proyecto de Xcode debe de hacerce mediante el IDE, ya que de otra manera podrian ocurrir errores.

imagen

Para agregar el framework de Firebase al proyecto, en este caso se hará mediante el gestor de dependencias de Xcode y no mediante Cocoapods, para eso nos dirigimos a **Archivo** y luego a **Agregar paquete de dependencias**

imagen

Una vez ahí ingresamos el siguiente link `https://github.com/firebase/firebase-ios-sdk` en el cuadro de busqueda

imagen

Despues añadimos todos los paquetes requeridos, aunque en un inicio basta con añadir Firebase Analytics. Una vez añadidos todos los paquetes estos deben de aparecer en la parte inferior izquierda del IDE, en **Paquete de dependencias**

imagen

Y finalmente, en el archivo **AppDelegate.swift** agregamos la siguiente linea `FirebaseApp.configure()`, quedando algo como esto 

```

import UIKit

import FirebaseCore


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {


  var window: UIWindow?


  func application(_ application: UIApplication,

    didFinishLaunchingWithOptions launchOptions:

      [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    FirebaseApp.configure()

    return true

  }

}

```

Esto es importante ya que sin dicha linea Firebase no se iniciará junto con la aplicación al correrla. Y asi queda finalmente instalado Firebase en el proyecto.

## Links de interes
* [FIREBASE iOS 🔥 Curso XCODE desde CERO][5]
* [Research Kit + Apple Watch Tutorial: Part 1][6]


[1]: https://github.com/researchkit/researchkit
[2]: https://gist.github.com/sye8/5472c425439e134ecd4afeee0957e38b
[3]: https://developer.mozilla.org/es/docs/Glossary/MVC
[4]: https://firebase.google.com/?hl=es-419
[5]: https://www.youtube.com/watch?v=1EAA8WgCQas&t=1830s
[6]: https://sigabrt428661558.wordpress.com/tutorials/swift/researchkit/research-kit-apple-watch-tutorial-part-1/
