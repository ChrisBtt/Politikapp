//
//  StatisticsTVC.swift
//  Politikapp
//
//  Created by Christoph Blattgerste on 22.03.17.
//  Copyright © 2017 Christoph Blattgerste. All rights reserved.
//

import UIKit
import Charts

class StatisticsTVC: UITableViewController {
    
// FIXME: implement dismiss function to FrontTVC as Show Segue not Present
    @IBAction func btnQuestions(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Front")
        self.present(vc!, animated: true, completion: nil)
    }
    var data = [String]()
    var info = [String]()
    var dafuer = [Int]()
    var dagegen = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad() 
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statCell")
        cell?.textLabel?.text = data[indexPath.row]
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "statDetail" {
            
            let svc = segue.destination as? UINavigationController
            let vc = svc?.topViewController as! DetailStatVC
            
            if let index = tableView.indexPathForSelectedRow?.row {
            
                vc.question = data[index]
                vc.dafuer = dafuer[index]
                vc.dagegen = dagegen[index]
                
            }
        }
    }
}
