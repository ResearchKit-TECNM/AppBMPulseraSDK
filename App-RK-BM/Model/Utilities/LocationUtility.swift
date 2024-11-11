//
//  LocationUtility.swift
//  App-RK-BM
//
//  Created by Luis Mora on 31/10/24.
//

import CoreLocation

class LocationUtility: NSObject, CLLocationManagerDelegate {
    static let shared = LocationUtility() // Singleton
    
    let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    var userCountry: String = ""
    var userState: String = ""
    var userLocality: String = ""
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation() // Comienza a recibir actualizaciones de la ubicación
    }
    
    func requesLocation() {
        locationManager.requestLocation()
    }
        
    // Método para manejar la ubicación obtenida
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\t Ubicación actualizada: \(locations)")
        guard let location = locations.last else { return }
        fetchLocationDetails(location: location) { country, state, locality in
            DispatchQueue.main.async {
                if let country = country, let state = state, let locality = locality {
                    self.userCountry = country
                    self.userState = state
                    self.userLocality = locality
                    print("Ubicación almacenada: \(country), \(state), \(locality)")
                    NotificationCenter.default.post(name: .locationReady, object: nil)
                }
            }
        }
        self.locationManager.stopUpdatingLocation() // Detenemos la actualización si solo necesitamos una vez
    }

    // Función para obtener detalles de ubicación usando CLGeocoder
    private func fetchLocationDetails(location: CLLocation, completion: @escaping (String?, String?, String?) -> Void) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error al obtener los detalles de la ubicación: \(error.localizedDescription)")
                completion(nil, nil, nil)
                return
            }
                
            if let placemark = placemarks?.first {
                let country = placemark.country
                let state = placemark.administrativeArea
                let locality = placemark.locality
                completion(country, state, locality)
            } else {
                completion(nil, nil, nil)
            }
        }
    }
        
    // Manejo de errores en caso de falla
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicación: \(error.localizedDescription)")
    }
    
    // Opcional: Método delegado para manejar cambios en el estado de autorización
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            self.startUpdatingLocation()
        } else {
            print("Permiso de ubicación denegado o restringido")
        }
    }
}

extension Notification.Name {
    static let locationUpdated = Notification.Name("locationUpdated")
    
    static let locationReady = Notification.Name("locationReady")
}
