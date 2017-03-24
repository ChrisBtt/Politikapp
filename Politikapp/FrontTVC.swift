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

class FrontTVC: UITableViewController, DetailVCDelegate {
    
//    var questions = ["Ist Demokratie wichtig?", "Kann Merkel unsere Probleme lösen?", "Neue Frage ..."]
    var data = [String]()
    var info = [String]()
    var dafuer = [Int]()
    var dagegen = [Int]()
    
    var ref: FIRDatabaseReference?
    var databaseHandle : FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // code to update array data with questions in it from Firebase DB
        ref = FIRDatabase.database().reference()
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        switch segue.identifier! {
            
        // sends the authorized user email to ProfilVC
            case "profilSegue":
                let dest_vc = segue.destination as? ProfilVC
                dest_vc?.lblAccount.text = FIRAuth.auth()?.currentUser!.email
            
        // sends question infos from Firebase Database to DetailVC
            case "cellSegue":
                
                let svc = segue.destination as? UINavigationController
                let dest_vc = svc?.topViewController as! DetailVC
                
                // check for validity of pressed cell 
                if let chosenIndex = tableView.indexPathForSelectedRow?.row {
                    
                    dest_vc.question = data[chosenIndex]
                    dest_vc.detail = info[chosenIndex]
                    dest_vc.dafuer = dafuer[chosenIndex]
                    dest_vc.dagegen = dagegen[chosenIndex]
                    dest_vc.index = chosenIndex

                }
            
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
    
    // MARK: Implementing the protocol
    
    func updateElection(new: Stimme, index: Int) {
        
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
    }

}
