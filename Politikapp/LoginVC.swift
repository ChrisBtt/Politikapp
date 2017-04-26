//
//  ViewController.swift
//  Politikapp
//
//  Created by Christoph Blattgerste on 20.03.17.
//  Copyright © 2017 Christoph Blattgerste. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func btnAnmelden(_ sender: AnyObject) {
        
        if txtMail.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Bite gib deine Email und dein Passwort ein", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.signIn(withEmail: self.txtMail.text!, password: self.txtPassword.text!) { (user, error) in
                
/// TODO: shown ViewController depending on user - probably if-Statement with Firebase user.uid
                
                if error == nil {
                    print("Du hast dich erfollgreich eingeloggt")
                    print(user?.uid ?? "")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Front")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Anmelden"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier=="registrieren" || segue.identifier=="passwort" {
            
            let vc = segue.destination as UIViewController
            
            if segue.identifier=="registrieren" {
                vc.navigationItem.title = "Registrierung"
            }
            else if segue.identifier=="passwort" {
                vc.navigationItem.title = "Passwort vergessen"
            }
            
            navigationItem.title="Login"
        }
    }

}

