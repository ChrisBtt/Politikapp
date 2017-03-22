//
//  ViewController.swift
//  Politikapp
//
//  Created by Christoph Blattgerste on 20.03.17.
//  Copyright © 2017 Christoph Blattgerste. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet var barMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        barMenu.target = self.revealViewController()
        barMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
