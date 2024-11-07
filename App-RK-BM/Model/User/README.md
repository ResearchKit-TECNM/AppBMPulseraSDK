# Modelo de control de usuario USER
## UserManager
Este archivo contiene la clase _UserManager_ el cual tiene la función de manejar o permitir la interacción con el objeto User y poder gestionar la aplicación entre los diferentes archivos.

La clase esta instanciada como Singleton, para que solo exista una unica clase en todo el proyecto.

En `var user = User()` se crea la instancia de la clase user que contiene información de lo que ha hecho el usuario, esta propiedad debe de estar siempre actualizada con la versión de firebase.
 ### Método loadUser
La función o el método _loadUser_ crea una consulta en Firestore para obtener el documento del usuario correspondiente al uid de la sesión. Si el documento existe entonces se carga los datos del documento al objeto, y si no existe se devuelve un _NSError_ indicando que no ha sido posible encontrarlo.
Si no se encuentra el documento entonces se crea el objeto User con valores predeterminados o default. La forma en la que se asigna el valor de Firestore o default a las propiedades del objeto es como la siguiente: `self.user.hasAccepted = data["hasAccepted"] as? Bool ?? false`.
Es importante notar que el nombre de la propiedad en el documento de Firestore es el mismo que el de la propiedad del objeto local, esta es una manera "manual" pero más segura.

Finalmente, y dependiendo de si se ha podido o no cargar el documento al User, se devuelve un completion (cierre) que ha de pasar un argumento a un bloque de código correspondiente a la función cuando esta es utilizada, similar a cuando se usa el metodo _getDocument_ de Firestore.
Si se ha podido cargar el documento y asignarle los valores a User este lo devuelve _ completion(.success(self.user))_ y en caso contrario devuelve un error _completion(.failure(notFoundError))_
