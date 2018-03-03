//
//  Double+RoundToPlaces.swift
//  PayCalculator
//
//  Created by James Beattie on 24/09/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import Foundation

extension Double {
    func roundTo(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
