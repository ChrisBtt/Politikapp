//
//  DetailVC.swift
//  Politikapp
//
//  Created by Christoph Blattgerste on 23.03.17.
//  Copyright © 2017 Christoph Blattgerste. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var question : String!
    var detail : String!

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblQuestion?.text = question
        lblDetails?.text = detail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
