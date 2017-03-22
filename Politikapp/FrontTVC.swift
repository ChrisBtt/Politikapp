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
    
//    var questions = ["Ist Demokratie wichtig?", "Kann Merkel unsere Probleme lösen?", "Neue Frage ..."]
    var data = [String]()
    
    var ref: FIRDatabaseReference?
    var databaseHandle : FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // code to update array data with questions in it from Firebase DB
        ref = FIRDatabase.database().reference()
        
        databaseHandle = ref?.child("Fragen").observe(.childAdded, with: {(snapshot) in
            
            let question = snapshot.childSnapshot(forPath: "Frage").value as? String
            
            if let newQuestion = question {
                
                self.data.append(newQuestion)
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profilSegue" {
            
            let dest_vc = segue.destination as? ProfilVC
            dest_vc?.lblAccount.text = FIRAuth.auth()?.currentUser!.email

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

}
