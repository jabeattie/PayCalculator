//
//  InputViewController.swift
//  PayCalculator
//
//  Created by James Beattie on 12/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit

protocol InputViewControllerDelegate: class {
    func calculatePressed()
    func valuesUpdated()
    func inputViewAppeared()
}

class InputViewController: UIViewController {
    
    @IBOutlet weak var calculate: UIButton!
    @IBOutlet weak var salary: SlidingTextField!
    @IBOutlet weak var taxcode: UITextField!
    @IBOutlet weak var pension: UITextField!
    @IBOutlet weak var pensionType: UISegmentedControl!
    @IBOutlet weak var contributionCap: UITextField!
    @IBOutlet weak var studentloan: UISegmentedControl!
    @IBOutlet weak var noni: UISwitch!
    @IBOutlet weak var blind: UISwitch!
    
    weak var delegate: InputViewControllerDelegate?
    var firstLoad = true
    
    let individual = Individual.sharedInstance
    
    let numberFormatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.inputViewAppeared()
    }
    
    func setup() {
      
        pensionType.tintColor = .pcAqua
        studentloan.tintColor = .pcAqua
        noni.tintColor = .pcAqua
        blind.tintColor = .pcAqua
        
        numberFormatter.maximumFractionDigits = 0
        
        salary.attributedPlaceholder = NSAttributedString(string: "25000", attributes: [.foregroundColor: UIColor.pcGrey])
        taxcode.attributedPlaceholder = NSAttributedString(string: "1100L", attributes: [.foregroundColor: UIColor.pcGrey])
        pension.attributedPlaceholder = NSAttributedString(string: "0%", attributes: [.foregroundColor: UIColor.pcGrey])
        contributionCap.attributedPlaceholder = NSAttributedString(string: "0", attributes: [.foregroundColor: UIColor.pcGrey])
        
        salary.delegate = self
        taxcode.delegate = self
        pension.delegate = self
        contributionCap.delegate = self
        
        if individual.prePensionSalary > 0 {
            salary.text = numberFormatter.string(from: individual.prePensionSalary as NSNumber)
            taxcode.text = individual.prettyTaxCode
            pension.text = (individual.pensionContribution * 100).cleanValue
            contributionCap.text = (individual.pensionContributionCap)?.cleanValue
            switch individual.pensionNet {
            case true:
              pensionType.selectedSegmentIndex = 0
            case false:
              pensionType.selectedSegmentIndex = 1
            }
            switch individual.studentLoan {
            case .none:
                studentloan.selectedSegmentIndex = 0
            case .plan1:
                studentloan.selectedSegmentIndex = 1
            case .plan2:
                studentloan.selectedSegmentIndex = 2
            }
        }
        
        blind.isOn = individual.blind
        noni.isOn = individual.nICode == .None
    }
  
    @IBAction func didTap(_ sender: UIButton) {
        if sender == calculate {
            delegate?.calculatePressed()
        }
    }

    @IBAction func processValues(_ sender: AnyObject) {
        guard !(salary.text!.isEmpty) else {
            print("Salary incorrect")
            return
        }
        guard let salaryDouble = Double(salary.text!) else {
            print("Salary NaN")
            return
        }
        let pensionDouble = Double(pension.text!) ?? 0.0
        let taxcodeString = taxcode.text!.isEmpty ? "1100L" : taxcode.text!
        if !(taxcodeString =~ Constants.taxCodeRegex) {
            print("Taxcode not a match")
            return
        }
        let niCode = noni.isOn ? NICode.None : NICode.A
        let slPlan: StudentLoanPlan!
        switch studentloan.selectedSegmentIndex {
        case 0:
            slPlan = StudentLoanPlan.none
        case 1:
            slPlan = StudentLoanPlan.plan1
        case 2:
            slPlan = StudentLoanPlan.plan2
        default:
            slPlan = StudentLoanPlan.none
        }
      
        let pensionNet: Bool
        switch pensionType.selectedSegmentIndex {
        case 1: pensionNet = false
        default: pensionNet = true
        }
      
        let cap = Double(contributionCap.text ?? "")
      
        individual.update(pensionNet: pensionNet)
        individual.update(pensionContribution: pensionDouble)
        individual.update(salary: salaryDouble)
        individual.update(pensionContributionCap: cap)
        individual.update(niCode: niCode)
        individual.update(studentLoanPlan: slPlan)
        individual.update(taxCode: taxcodeString)
        individual.update(blind: blind.isOn)
        
        individual.calculate()
        
        delegate?.valuesUpdated()
    }

}

extension InputViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var characterSet: CharacterSet!
        switch textField {
        case salary:
            characterSet = CharacterSet.decimalDigits
            characterSet.insert(charactersIn: ".")
        case pension:
            characterSet = CharacterSet.decimalDigits
            characterSet.insert(charactersIn: ".")
        case contributionCap:
            characterSet = CharacterSet.decimalDigits
            characterSet.insert(charactersIn: ".")
        case taxcode:
            characterSet = CharacterSet.alphanumerics
        default:
            characterSet = CharacterSet.alphanumerics
        }
        if string.rangeOfCharacter(from: characterSet.inverted) != nil {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let slidingTextField = textField as? SlidingTextField else { return }
        slidingTextField.textColor = Constants.Colours.DarkGray
        slidingTextField.animateBackground(color: .pcAqua)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let slidingTextField = textField as? SlidingTextField else { return }
        slidingTextField.animateBackgroundOut()
        slidingTextField.textColor = .pcAqua
    }
    
}
