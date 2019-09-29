//
//  Text+Extensions.swift
//  PayCalculator
//
//  Created by James Beattie on 28/09/2019.
//  Copyright © 2019 James Beattie. All rights reserved.
//

import SwiftUI

extension Text {
    func headerText() -> Text {
        self
            .font(Font.custom("Avenir", size: 20))
            .foregroundColor(Asset.heading.uiColor)
    }
    
    func subheaderText() -> Text {
        self
            .font(Font.custom("Avenir", size: 17))
            .foregroundColor(Asset.heading.uiColor)
    }
}
