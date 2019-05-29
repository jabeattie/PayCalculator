//
//  BarView.swift
//  PayCalculator
//
//  Created by James Beattie on 24/09/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import UIKit

class BarView: UIView {
    
    @IBOutlet weak var innerBar: UIView!
    @IBOutlet weak var innerBarWidth: NSLayoutConstraint!
    
    func change(percent: Double, animated: Bool) {
        innerBarWidth.constant = CGFloat(percent)*self.frame.size.width
        if animated {
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.7,
                           options: .curveEaseOut,
                           animations: {
                            self.layoutIfNeeded()
                           },
                           completion: nil)
        } else {
            self.setNeedsLayout()
        }
    }

}
