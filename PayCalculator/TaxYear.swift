//
//  TaxYear.swift
//  PayCalculator
//
//  Created by James Beattie on 12/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation

class TaxYear: NSObject {
    static var sharedInstance = TaxYear()
    
    var niPT: Double = 0
    var niPTRate: Double = 0
    var niUEL: Double = 0
    var niUELRate: Double = 0
    var taxZeroThresh: Double = 0
    var taxZeroRate: Double = 0
    var taxBasicThresh: Double = 0
    var taxBasicRate: Double = 0
    var taxMiddleThresh: Double = 0
    var taxMiddleRate: Double = 0
    var taxUpperRate: Double = 0
    var allowance: Int = 0
    var salaryCap: Double = 0
    
    override init() {
        super.init()
        loadYear()
        NotificationCenter.default.addObserver(self, selector: #selector(loadYear), name: Constants.taxYearChange, object: nil)
    }
    
    @objc func loadYear() {
      guard let path = Bundle.main.path(forResource: "YearRates", ofType: "plist"),
        let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else { return }
      var yearDict: [String: Any] = dict[User.sharedInstance.preferredTaxYear.plistName] as? [String: Any] ?? [:]
      
      niPT = (((yearDict["ni"] as? [String: Any])?["a"] as? [String: Any])?["lower"] as? [String: Any])?["threshold"] as? Double ?? 0
      niUEL = (((yearDict["ni"] as? [String: Any])?["a"] as? [String: Any])?["upper"] as? [String: Any])?["threshold"] as? Double ?? 0
      niPTRate = (((yearDict["ni"] as? [String: Any])?["a"] as? [String: Any])?["lower"] as? [String: Any])?["rate"] as? Double ?? 0
      niUELRate = (((yearDict["ni"] as? [String: Any])?["a"] as? [String: Any])?["upper"] as? [String: Any])?["rate"] as? Double ?? 0
      
      taxZeroThresh = ((yearDict["tax"] as? [String: Any])?["zero"] as? [String: Any])?["threshold"] as? Double ?? 0
      taxZeroRate = ((yearDict["tax"] as? [String: Any])?["zero"] as? [String: Any])?["rate"] as? Double ?? 0
      taxBasicThresh = ((yearDict["tax"] as? [String: Any])?["basic"] as? [String: Any])?["threshold"] as? Double ?? 0
      taxBasicRate = ((yearDict["tax"] as? [String: Any])?["basic"] as? [String: Any])?["rate"] as? Double ?? 0
      taxMiddleThresh = ((yearDict["tax"] as? [String: Any])?["middle"] as? [String: Any])?["threshold"] as? Double ?? 0
      taxMiddleRate = ((yearDict["tax"] as? [String: Any])?["middle"] as? [String: Any])?["rate"] as? Double ?? 0
      taxUpperRate = ((yearDict["tax"] as? [String: Any])?["upper"] as? [String: Any])?["rate"] as? Double ?? 0
      
      allowance = yearDict["allowance"] as? Int ?? 0
      salaryCap = yearDict["salaryCap"] as? Double ?? 0
    }
    
    func getTaxRate(bracket: TaxBrackets) -> Double {
        switch bracket {
        case .zero:
            return taxZeroRate
        case .basic:
            return taxBasicRate
        case .middle:
            return taxMiddleRate
        case .upper:
            return taxUpperRate
        }
    }
    
    func getTaxThreshold(bracket: TaxBrackets) -> Double {
        switch bracket {
        case .zero:
            return taxZeroThresh
        case .basic:
            return taxBasicThresh
        case .middle:
            return taxMiddleThresh
        case .upper:
            return Double.infinity
        }
    }
}
