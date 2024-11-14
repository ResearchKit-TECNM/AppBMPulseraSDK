# Documentación de utilidades
## Clase Date Utility
Esta tiene como fin contener todas las funciones referentes en cuanto al manejo de fechas en la aplicación.

### Métodos
* **getCurrentDate()**: este tiene como fin devolver 3 valores tipo String, el año, mes, número y nombre del dia actual, en español similar al siguiente ejemplo: _**Jueves-14-Noviembre-2024**_.

## Clase Location Utility
Esta clase tiene como fin gestionar la ubicación GPS actual del usuario en la aplicación. Hace uso del framework **CoreLocation** para poder trabajar con servicios de ubicación, se ha de heredar el protocolo_CLLocationManagerDelegate_ en la clase para manejar eventos relacionados con la ubicación.

### Propiedades
* **shared**: definición singleton para una unica intancia de la clase en todo el proyecto.
* **locationManager**: gestiona el servicio de ubicación.
* **geocoder**: empleada para la decodificación inversa de la ubicación el usuario.

### Variables
* **userCountry**: almacena el país del usuario.
* **userState**: almacena el estado del usuario.
* **userLocality**: almacena la localidad del usuario, como pueblo, o cuidad.

### Métodos
* **private override init()**: inicializador privado que configura el delegado y la precisión de la ubicación
* **requestLocationAuthorization()**: solicita el acceso a la ubicación cuando la aplicación esta siendo usada.
* **startUpdatingLocation()**: comienza a obtener la ubicación del usuario.
* **requesLocation()**: solicita una unica actualización de la ubicación actual del usuario.
* **locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])**: método delegado que es llamado cuando la ubicación del usuario es actualizada, llama a _fetchLocationDetails_ para obtener detalles de la ubicación del usuario y una vez hecho esto detiene la actualización de la ubicación.
* **fetchLocationDetails(location: CLLocation, completion: @escaping (String?, String?, String?) -> Void)**: realiza la geocodificación inversa del usuario para obtener detalles de su ubicación (país, estado y localidad) en base a sus coordenadas. Devuelve los datos en un _completion_
* **locationManager(_ manager: CLLocationManager, didFailWithError error: Error)**: contiene el código que se ha de ejecutar en caso de no poder obtener la ubicación del usuario por algun error.
* **locationManagerDidChangeAuthorization(_ manager: CLLocationManager)**: método que verifica si la aplicación tiene permisos de ubicación, si es asi entonces comienza a obtener la ubicación mediante el método _startUpdatingLocation()_

### Extensión Notification.Name
Aqui se definen notificaciones personalizadas que se han de usar para dar aviso a otras partes de la aplicación sobre cuando la ubicación ha sido actualizada o si esta disponible.

### Uso
1. Solicitar permisos para usar la ubicación: _ LocationUtility.shared.requestLocationAuthorization()_.
2. si se tienen permisos, se comienza a ibtener la ubicación de manera continua _startUpdatingLocation()_ o una unica vez _requesLocation()_.
3. Una vez obtenida la ubicación, se llama el método _fetchLocationDetails_ para obtener detalles de la ubicación.
4. Una vez obtenidos los detalles de la ubicación, estos se almacenan en las variables de LocationUtility para ser usadas en otras partes del código.
