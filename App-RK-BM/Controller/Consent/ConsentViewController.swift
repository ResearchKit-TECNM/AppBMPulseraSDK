//
//  ConsentViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 10/10/24.
//

import UIKit
import ResearchKitUI

class ConsentViewController: UIViewController {

    @IBOutlet weak var joinButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func joinButtonTapped(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
}

extension ConsentViewController: ORKTaskViewControllerDelegate{
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskFinishReason, error: Error?) {
        switch reason {
        case .completed:
            // imprimir el documento de consentimiento
            let signatureResult: ORKConsentSignatureResult = taskViewController.result.stepResult(forStepIdentifier: "ConsentReviewStep")?.firstResult as! ORKConsentSignatureResult
            let consentDocument = ConsentDocument.copy() as! ORKConsentDocument
            signatureResult.apply(to: consentDocument)
            consentDocument.makePDF{ (data, error) -> Void in
                var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
                docURL = docURL?.appendingPathComponent("consent.pdf")
                try? data?.write(to: docURL!, options: .atomicWrite)
            }
            // segue
            performSegue(withIdentifier: "unwindToTasks", sender: nil)
        case .discarded, .failed, .saved:
            dismiss(animated: true, completion: nil)
        case .earlyTermination:
            print("\tError en early termination")
        @unknown default:
            print("\tError en default")
        }
        
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, viewControllerFor step: ORKStep) -> ORKStepViewController? {
        if step is HealthDataAuthStep {
            let healthStepViewController = HealthDataAuthStepViewController(step: step)
            return healthStepViewController
        }
        return nil
    }
    
}
