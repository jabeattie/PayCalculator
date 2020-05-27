//
//  String+Extensions.swift
//  PayCalculator
//
//  Created by James Beattie on 27/05/2020.
//  Copyright © 2020 James Beattie. All rights reserved.
//

import Foundation

extension String {
    func stringFromCamelCase() -> String {
        var string = self
      let range = NSRange(location: 0, length: string.count)
        string = (string as NSString)
          .replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: NSString.CompareOptions.regularExpression, range: range)
        return string.capitalized
    }
}
