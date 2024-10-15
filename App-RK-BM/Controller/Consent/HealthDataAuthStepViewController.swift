//
//  HealthDataAuthStepViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 11/10/24.
//

import HealthKit
import ResearchKitActiveTask

class HealthDataAuthStepViewController: ORKActiveStepViewController {
    
    var healthDataStep: HealthDataAuthStep? {
        return step as? HealthDataAuthStep
    }
    
    override func goForward() {
        healthDataStep?.getHealthAuthorization(){succeeded, _ in
            guard succeeded || (TARGET_OS_SIMULATOR != 0) else { return }
            OperationQueue.main.addOperation {
                super.goForward()
            }
        }
    }
    
}
