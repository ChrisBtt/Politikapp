//
//  DetailVC.swift
//  Politikapp
//
//  Created by Christoph Blattgerste on 23.03.17.
//  Copyright © 2017 Christoph Blattgerste. All rights reserved.
//

import UIKit
import Firebase

protocol DetailVCDelegate : class {
    
    func updateElection (new: Stimme, index: Int)
}

class DetailVC: UIViewController {
    
    weak var delegate: DetailVCDelegate?
    
    var question : String!
    var detail : String!
    var dafuer : Int! = 0
    var dagegen : Int! = 0
    var index : Int! = 0

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func actDafuer(_ sender: AnyObject) {
        
        // display for user and go back to FrontTVC
        let alertController = UIAlertController(title: "Vielen Dank", message: "Du hast dich erfolgreich in die Politik eingemischt", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            
// FIXME: update tableView correctly by deleting the answered question
            self.delegate?.updateElection(new: .ja, index: self.index)
            self.sendParameter(new: .ja)
            self.dismiss(animated: true, completion: nil)
            
        }
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func actDagegen(_ sender: AnyObject) {
        
        // display for user and go back to FrontTVC
        let alertController = UIAlertController(title: "Vielen Dank", message: "Du hast dich erfolgreich in die Politik eingemischt", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel) { _ in

// FIXME: update tableView correctly by deleting the answered question
            self.delegate?.updateElection(new: .nein, index: self.index)
            self.sendParameter(new: .nein)
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblQuestion?.text = question
        lblDetails?.text = detail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // send new Counter to Firebase DB
    func sendParameter(new: Stimme) -> Void {
        
        let ref : FIRDatabaseReference = FIRDatabase.database().reference()
        
        if new == .ja {
            ref.child("Fragen/Frage\(self.index+1)/ja").setValue(dafuer+1)
        } else {
            ref.child("Fragen/Frage\(self.index+1)/nein").setValue(dafuer+1)
        }
        
    }
    
}
