//
//  FrontCell.swift
//  Politikapp
//
//  Created by Christoph Blattgerste on 19.04.17.
//  Copyright © 2017 Christoph Blattgerste. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

protocol FrontCellDelegate {
    func segueFromCell(from object: AnyObject)
    func pressedJa(_ sender: UIButton)
    func pressedNein(_ sender: UIButton)
    func send(new: Stimme, index: Int)
}

class FrontCell: UITableViewCell {
    
    var delegate : FrontCellDelegate!
//    var index : Int = 0

    @IBOutlet weak var btnJa: UIButton!
    @IBOutlet weak var btnNein: UIButton!
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnStat: UIButton!
    
    @IBAction func pressedJa(_ sender: Any) {
//        self.delegate.pressedJa(btnJa)
    }
    @IBAction func pressedNein(_ sender: Any) {
        self.delegate.pressedNein(btnNein)
    }
    @IBAction func pressedInfo(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
