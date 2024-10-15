//
//  IntroViewController.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 10/10/24.
//

import UIKit
import ResearchKitActiveTask

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            toTasks()
        } else {
            toConsent()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toConsent() {
        performSegue(withIdentifier: "toConsent", sender: self)
    }
    
    func toTasks() {
        performSegue(withIdentifier: "toTasks", sender: self)
    }

    var contentHidden = false {
        didSet {
            guard contentHidden != oldValue && isViewLoaded else { return }
            children.first?.view.isHidden = contentHidden
        }
    }
    
    @IBAction func unwindToTasks(_ segue: UIStoryboardSegue){
        toTasks()
    }
}
