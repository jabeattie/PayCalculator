//
//  ResultsViewModel.swift
//  PayCalculator
//
//  Created by James Beattie on 28/09/2019.
//  Copyright © 2019 James Beattie. All rights reserved.
//

import Foundation
import Combine

class ResultsViewModel: ObservableObject {
    @Published var period = SegmentedViewModel(options: ["Yearly", "Monthly", "Weekly", "Daily"], choice: 0)
    
    private let money: Money
    
    init(money: Money) {
        self.money = money
    }
    
    var pension: Decimal { money.pension }
    var tax: Decimal { money.incomeTax }
    var ni: Decimal { money.nationalInsurance }
    var studentLoan: Decimal { money.studentLoan }
    var takeHome: Decimal { money.takeHomePay }
}
