//
//  DetailStatVC.swift
//  Politikapp
//
//  Created by Christoph Blattgerste on 26.03.17.
//  Copyright © 2017 Christoph Blattgerste. All rights reserved.
//

import UIKit
import Charts

class DetailStatVC: UIViewController {
    
    @IBOutlet weak var lblFrage: UILabel!
    @IBOutlet weak var barView: PieChartView!
    @IBAction func btnDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var question : String!
    var dafuer : Int!
    var dagegen : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        updateChartWithData()
        lblFrage.text = question
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateChartWithData() {
        
        var entries = [ChartDataEntry]()
        
        // generate chart data entries
        
        let entry1 = ChartDataEntry()
        entry1.x = 1.0
        entry1.y = Double(dafuer)
        entries.append(entry1)
        
        let entry2 = ChartDataEntry()
        entry2.x = 2.0
        entry2.y = Double(dagegen)
        entries.append(entry2)

        // chart setup
        let set = PieChartDataSet(values: entries, label: "Stimmen")
        
        var colors = [UIColor]()
        
        colors.append(.green)
        colors.append(.red)
        
        set.colors = colors
        
        let data = PieChartData(dataSet: set)
        barView.data = data
    }

}
