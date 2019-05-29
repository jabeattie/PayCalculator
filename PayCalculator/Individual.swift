//
//  Individual.swift
//  PayCalculator
//
//  Created by James Beattie on 27/04/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import Foundation

func == (lhs: Individual, rhs: Individual) -> Bool {
  return lhs.salary == rhs.salary &&
    rhs.prePensionSalary == lhs.prePensionSalary &&
    rhs.pensionContribution == lhs.pensionContribution &&
    rhs.prettyTaxCode == lhs.prettyTaxCode &&
    rhs.nICode == lhs.nICode &&
    rhs.studentLoan == lhs.studentLoan &&
    rhs.blind == lhs.blind
}

struct TaxInfo: Codable {
  var code: TaxCode = .L
  var value: Double = 12500
  
  init(code: TaxCode = .L, value: Double = 12500) {
    self.code = code
    self.value = value
  }
}

class Individual: Codable {
  
  static var sharedInstance = Individual()
  
  var pensionContributionCap: Double?
  var pensionNet: Bool = false
  var salary: Double = 0
  var weeklyPay: Double { return salary/52 }
  var prePensionSalary: Double = 0
  var pensionContribution: Double = 0
  var allowance: TaxInfo = TaxInfo()
  var prettyTaxCode: String = "1250L"
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
    let pensionCap: Double
    if let cap = pensionContributionCap {
      pensionCap = cap
    } else {
      pensionCap = salary
    }
    return CalculatableIndividual(
      salary: salary,
      allowanceValue: allowance.value,
      allowanceCode: allowance.code,
      pensionNet: pensionNet,
      prePensionSalary: prePensionSalary,
      pensionContribution: pensionContribution,
      pensionContributionCap: pensionCap,
      studentLoanPlan: studentLoan,
      niCode: nICode,
      timeFrame: preferredTimeFrame
    )
  }
  
  init() {
    
  }
  
  var description: String {
    return "£\(Int(prePensionSalary)) / \(prettyTaxCode) / \((pensionContribution*100).roundTo(1))%"
  }
  
  func update(salary: Double) {
    prePensionSalary = salary
    if self.pensionContribution > 0 && self.pensionNet {
      self.salary = (1-self.pensionContribution)*prePensionSalary
    } else {
      self.salary = salary
    }
  }
  
  func update(pensionNet: Bool) {
    self.pensionNet = pensionNet
    update(salary: prePensionSalary)
  }
  
  func update(pensionContributionCap: Double?) {
    self.pensionContributionCap = pensionContributionCap
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
    allowance = TaxInfo(code: allowanceCode, value: allowanceValue)
    
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

extension Individual: Equatable {}
