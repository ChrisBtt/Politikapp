//
//  RegistrierungVC.swift
//  Politikapp
//
//  Created by Christoph Blattgerste on 20.03.17.
//  Copyright © 2017 Christoph Blattgerste. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegistrierungVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // pickerView to appear when editing textField for Age
    var age = ["jünger", "31 - 40", "41 - 50", "51 - 60", "61 - 75", "älter"]
    var agePicker : UIPickerView!
    
    var ref : FIRDatabaseReference!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var segSex: UISegmentedControl!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtPLZ: UITextField!
    @IBAction func btnRegistrieren(_ sender: AnyObject) {
        print("button hit")
        
        // show Error alert for empty Email TextField
        
// FIXME: check whether given Email is correct
        if txtEmail.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Bite gib deine Email und dein Passwort ein", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else {
            FIRAuth.auth()?.createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
                
                if error == nil {
                    print("Du hast dich erfolgreich registriert")
                    
                // add user statistics to Firebase DB
                    self.ref = FIRDatabase.database().reference()
                    
                    // set users sex
                    if self.segSex.selectedSegmentIndex == 0 {
                        self.ref.child("Benutzer/\((user?.uid)!)/Geschlecht").setValue("Männlich")
                    } else {
                        self.ref.child("Benutzer/\((user?.uid)!)/Geschlecht").setValue("Weiblich")
                    }
                    
                    // set PLZ as necessary value
                    if self.txtPLZ.text != "" && self.txtPLZ.text?.characters.count == 5, let plz = Int(self.txtPLZ.text!) {
                        
                        self.ref.child("Benutzer/\((user?.uid)!)/PLZ").setValue(plz)

                    } else {
                        let alertController = UIAlertController(title: "Error", message: "Die eingegebene Postleitzahl ist ungültig", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                    // set users age
                    switch self.txtAge.text! {
                    case "jünger", "31 - 40", "41 - 50", "51 - 60", "61 - 75", "älter":
                        self.ref.child("Benutzer/\((user?.uid)!)/Alter").setValue(self.txtAge.text)
                    default:
                        print("Fehler beim PickerView")
                    }
                    
                    
                    //presents the FrontTVC to start editing questions
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
        
        txtAge.delegate = self
        agePicker = UIPickerView()
        agePicker.delegate = self
        agePicker.dataSource = self
        
        txtAge.inputView = agePicker
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Registrierung"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // implement UIPickerView delegate functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return age.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return age[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtAge.text = age[row]
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("DidBegin")
        self.enterAge(textField: self.txtAge)
        return true
    }
    // implement the functionality of textField inputView
    func enterAge(textField: UITextField) {
        print("enter")
        textField.inputView = self.agePicker
        textField.text = age[self.agePicker.selectedRow(inComponent: 0)]
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolbar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
            
        toolbar.barStyle = .default
        toolbar.isTranslucent = false
        toolbar.tintColor = .black
        
        let doneButton = UIBarButtonItem(title: "Fertig", style: .done, target: self, action: #selector(RegistrierungVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Zurück", style: .done, target: self, action: #selector(RegistrierungVC.cancelClick))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    func doneClick() {
        print("Done")
        self.txtAge.text = age[self.agePicker.selectedRow(inComponent: 0)]
        txtAge.resignFirstResponder()
    }
    func cancelClick() {
        txtAge.resignFirstResponder()
    }
}
