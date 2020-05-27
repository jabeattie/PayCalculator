import Foundation

class User {
    let timeKey = "preferredTimeFrame"
    let taxKey = "preferredTaxYear"
    
    static let shared = User()
    
    init() {
        let defaults = UserDefaults.standard
        
        if let tYString = defaults.value(forKey: taxKey) as? String, let taxYear = TaxYear.Year(rawValue: tYString) {
            preferredTaxYear = taxYear
        }
        if let tFDecimal = defaults.value(forKey: timeKey) as? Decimal, let timeFrame = TimeFrame(rawValue: tFDecimal) {
            preferredTimeFrame = timeFrame
        }
    }
    
    var preferredTimeFrame: TimeFrame = .yearly {
        didSet {
            store()
        }
    }
    
    var preferredTaxYear: TaxYear.Year = .y2021 {
        didSet {
//            TaxYear.sharedInstance.loadYear()
//            Individual.sharedInstance.update(taxCode: "\(TaxYear.sharedInstance.allowance)L")
//            Individual.sharedInstance.calculate()
            store()
        }
    }
    
    func store() {
        let defaults = UserDefaults.standard
        defaults.set(preferredTimeFrame.rawValue, forKey: timeKey)
        defaults.set(preferredTaxYear.rawValue, forKey: taxKey)
    }
    
}
