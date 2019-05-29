//
//  User.swift
//  PayCalculator
//
//  Created by James Beattie on 12/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation

enum TaxYearEnum: String {
    case y1718
    case y1819
    case y1920
    
    var plistName: String {
        switch self {
        case .y1718: return "17/18"
        case .y1819: return "18/19"
        case .y1920: return "19/20"
        }
    }
}

class User {
    let timeKey = "preferredTimeFrame"
    let taxKey = "preferredTaxYear"
    
    static var sharedInstance = User()
    
    init() {
        let defaults = UserDefaults.standard
        
        if let tYString = defaults.value(forKey: taxKey) as? String, let tY = TaxYearEnum(rawValue: tYString) {
            preferredTaxYear = tY
        }
        if let tFDouble = defaults.value(forKey: timeKey) as? Double, let tF = TimeFrame(rawValue: tFDouble) {
            preferredTimeFrame = tF
        }
    }
    
    var preferredTimeFrame: TimeFrame = .yearly {
        didSet {
            Individual.sharedInstance.calculate()
            store()
        }
    }
    
    var preferredTaxYear: TaxYearEnum = .y1920 {
        didSet {
            TaxYear.sharedInstance.loadYear()
            Individual.sharedInstance.update(taxCode: "\(TaxYear.sharedInstance.allowance)L")
            Individual.sharedInstance.calculate()
            store()
        }
    }
    
    func store() {
        let defaults = UserDefaults.standard
        defaults.set(preferredTimeFrame.rawValue, forKey: timeKey)
        defaults.set(preferredTaxYear.rawValue, forKey: taxKey)
    }
    
}
