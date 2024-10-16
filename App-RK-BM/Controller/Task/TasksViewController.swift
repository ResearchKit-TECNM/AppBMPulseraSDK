//
//  TasksViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 11/10/24.
//

import UIKit
import ResearchKitUI

class TasksViewController: UIViewController {

    @IBOutlet weak var documentButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var activitiesButton: UIButton!
    @IBOutlet weak var formsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leaveButtonTapped(_ sender: UIButton) {
        ORKPasscodeViewController.removePasscodeFromKeychain()
        performSegue(withIdentifier: "returnToConsent", sender: nil)
    }
    
    @IBAction func documentButtonTapped(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: consentPDFViewerTask(), taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    func consentPDFViewerTask() -> ORKOrderedTask{
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
        docURL = docURL?.appendingPathComponent("consent.pdf")
        let PDFViewerStep = ORKPDFViewerStep.init(identifier: "ConsentPDFViewer", pdfURL: docURL)
        PDFViewerStep.title = "Consent"
        return ORKOrderedTask(identifier: String("ConsentPDF"), steps: [PDFViewerStep])
    }
    
    func toForms() {
        performSegue(withIdentifier: "toForms", sender: self)
    }
    
    func toActivities() {
        performSegue(withIdentifier: "toActivities", sender: self)
    }
    
    @IBAction func formsButtonTapped(_ sender: UIButton) {
        toForms()
    }
    
    @IBAction func activitiesButtonTapped(_ sender: UIButton) {
        toActivities()
    }
    
}

extension TasksViewController: ORKTaskViewControllerDelegate{
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskFinishReason, error: Error?) {
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
