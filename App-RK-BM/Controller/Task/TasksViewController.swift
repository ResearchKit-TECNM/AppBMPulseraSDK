//
//  TasksViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 11/10/24.
//

import UIKit
import ResearchKitUI

class TasksViewController: UIViewController {
    
    var user: User?

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toForms" {
            let formsControlller = segue.destination as! FormsViewController
            formsControlller.userDelegate = user
            formsControlller.delegate = self
        }
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
        // delegar usuario
        self.user = User(name: "Luis", surname: "Mora")
        print("\(self.user?.name) \(self.user?.surname)")
        
        // activar el segue
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
    
    @IBAction func unwindToTaskView(_ sender: UIStoryboardSegue) {
        // Aquí puedes agregar lógica adicional si es necesario
    }
    
}

extension TasksViewController: ORKTaskViewControllerDelegate{
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskFinishReason, error: Error?) {
        taskViewController.dismiss(animated: true, completion: nil)
    }
}

extension TasksViewController: UserDelegate {
    func didUpdateUser(_ user: User) {
        // Aquí recibes el objeto actualizado desde B
        self.user = user
        print("Usuario actualizado: \(user.name), \(user.surname)")
    }
    
}
