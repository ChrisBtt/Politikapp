//
//  EditDataVC.swift
//  Politikapp
//
//  Created by Christoph Blattgerste on 06.04.17.
//  Copyright © 2017 Christoph Blattgerste. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class EditDataVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var age : String = ""
    var gender : String = ""
    var plz : Int = 0
    let ageData = ["jünger", "31 - 40", "41 - 50", "51 - 60", "61 - 75", "älter"]
    
    var agePicker = UIPickerView()

    @IBOutlet weak var segGender: UISegmentedControl!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtPLZ: UITextField!
    @IBAction func btnSave(_ sender: Any) {
        
        if self.txtPLZ.text != "" && self.txtPLZ.text?.characters.count == 5, let plz = Int(self.txtPLZ.text!) {
            
            let ref = FIRDatabase.database().reference()
            let user = FIRAuth.auth()?.currentUser
            
            ref.child("Benutzer/\((user?.uid)!)/Alter").setValue(age)
            
            if self.segGender.selectedSegmentIndex == 0 {
                ref.child("Benutzer/\((user?.uid)!)/Geschlecht").setValue("Männlich")
            } else {
                ref.child("Benutzer/\((user?.uid)!)/Geschlecht").setValue("Weiblich")
            }
            
            ref.child("Benutzer/\((user?.uid)!)/PLZ").setValue(plz)
            
            let alertController = UIAlertController(title: "", message: "Deine geänderten Daten wurden gespeichert", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)

        } else {
            let alert = UIAlertController(title: "Fehler", message: "Bitte eine fünfstellige Postleitzahl eingeben", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtAge.delegate = self
        agePicker.delegate = self
        agePicker.dataSource = self
        txtAge.inputView = agePicker

        // Do any additional setup after loading the view.
        if gender == "Männlich" {
            segGender.selectedSegmentIndex = 0
        } else {
            segGender.selectedSegmentIndex = 1
        }
        txtAge.text = age
    }
    
    // implement UIPickerView delegate functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ageData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtAge.text = ageData[row]
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
        textField.text = ageData[self.agePicker.selectedRow(inComponent: 0)]
        
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
        self.txtAge.text = ageData[self.agePicker.selectedRow(inComponent: 0)]
        txtAge.resignFirstResponder()
    }
    func cancelClick() {
        txtAge.resignFirstResponder()
    }
}
