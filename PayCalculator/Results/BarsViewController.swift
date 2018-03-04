//
//  BarsViewController.swift
//  PayCalculator
//
//  Created by James Beattie on 24/09/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import UIKit
import pop


protocol BarsViewControllerDelegate {
    func barsViewAppeared(callback: ((Bool) -> ())?)
}

class BarsViewController: UIViewController {
    
    @IBOutlet weak var pension: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var ni: UILabel!
    @IBOutlet weak var studentLoan: UILabel!
    @IBOutlet weak var takeHomePay: UILabel!
    
    @IBOutlet weak var pensionBar: BarView!
    @IBOutlet weak var taxBar: BarView!
    @IBOutlet weak var niBar: BarView!
    @IBOutlet weak var studentLoanBar: BarView!
    @IBOutlet weak var takeHomePayBar: BarView!
    
    @IBOutlet weak var timeFrame: UISegmentedControl!
    
    var delegate: BarsViewControllerDelegate?
    
    lazy var individual = Individual.sharedInstance
    var individuals = Individuals.sharedInstance
    
    let currencyFormatter = NumberFormatter()
    
    init(viewModel: Bool) {
        super.init(nibName: String(describing: BarsViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.layoutIfNeeded()
        
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = Locale.current.currencySymbol
        
        switch individual.preferredTimeFrame {
        case .yearly: timeFrame.selectedSegmentIndex = 0
        case .monthly: timeFrame.selectedSegmentIndex = 1
        case .weekly: timeFrame.selectedSegmentIndex = 2
        case .daily: timeFrame.selectedSegmentIndex = 3
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplay(animated: animated)
    }
    
    func updateDisplay(animated: Bool) {
        
        let values = individual.money.getValues(.value)
        let percent = individual.money.getValues(.percent)
        
        pension.text = "£\(currencyFormatter.string(from: values[.Pension]! as NSNumber)!)"
        pensionBar.change(percent: percent[.Pension]!, animated: animated)
        
        tax.text = "£\(currencyFormatter.string(from: values[.Tax]! as NSNumber)!)"
        taxBar.change(percent: percent[.Tax]!, animated: animated)
        
        ni.text = "£\(currencyFormatter.string(from: values[.NI]! as NSNumber)!)"
        niBar.change(percent: percent[.NI]!, animated: animated)
        
        studentLoan.text = "£\(currencyFormatter.string(from: values[.StudentLoan]! as NSNumber)!)"
        studentLoanBar.change(percent: percent[.StudentLoan]!, animated: animated)
        
        takeHomePay.text = "£\(currencyFormatter.string(from: values[.TakeHomePay]! as NSNumber)!)"
        takeHomePayBar.change(percent: percent[.TakeHomePay]!, animated: animated)
    }
    
    @IBAction func timeFrameChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            individual.preferredTimeFrame = .yearly
        case 1:
            individual.preferredTimeFrame = .monthly
        case 2:
            individual.preferredTimeFrame = .weekly
        case 3:
            individual.preferredTimeFrame = .daily
        default:
            individual.preferredTimeFrame = .yearly
        }
        updateDisplay(animated: true)
    }

}


