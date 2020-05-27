import Foundation

struct Money {
    enum ValueType {
        case value
        case percent
    }
    
    var pension: Decimal = 0
    var pensionPercent: Decimal { return pension/total }
    var incomeTax: Decimal = 0
    var incomeTaxPercent: Decimal { return incomeTax/total }
    var nationalInsurance: Decimal = 0
    var nationalInsurancePercent: Decimal { return nationalInsurance/total }
    var studentLoan: Decimal = 0
    var studentLoanPercent: Decimal { return studentLoan/total }
    var takeHomePay: Decimal = 0
    var takeHomePayPercent: Decimal { return takeHomePay/total }
    var total: Decimal { return pension + incomeTax + nationalInsurance + studentLoan + takeHomePay }
    
    var timeFrame: TimeFrame = .yearly
    
    func getValues(_ type: ValueType) -> [CategoryType: Decimal] {
        var array = [CategoryType: Decimal]()
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
