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
    
    // TODO: - change password
    // TODO: change age, gender, plz -
    
    var age : String = ""
    var gender : String = ""
    var plz : Int = 0
    
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var txtAge: UILabel!
    @IBOutlet weak var txtGender: UILabel!
    @IBOutlet weak var txtPLZ: UILabel!
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
}
