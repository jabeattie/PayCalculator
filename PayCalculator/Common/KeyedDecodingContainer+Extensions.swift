//
//  KeyedDecodingContainer+Extensions.swift
//  PayCalculator
//
//  Created by James Beattie on 27/05/2020.
//  Copyright © 2020 James Beattie. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    
    func decode(_ type: Decimal.Type, forKey key: K) throws -> Decimal {
        let doubleValue = try decode(Double.self, forKey: key)
        guard let decimalValue = Decimal(string: Formatter.decimal.string(for: doubleValue) ?? "") else {
            let context = DecodingError.Context(codingPath: [key], debugDescription: "The key \(key) couldn't be converted to a Decimal value")
            throw DecodingError.typeMismatch(type, context)
        }
        return decimalValue
    }
    
}

extension Formatter {
    
    static let decimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = false
        return formatter
    }()

}
