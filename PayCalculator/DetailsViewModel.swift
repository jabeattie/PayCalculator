//
//  DetailsViewModel.swift
//  PayCalculator
//
//  Created by James Beattie on 28/09/2019.
//  Copyright © 2019 James Beattie. All rights reserved.
//

import SwiftUI
import Combine

class DetailsViewModel: ObservableObject {
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    @Published var title: String = "£25,000 / 1250L / 0%"
    @Published var isValid: Bool = false
    @Published var studentLoan = SegmentedViewModel(options: ["None", "Plan 1", "Plan 2"], choice: 0)
    @Published var studentLoanChoice: String = ""
    
    init() {
        let subscriber = Subscribers.Assign(object: studentLoan, keyPath: \.selection)
        $studentLoanChoice.subscribe(subscriber)
    }
    
    var salary: String = "" {
        didSet {
            self.salary = limit(string: salary, to: CharacterSet.decimalDigits)
            updateSelf()
        }
    }
    
    var taxCode: String = "" {
        didSet {
            self.taxCode = limit(string: taxCode, to: CharacterSet.alphanumerics)
            updateSelf()
        }
    }
    
    var pensionPC: String = "" {
        didSet { updateSelf() }
    }
    
    var pensionType: String = "" {
        didSet { updateSelf() }
    }
    
    var pensionCap: String = "" {
        didSet { updateSelf() }
    }
    
    var noNI: Bool = false {
        didSet { updateSelf() }
    }
    
    var blind: Bool = false {
        didSet { updateSelf() }
    }
    
    private func updateSelf() {
        title = "\(salary) / \(taxCode) / \(pensionPC)%"
        isValid = calculateValidity()
        objectWillChange.send(())
    }
    
    private func calculateValidity() -> Bool {
        let salarySet = Double(salary) != nil
        let taxCodeSet = !taxCode.isEmpty
        return salarySet && taxCodeSet
    }
    
    private func limit(string: String, to characterSet: CharacterSet) -> String {
        let invertedCharacters = characterSet.inverted
        return string.trimmingCharacters(in: invertedCharacters)
    }
}
