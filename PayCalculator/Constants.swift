//
//  Constants.swift
//  PayCalculator
//
//  Created by James Beattie on 15/02/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import UIKit

class Constants {
    enum Segue: String {
        case DataEntry
        case Values
        case Charts
        
        var identifier: String {
            return "\(self)EmbedSegue"
        }
    }
    
    class Colours {
        static let Red: UIColor = UIColor(red: 190/255.0, green: 63/255.0, blue: 63/255.0, alpha: 1.0)
        static let Yellow: UIColor = UIColor(red: 211/255.0, green: 172/255.0, blue: 0/255.0, alpha: 1.0)
        static let Amber: UIColor = UIColor(red: 252/255.0, green: 120/255.0, blue: 20/255.0, alpha: 1.0)
        static let Green: UIColor = UIColor(red: 57/255.0, green: 198/255.0, blue: 151/255.0, alpha: 1.0)
        static let Blue: UIColor = UIColor(red: 50/255.0, green: 170/255.0, blue: 245/255.0, alpha: 1.0)
        static let PaleBlue: UIColor = UIColor(red: 48/255.0, green: 76/255.0, blue: 80/255.0, alpha: 1.0)
        static let DarkGray: UIColor = UIColor(red: 20/255.0, green: 28/255.0, blue: 36/255.0, alpha: 1.0)
        static let OffWhite: UIColor = UIColor(red: 236/255.0, green: 240/255.0, blue: 241/255.0, alpha: 1.0)
        static let BlueTint: UIColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        
    }
    
    static let taxCodeRegex = "(^[1-9]{1}[0-9]{0,5}[TLPVY]([MW]1){0,1}$)|(^K[1-9]{1}[0-9]{0,5}([MW]1){0,1}$)|(^((BR)|(OT)|(D0)|(NT)|(FT))([MW]1){0,1}$)"
    
    static let timeFrameChange: NSNotification.Name = NSNotification.Name(rawValue: "TimeFrameChangeNotification")
    static let taxYearChange: NSNotification.Name = NSNotification.Name(rawValue: "TaxYearChangeNotification")
}
