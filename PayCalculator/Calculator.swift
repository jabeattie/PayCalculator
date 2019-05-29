//
//  Calculator.swift
//  PayCalculator
//
//  Created by James Beattie on 10/02/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
enum TaxCode: String, Codable {
    case L, P, Y, M, N, T
    case K
    case BR
    case D0
    case D1
    case NT
}

enum TimeFrame: Double, Codable {
    case yearly = 1
    case monthly = 12
    case weekly = 52
    case daily = 365
}

enum NICode: String, Codable {
    case A
    case None
    
    func getAmount(_ salary: Double) -> Double {
        let weeklyPay: Double = salary/52
        var amount: Double = 0
        let ty = TaxYear.sharedInstance
        switch self {
        case .None:
            break
        case .A:
            if weeklyPay < ty.niPT {
              break
            } else if weeklyPay <= ty.niUEL {
                amount += (weeklyPay-ty.niPT)*ty.niPTRate
            } else {
                amount += (ty.niUEL-ty.niPT)*ty.niPTRate
                amount += (weeklyPay-ty.niUEL)*ty.niUELRate
            }
        }
        return amount
    }
}
// swiftlint:enable identifier_name

enum StudentLoanPlan: String, Codable {
    case none
    case plan1
    case plan2
}

enum CategoryType: String, Codable {
    case pension
    case tax
    case ni
    case studentLoan
    case takeHomePay
    
    var description: String {
        return self.rawValue.stringFromCamelCase()
    }
}

enum TaxBrackets: String, Codable {
    case zero
    case basic
    case middle
    case upper
}

struct CalculatableIndividual {
    let salary: Double
    var allowanceValue: Double
    let allowanceCode: TaxCode
    let pensionNet: Bool
    let prePensionSalary: Double
    let pensionContribution: Double
    let pensionContributionCap: Double
    let studentLoanPlan: StudentLoanPlan
    let niCode: NICode
    let timeFrame: TimeFrame
}

struct Money: Codable {
    enum ValueType {
        case value
        case percent
    }
    
    var pension: Double = 0
    var pensionPercent: Double { return pension/total }
    var incomeTax: Double = 0
    var incomeTaxPercent: Double { return incomeTax/total }
    var nationalInsurance: Double = 0
    var nationalInsurancePercent: Double { return nationalInsurance/total }
    var studentLoan: Double = 0
    var studentLoanPercent: Double { return studentLoan/total }
    var takeHomePay: Double = 0
    var takeHomePayPercent: Double { return takeHomePay/total }
    var total: Double { return pension + incomeTax + nationalInsurance + studentLoan + takeHomePay }
    
    var timeFrame: TimeFrame = .yearly
    
    func getValues(_ type: ValueType) -> [CategoryType: Double] {
        var array = [CategoryType: Double]()
        switch type {
        case .value:
            array[.pension] = pension / timeFrame.rawValue
            array[.tax] = incomeTax / timeFrame.rawValue
            array[.ni] = nationalInsurance / timeFrame.rawValue
            array[.studentLoan] = studentLoan / timeFrame.rawValue
            array[.takeHomePay] = takeHomePay / timeFrame.rawValue
        case .percent:
            array[.pension] = pensionPercent
            array[.tax] = incomeTaxPercent
            array[.ni] = nationalInsurancePercent
            array[.studentLoan] = studentLoanPercent
            array[.takeHomePay] = takeHomePayPercent
        }
        return array
    }
}

class Calculator {
    
    var timeFrame = TimeFrame.yearly
    
    var taxYear = TaxYear.sharedInstance
    
    typealias StudentLoan = (rate: Double, value: Double)
    fileprivate var studentLoanPlans: [StudentLoanPlan: StudentLoan] = [
        StudentLoanPlan.none: (rate: 0, value:0),
        StudentLoanPlan.plan1: (rate: 0.09, value: 18935),
        StudentLoanPlan.plan2: (rate: 0.09, value: 21000)
    ]
    
    static var sharedInstance: Calculator = Calculator()
    
    func calculateValues(_ individual: CalculatableIndividual) -> Money {
        
        var money = Money()
        money.timeFrame = individual.timeFrame
        var localCI = individual
        
        if individual.salary > taxYear.salaryCap {
            if individual.salary > taxYear.salaryCap + individual.allowanceValue * 2 {
                localCI.allowanceValue = 0
            } else {
                localCI.allowanceValue -= (individual.salary - taxYear.salaryCap) / 2
            }
        }

        money.incomeTax = calculateIncomeTax(individual)
        money.nationalInsurance = calculateNI(individual)
        money.studentLoan = calculateStudentLoan(individual)
      
        var salariedPension = individual.prePensionSalary
        if !individual.pensionNet {
          salariedPension = min(individual.pensionContributionCap, individual.salary) - money.incomeTax - money.nationalInsurance
        }
        money.pension = individual.pensionContribution * salariedPension
        let pensionAmount = individual.pensionNet ? 0 : money.pension
      
        money.takeHomePay = individual.salary - money.incomeTax - money.nationalInsurance - money.studentLoan - pensionAmount
        
        return money
        
    }
    
    fileprivate func calculateIncomeTax(_ individual: CalculatableIndividual) -> Double {
        if individual.allowanceCode == .NT || individual.salary <= individual.allowanceValue {
            return taxYear.getTaxRate(bracket: .zero) * individual.salary
        } else if individual.allowanceCode == .BR {
            return taxYear.getTaxRate(bracket: .basic) * individual.salary
        } else if individual.allowanceCode == .D0 {
            return taxYear.getTaxRate(bracket: .middle) * individual.salary
        } else if individual.allowanceCode == .D1 {
            return taxYear.getTaxRate(bracket: .upper) * individual.salary
        } else {
            var taxableSalary = individual.salary - individual.allowanceValue
            var totalTax: Double = 0
            if taxableSalary <= taxYear.getTaxThreshold(bracket: .basic) {
                totalTax += taxableSalary * taxYear.getTaxRate(bracket: .basic)
            } else {
                totalTax += taxYear.getTaxThreshold(bracket: .basic) * taxYear.getTaxRate(bracket: .basic)
                taxableSalary -= taxYear.getTaxThreshold(bracket: .basic)
                if taxableSalary <= taxYear.getTaxThreshold(bracket: .middle) {
                    totalTax += taxableSalary * taxYear.getTaxRate(bracket: .middle)
                } else {
                    totalTax += taxYear.getTaxThreshold(bracket: .middle) * taxYear.getTaxRate(bracket: .middle)
                    taxableSalary -= taxYear.getTaxThreshold(bracket: .middle)
                    totalTax += taxableSalary * taxYear.getTaxRate(bracket: .upper)
                }
            }
            return totalTax
        }
    }
    
    fileprivate func calculateNI(_ individual: CalculatableIndividual) -> Double {
        let nI = 52 * individual.niCode.getAmount(individual.salary)
        return nI
    }
    
    fileprivate func calculateStudentLoan(_ individual: CalculatableIndividual) -> Double {
        let plan = studentLoanPlans[individual.studentLoanPlan]!
        if individual.salary < plan.value {
          return 0
        } else {
            return (individual.salary - plan.value) * plan.rate
        }
    }
}
