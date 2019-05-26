//
//  Array+RemoveObject.swift
//  PayCalculator
//
//  Created by James Beattie on 11/10/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    mutating func removeObject(object: Element) -> Bool {
      if let index = firstIndex(of: object) {
            remove(at: index)
            return true
        }
        return false
    }
}
