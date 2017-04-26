//
//  FrontTVC.swift
//  
//
//  Created by Christoph Blattgerste on 22.03.17.
//
//

import UIKit
import Firebase
import FirebaseAuth

class FrontTVC: UITableViewController {

// TODO: - sort questions from DB regarding their date of creation -
    
    var data = [String]()
    var info = [String]()
    var dafuer = [Int]()
    var dagegen = [Int]()

    let user = FIRAuth.auth()?.currentUser
    
    var age : String = ""
    var gender : String = ""
    var plz : Int = 0
    
    var ref: FIRDatabaseReference? = FIRDatabase.database().reference()
    var databaseHandle : FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        
        self.getUserInfo()
        self.connectDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        switch segue.identifier! {
            
        // sends authorized user email and dats to ProfilVC
            case "profilSegue":
                let svc = segue.destination as? UINavigationController
                let dest_vc = svc?.topViewController as! ProfilVC
                
                let mail = FIRAuth.auth()?.currentUser!.email
                dest_vc.email = mail!
                dest_vc.age = age
                dest_vc.gender = gender
                dest_vc.plz = plz

            
        // sends question infos from Firebase Database to DetailVC
            case "cellSegue", "cell2Segue":
                
                let svc = segue.destination as? UINavigationController
                let dest_vc = svc?.topViewController as! DetailVC
                dest_vc.delegate = self
                
                // check for validity of pressed cell 
                if let chosenIndex = tableView.indexPathForSelectedRow?.row {
                    
                    dest_vc.question = data[chosenIndex]
                    dest_vc.detail = info[chosenIndex]
                    dest_vc.dafuer = dafuer[chosenIndex]
                    dest_vc.dagegen = dagegen[chosenIndex]
                    dest_vc.index = chosenIndex
                    
                    dest_vc.age = age
                    dest_vc.gender = gender
                    dest_vc.plz = plz
                }
            
            // sends all question data from DB to statVC
            case "statSegue":
            
                let svc = segue.destination as? UINavigationController
                let dest_vc = svc?.topViewController as! StatisticsTVC
            
                dest_vc.data = data
                dest_vc.info = info
                dest_vc.dafuer = dafuer
                dest_vc.dagegen = dagegen
            
            default:
                print("Wrong Segue")
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! FrontCell
        cell.delegate = self
        
    // specify own TVCell class
// TODO: connect buttons to VC and write segues
        
        cell.btnTitle.setTitle(data[indexPath.row], for: .normal)

        cell.btnJa.backgroundColor = UIColor.green
        cell.btnJa.setTitle("", for: .normal)
        cell.btnJa.setImage(UIImage(named: "check"), for: .normal)
        cell.btnJa.tintColor = UIColor.white

        cell.btnNein.backgroundColor = UIColor.red
        cell.btnNein.setTitle("", for: .normal)
        cell.btnNein.setImage(UIImage(named: "loschen"), for: .normal)
        cell.btnNein.tintColor = UIColor.white

        cell.btnComment.setImage(UIImage(named: "speech"), for: UIControlState.normal)
        cell.btnComment.setTitle("", for: .normal)

        cell.btnInfo.setTitle("Mehr ...", for: .normal)
        
        cell.btnStat.setTitle("", for: .normal)
// TODO: show button image as PieChartView (use e.g. #let image = UIImage(view: myView)
        
        cell.btnJa.tag = indexPath.row
        cell.btnJa.addTarget(self, action: #selector(self.pressedJa(_:)), for: .touchUpInside)

        cell.btnNein.tag = indexPath.row
        cell.btnNein.addTarget(self, action: #selector(self.pressedNein(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // MARK: Function to set the variables age, gender, plz concerning the info from DB

    func getUserInfo() {
        ref?.child("Benutzer").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            self.age = snapshot.childSnapshot(forPath: "Alter").value! as! String
            self.gender = snapshot.childSnapshot(forPath: "Geschlecht").value! as! String
            self.plz = snapshot.childSnapshot(forPath: "PLZ").value! as! Int
        })

    }
    
    // MARK: Function to checkout the Firebase DB for new questions
    
    func connectDB() {
        
        // code to update array data with questions in it from Firebase DB
        
        databaseHandle = ref?.child("Fragen").observe(.childAdded, with: {(snapshot) in
            
            let question = snapshot.childSnapshot(forPath: "Frage").value as? String
            
            if let newQuestion = question {
                
                self.data.append(newQuestion)
                self.tableView.reloadData()
                
                let detail = snapshot.childSnapshot(forPath: "Info").value as? String
                let ja = snapshot.childSnapshot(forPath: "ja").value as? Int
                let nein = snapshot.childSnapshot(forPath: "nein").value as? Int
                
                // add the optional detail to array info even if there is non to keep ahead with array data
                if let newDetail = detail {
                    self.info.append(newDetail)
                } else {
                    self.info.append("")
                }
                if let newJa = ja {
                    self.dafuer.append(newJa)
                } else {
                    self.dafuer.append(0)
                }
                if let newNein = nein {
                    self.dagegen.append(newNein)
                } else {
                    self.dagegen.append(0)
                }
            }
        })
    }
    
//    func sendParameter(_ sender: UIButton, new: Stimme) -> Void {
//        
//        let index = sender.tag
//        var current : Int!
//        
//        ref?.child("Fragen/Frage\(index+1)/Alter/\(self.age)").observeSingleEvent(of: .value, with: {(snapshot) in
//            current = snapshot.value as! Int
//            print(current)
//            print(type(of: current))
//            snapshot.setValue(current+1, forKey: "\(self.age)")
//            print("added")
//        })
//    
//        
//        // updates the current statistics of answered question with user info
//        ref?.child("Fragen/Frage\(index+1)").observeSingleEvent(of: .value, with: {(snapshot) in
//            
//            print(snapshot)
//            if snapshot.hasChild("Alter/\(self.age)") {
//                let currentAge = snapshot.childSnapshot(forPath: "Alter/\(self.age)").value
//                self.ref?.child("Fragen/Frage\(index+1)/Alter").setValue(currentAge, forKey: "\(self.age)")
//            } else {
//                snapshot.childSnapshot(forPath: "Alter/\(self.age)").setValue(1, forKey: "\(self.age)")
//            }
//            print("age done")
//            
//            if snapshot.hasChild("PLZ/\(self.plz)") {
//                let currentPLZ = snapshot.childSnapshot(forPath: "PLZ/\(self.plz)").value as! Int
//                self.ref?.child("Fragen/Frage\(index+1)/PLZ/\(self.plz)").setValue(currentPLZ+1)
//            } else {
//                snapshot.childSnapshot(forPath: "PLZ").setValue(1, forKey: "\(self.plz)")
//            }
//            
//            if snapshot.hasChild("Geschlecht/\(self.gender)") {
//                let currentGender = snapshot.childSnapshot(forPath: "Geschlecht/\(self.gender)").value as! Int
//                self.ref?.child("Fragen/Frage\(index+1)/Geschlecht/\(self.gender)").setValue(currentGender+1)
//            } else {
//                snapshot.childSnapshot(forPath: "Geschlecht").setValue(1, forKey: "\(self.gender)")
//            }
//        
//        if new == .ja {
//            self.ref?.child("Fragen/Frage\(index+1)/ja").setValue(self.dafuer[index]+1)
//        } else {
//            self.ref?.child("Fragen/Frage\(index+1)/nein").setValue(self.dagegen[index]+1)
//        }
//        })
//        
//    }

}

// MARK: Implementing the protocol

extension FrontTVC: DetailVCDelegate, FrontCellDelegate {
    
    func updateElection(new: Stimme, index: Int) {
        
        if new == .ja {
            print(dafuer[index]+1)
        } else {
            print(dagegen[index]+1)
        }
        
        self.tableView.reloadData()
    }
    
    func segueFromCell(from object: AnyObject) {
        self.performSegue(withIdentifier: "cellSegue", sender:object)
    }
    
    func pressedJa(_ sender: UIButton) {
        
        self.updateElection(new: .ja, index: sender.tag)
        self.send(new: .ja, index: sender.tag)
        
        let alertController = UIAlertController(title: "Vielen Dank", message: "Du hast dich erfolgreich in die Politik eingemischt", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func pressedNein(_ sender: UIButton) {
        
        self.updateElection(new: .nein, index: sender.tag)
        self.send(new: .nein, index: sender.tag)
        
        let alertController = UIAlertController(title: "Vielen Dank", message: "Du hast dich erfolgreich in die Politik eingemischt", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func send(new: Stimme, index: Int) {
        
        if new == .ja {
            self.ref?.child("Fragen/Frage\(index+1)/ja").setValue(self.dafuer[index]+1)
        } else {
            self.ref?.child("Fragen/Frage\(index+1)/nein").setValue(self.dagegen[index]+1)
        }
        
    }
}



