//
//  ChartsNumberFormatter.swift
//  PayCalculator
//
//  Created by James Beattie on 10/10/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import UIKit
import Charts

class ChartsNumberFormatter: NumberFormatter, IValueFormatter {
    public func stringForValue(_ value: Double, entry: Charts.ChartDataEntry, dataSetIndex: Int, viewPortHandler: Charts.ViewPortHandler?) -> String{
        return "£\(self.string(from: (value as NSNumber)) ?? "")"
    }
}
