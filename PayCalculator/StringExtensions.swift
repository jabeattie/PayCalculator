//
//  String+Regex.swift
//  PayCalculator
//
//  Created by James Beattie on 24/09/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import Foundation

infix operator =~
func =~(string: String, regex: String) -> Bool {
    return string.range(of: regex, options: String.CompareOptions.regularExpression, range: nil, locale: Locale.current) != nil
}

extension String {
    func stringFromCamelCase() -> String {
        var string = self
        let range = NSMakeRange(0, string.count)
        string = (string as NSString).replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: NSString.CompareOptions.regularExpression, range: range)
        return string.capitalized
    }
}
