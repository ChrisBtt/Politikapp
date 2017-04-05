//
//  NewQuestionVC.swift
//  Politikapp
//
//  Created by Christoph Blattgerste on 21.03.17.
//  Copyright © 2017 Christoph Blattgerste. All rights reserved.
//

import Foundation

class NewQuestionVC: UIViewController {
    
// TODO: make ne child in Firebase DB for new question with example tree
// TODO: register date of new question to stay up to date
    
    @IBOutlet weak var barMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barMenu.target = self.revealViewController()
        barMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
}
