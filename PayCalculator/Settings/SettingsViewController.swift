//
//  SettingsViewController.swift
//  PayCalculator
//
//  Created by James Beattie on 09/10/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var timeFrame: UISegmentedControl!
    @IBOutlet weak var taxYear: UISegmentedControl!
        
    lazy var individual = Individual.sharedInstance
    lazy var user = User.sharedInstance
    
    init(viewModel: SettingsViewModel) {
        super.init(nibName: String(describing: SettingsViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        
        switch user.preferredTimeFrame {
        case .yearly: timeFrame.selectedSegmentIndex = 0
        case .monthly: timeFrame.selectedSegmentIndex = 1
        case .weekly: timeFrame.selectedSegmentIndex = 2
        case .daily: timeFrame.selectedSegmentIndex = 3
        }
        
        switch user.preferredTaxYear {
        case .y1617: taxYear.selectedSegmentIndex = 0
        case .y1718: taxYear.selectedSegmentIndex = 1
        case .y1819: taxYear.selectedSegmentIndex = 2
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func timeFrameChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: user.preferredTimeFrame = .yearly
        case 1: user.preferredTimeFrame = .monthly
        case 2: user.preferredTimeFrame = .weekly
        case 3: user.preferredTimeFrame = .daily
        default: user.preferredTimeFrame = .yearly
        }
    }
    @IBAction func taxYearChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: user.preferredTaxYear = .y1617
        case 1: user.preferredTaxYear = .y1718
        case 2: user.preferredTaxYear = .y1819
        default: user.preferredTaxYear = .y1617
        }
    }

}
