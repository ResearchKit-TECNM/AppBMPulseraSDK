# Modelo de control de usuario USER
## Estructura User
Esta define un tipo de dato que tiene como objetivo controlar y llevar un registro de las acciones del usuario en la aplicación mediante sus propiedades, por ejemplo, asegurarse que solo pueda llenar una los formularios. 
### Propiedades
* **consentDocumentURL**: almacena la URL del documento de consentimiento del usuario en Firebase para unirse al estudio.
* **hasAccepted**: empleada para saber si el usuario ha aceptado unirse al estudio.
* **madeMMSE**: empleada para saber si ha llenado el formulario MMSE.
* **madeIPAQ**: empleada para saber si ha llenado el formulario IPAQ.
* **madeMR**: empleada para saber si ha llenado el formulario Historia Médica.
* **uid**: almacena la UID unica del usuario al momento de iniciar sesión en la aplicación.
> [!IMPORTANT]
> Para hacer un buen uso de esta estructura, esta ha de ser usada unicamente mediante la clase UserManager para tener los datos actualizados.

## UserManager
Este archivo contiene la clase _UserManager_ el cual tiene la función de manejar o permitir la interacción con la estructura User y poder gestionar la aplicación entre los diferentes archivos.

La clase hace uso del modelo _singleton_ para tener una unica instancia en todo el proyecto

### Propiedades
* user: instancia de la estructura User para hacer uso de ella.
* collectionName: nombre de la coleción de Firestore donde se han de guardar los valores de la estructura User para poder ser recuperada.

### Métodos
* **loadUser(uid: String, completion: @escaping (Result<User, Error>) -> Void)**: este tiene como objetivo cargar los datos de la estructura User de Firestore los cuales estan almacenados de la siguiente manera _/collectionName/user.uid/document/_, de no haber valores previos entonces se asignan unos por defecto a cada propiedad de User. Si la operación tiene exito entonces devuelve el objeto **unicamente** para conocer sus valores por la terminal _completion(.success(self.user))_, si falla entonces devuelve un mensaje de error __completion(.failure(notFoundError))_.
* **saveUser(completion: @escaping (Bool) -> Void)**: este tiene como objetivo almacenar los valores de la estructura User en un momento dato (por ejemplo al cerrar la aplicación), los valores del documento tienen el mismo nombre que el de la estructura para evitar errores. Si la operación es exitosa entonces devulve True, si falla entonces devuelve False.

> [!NOTE]
> Para almacenar la estructura en Firestore esta debe de ser el tipo _DATA_ el cual es similar a un archivo _JSON_.
