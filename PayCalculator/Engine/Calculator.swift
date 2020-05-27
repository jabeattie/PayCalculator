import Foundation

struct CalculatableIndividual {
    let salary: Decimal
    var taxInfo: TaxInfo
    let pensionNet: Bool
    let prePensionSalary: Decimal
    let pensionContribution: Decimal
    let pensionContributionCap: Decimal
    let studentLoanPlan: StudentLoanPlan
    let niCode: NICode
    let timeFrame: TimeFrame
}

final class Calculator {
    
    private var timeFrame: TimeFrame
    private var taxYears: TaxYears
    private var taxYear: TaxYear
    
    init(timeFrame: TimeFrame = .yearly,
         taxYears: TaxYears = TaxYears.shared,
         user: User = User.shared) {
        self.timeFrame = timeFrame
        self.taxYears = taxYears
        self.taxYear = taxYears.getTaxYear(year: user.preferredTaxYear)
    }
    
    static var sharedInstance: Calculator = Calculator()
    
    func calculateValues(_ individual: CalculatableIndividual) -> Money {
        
        var money = Money()
        money.timeFrame = individual.timeFrame
        var localCI = individual
        
        if individual.salary > taxYear.salaryCap {
            if individual.salary > taxYear.salaryCap + individual.taxInfo.value * 2 {
                localCI.taxInfo.value = 0
            } else {
                localCI.taxInfo.value -= (individual.salary - taxYear.salaryCap) / 2
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
    
    fileprivate func calculateIncomeTax(_ individual: CalculatableIndividual) -> Decimal {
        if individual.taxInfo.code == .NT || individual.salary <= individual.taxInfo.value {
            return taxYear.getTaxRate(bracket: .zero) * individual.salary
        } else if individual.taxInfo.code == .BR {
            return taxYear.getTaxRate(bracket: .basic) * individual.salary
        } else if individual.taxInfo.code == .D0 {
            return taxYear.getTaxRate(bracket: .middle) * individual.salary
        } else if individual.taxInfo.code == .D1 {
            return taxYear.getTaxRate(bracket: .upper) * individual.salary
        } else {
            var taxableSalary = individual.salary - individual.taxInfo.value
            var totalTax: Decimal = 0
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
    
    fileprivate func calculateNI(_ individual: CalculatableIndividual) -> Decimal {
        let salary = individual.salary
        switch individual.niCode {
        case .a:
            let lowerThreshold = taxYear.getNIThreshold(code: individual.niCode, level: .lower)
            let upperThreshold = taxYear.getNIThreshold(code: individual.niCode, level: .upper)
            let lowerRate = taxYear.getNIRate(code: individual.niCode, level: .lower)
            let upperRate = taxYear.getNIRate(code: individual.niCode, level: .upper)
            if salary < lowerThreshold {
                return 0
            } else if salary < upperThreshold {
                let taxableSalary = salary - lowerThreshold
                return taxableSalary * lowerRate
            } else {
                let taxableAtLowerRate = upperThreshold - lowerThreshold
                let taxableAtHigherRate = salary - upperThreshold
                return taxableAtLowerRate * lowerRate + taxableAtHigherRate * upperRate
            }
        case .none:
            return 0
        }
    }
    
    fileprivate func calculateStudentLoan(_ individual: CalculatableIndividual) -> Decimal {
        let threshold = taxYear.getStudentLoanThreshold(plan: individual.studentLoanPlan)
        if individual.salary < threshold {
            return 0
        } else {
            return (individual.salary - threshold) * taxYear.getStudentLoanRate(plan: individual.studentLoanPlan)
        }
    }
}
