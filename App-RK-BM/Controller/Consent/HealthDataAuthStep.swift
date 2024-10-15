//
//  HealthDataAuthstep.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 11/10/24.
//

import HealthKit
import ResearchKit

class HealthDataAuthStep: ORKActiveStep {
    
    let healthKitStore = HKHealthStore()
    
    let healthDataItemsToRead: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
    let healthDataItemsToWrite: Set<HKSampleType> = []
    
    override init(identifier: String) {
        super.init(identifier: identifier)
        
        title = NSLocalizedString("Datos de salud", comment: "")
        text = NSLocalizedString("A continuación se le pedirá que otorgue acceso para leer los datos de su frecuencia cardíaca para este estudio.\n\nSi rechazó la autorización anteriormente y desea otorgar el acceso, dirijase a \n\nConfiguración -> Privacidad -> Salud\n\n para autorizar la app.", comment: "")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHealthAuthorization(_ completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        HKHealthStore().requestAuthorization(toShare: healthDataItemsToWrite, read: healthDataItemsToRead){ (success, error) -> Void in
            completion(success, error as NSError?)
        }
    }
}
