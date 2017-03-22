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
    
    @IBOutlet weak var lblAccount: UILabel!
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
        
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
}
