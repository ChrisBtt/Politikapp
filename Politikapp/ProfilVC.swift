//
//  LogoutVC.swift
//  Politikapp
//
//  Created by Christoph Blattgerste on 21.03.17.
//  Copyright © 2017 Christoph Blattgerste. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfilVC: UIViewController {
    
    var age : String = ""
    var gender : String = ""
    var plz : Int = 0
    var email : String = ""
    
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var txtAge: UILabel!
    @IBOutlet weak var txtGender: UILabel!
    @IBOutlet weak var txtPLZ: UILabel!
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func changePassword(_ sender: Any) {
        let alertController = UIAlertController(title: "Passwort ändern", message: "Bitte gib hier dein altes und neues Passwort ein", preferredStyle: .alert)

        alertController.addTextField(configurationHandler: {(textfield: UITextField!) in
                textfield.placeholder = "Neues Passwort"
        })
        alertController.addTextField(configurationHandler: {(textfield: UITextField!) in
                textfield.placeholder = "Wiederhole es"
        })
        
        // handler submits new Password to Firebase
        let defaultAction = UIAlertAction(title: "Übernehmen", style: .default, handler: {[weak alertController] (_) in
            let txt1 = alertController?.textFields![0]
            let txt2 = alertController?.textFields![1]
            
            if txt1?.text == txt2?.text {
                FIRAuth.auth()?.currentUser?.updatePassword((txt1?.text)!, completion: {(_) in
                    let alert = UIAlertController(title: "Passwort geändert", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                })
            } else {
                let alert = UIAlertController(title: "Fehler", message: "Passwortbestätigung fehlgeschlagen", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
            }
        })
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)

    }
    @IBAction func logOut(_ sender: AnyObject) {
        
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblAccount.text = FIRAuth.auth()?.currentUser!.email
        
        txtAge.text = age
        txtGender.text = gender
        txtPLZ.text = String(plz)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editData" {
            
            let svc = segue.destination as? UINavigationController
            let dest_vc = svc?.topViewController as! EditDataVC
            
            dest_vc.age = age
            dest_vc.gender = gender
            dest_vc.plz = plz
            
        }
    }
}
