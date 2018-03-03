//
//  Individual.swift
//  PayCalculator
//
//  Created by James Beattie on 27/04/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import Foundation

func ==(lhs: Individual, rhs: Individual) -> Bool {
    return lhs.salary == rhs.salary &&
        rhs.prePensionSalary == lhs.prePensionSalary &&
        rhs.pensionContribution == lhs.pensionContribution &&
        rhs.prettyTaxCode == lhs.prettyTaxCode &&
        rhs.nICode == lhs.nICode &&
        rhs.studentLoan == lhs.studentLoan &&
        rhs.blind == lhs.blind
}

class Individual: NSObject, NSCoding {
    
    static var sharedInstance = Individual()
    
    var salary: Double = 0
    var weeklyPay: Double { return salary/52 }
    var prePensionSalary: Double = 0
    var pensionContribution: Double = 0
    var allowance: (code: TaxCode, value: Double) = (code: .L, value: 11000)
    var prettyTaxCode: String = "1100L"
    var nICode: NICode = .A
    var studentLoan: StudentLoanPlan = .none
    var money: Money = Money()
    var blind: Bool = false
    var preferredTimeFrame: TimeFrame = User.sharedInstance.preferredTimeFrame {
        didSet {
            self.calculate()
        }
    }
    
    var calculatableIndividual: CalculatableIndividual {
        return CalculatableIndividual(
            salary: salary,
            allowanceValue: allowance.value,
            allowanceCode: allowance.code,
            prePensionSalary: prePensionSalary,
            pensionContribution: pensionContribution,
            studentLoanPlan: studentLoan,
            niCode: nICode,
            timeFrame: preferredTimeFrame
        )
    }
    
    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.update(salary: aDecoder.decodeDouble(forKey: "salary"))
        self.update(pensionContribution: aDecoder.decodeDouble(forKey: "pensionContribution"))
        self.update(taxCode: aDecoder.decodeObject(forKey: "taxCode") as! String)
        if let niCode = NICode(rawValue: aDecoder.decodeObject(forKey: "niCode") as! String) {
            self.update(niCode: niCode)
        }
        if let studentPlan = StudentLoanPlan(rawValue: aDecoder.decodeObject(forKey: "studentPlan") as! String) {
            self.update(studentLoanPlan: studentPlan)
        }
        self.update(blind: aDecoder.decodeBool(forKey: "blind"))
        
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(salary, forKey: "salary")
        aCoder.encode(pensionContribution, forKey: "pensionContribution")
        aCoder.encode(prettyTaxCode, forKey: "taxCode")
        aCoder.encode(nICode.rawValue, forKey: "niCode")
        aCoder.encode(studentLoan.rawValue, forKey: "studentPlan")
        aCoder.encode(blind, forKey: "blind")
    }
    
    
    override var description: String {
        return "£\(Int(prePensionSalary)) / \(prettyTaxCode) / \((pensionContribution*100).roundTo(1))%"
    }
    
    func update(salary: Double) {
        prePensionSalary = salary
        if self.pensionContribution > 0 {
            self.salary = (1-self.pensionContribution)*prePensionSalary
        } else {
            self.salary = salary
        }
    }
    
    func update(pensionContribution: Double) {
        self.pensionContribution = pensionContribution/100.0
        update(salary: prePensionSalary)
    }
    
    func update(taxCode: String) {
        prettyTaxCode = taxCode
        var allowanceValue = 0.0
        if blind {
            allowanceValue += 2290
        }
        var allowanceCode: TaxCode = .L
        if let code = TaxCode(rawValue: taxCode) {
            allowanceCode = code
        } else {
            if let taxValue = Double(taxCode.trimmingCharacters(in: CharacterSet.letters)) {
                allowanceValue += taxValue*10
            }
            if let code = TaxCode(rawValue: taxCode.trimmingCharacters(in: CharacterSet.decimalDigits)) {
                allowanceCode = code
            }
        }
        allowance = (code: allowanceCode, value: allowanceValue)

    }
    
    func update(niCode: NICode) {
        self.nICode = niCode
    }
    
    func update(studentLoanPlan: StudentLoanPlan) {
        studentLoan = studentLoanPlan
    }
    
    func update(blind: Bool) {
        self.blind = blind
        update(taxCode: prettyTaxCode)
    }
    
    func calculate() {
        money = Calculator.sharedInstance.calculateValues(calculatableIndividual)
    }
    
    
    
}
