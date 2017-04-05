//
//  DetailVC.swift
//  Politikapp
//
//  Created by Christoph Blattgerste on 23.03.17.
//  Copyright © 2017 Christoph Blattgerste. All rights reserved.
//

import UIKit
import Firebase

// MARK: protocol -
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
    
    var age : String = ""
    var gender : String = ""
    var plz : Int = 0
    
    var ref : FIRDatabaseReference?
    var databaseHandle : FIRDatabaseHandle?

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func actDafuer(_ sender: AnyObject) {
        
        // display for user and go back to FrontTVC
        let alertController = UIAlertController(title: "Vielen Dank", message: "Du hast dich erfolgreich in die Politik eingemischt", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel) { _ in
        
// FIXME: answer each question only once

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

// FIXME: answer each question only once
            self.delegate!.updateElection(new: .nein, index: self.index)
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
    
    func sendParameter(new: Stimme) -> Void {
        
        ref = FIRDatabase.database().reference()
        
        // updates the current statistics of answered question with user info
        databaseHandle = ref?.child("Fragen/Frage\(index+1)").observe(.value, with: {(snapshot) in
            
            if snapshot.hasChild("Alter/\(self.age)") {
                let currentAge = snapshot.childSnapshot(forPath: "Alter/\(self.age)").value as! Int
                self.ref?.child("Fragen/Frage\(self.index+1)/Alter/\(self.age)").setValue(currentAge+1)
            } else {
                snapshot.childSnapshot(forPath: "Alter").setValue(1, forKey: "\(self.age)")
            }
            
            if snapshot.hasChild("PLZ/\(self.plz)") {
                let currentPLZ = snapshot.childSnapshot(forPath: "PLZ/\(self.plz)").value as! Int
                self.ref?.child("Fragen/Frage\(self.index+1)/PLZ/\(self.plz)").setValue(currentPLZ+1)
            } else {
                snapshot.childSnapshot(forPath: "PLZ").setValue(1, forKey: "\(self.plz)")
            }
            
            if snapshot.hasChild("Geschlecht/\(self.gender)") {
                let currentGender = snapshot.childSnapshot(forPath: "Geschlecht/\(self.gender)").value as! Int
                self.ref?.child("Fragen/Frage\(self.index+1)/Geschlecht/\(self.gender)").setValue(currentGender+1)
            } else {
                snapshot.childSnapshot(forPath: "Geschlecht").setValue(1, forKey: "\(self.gender)")
            }
        })

        
        if new == .ja {
            ref?.child("Fragen/Frage\(self.index+1)/ja").setValue(dafuer+1)
        } else {
            ref?.child("Fragen/Frage\(self.index+1)/nein").setValue(dagegen+1)
        }
        
    }
    
}
