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
            case "cellSegue":
                
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell")
        cell?.textLabel?.text = data[indexPath.row]
        
        return cell!
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
}

// MARK: Implementing the protocol

extension FrontTVC: DetailVCDelegate {
    
    func updateElection(new: Stimme, index: Int) {
        
        print("update Election")
        
        if new == .ja {
            print(self.dafuer[index]+1)
        } else {
            print(dagegen[index]+1)
        }
        
        // beantwortete Frage aus dem Array data loeschen, um mehrfache Abstimmung zu verhindern
        data.remove(at: index)
        info.remove(at: index)
        dafuer.remove(at: index)
        dagegen.remove(at: index)
        
        self.tableView.reloadData()
    }
    
}



