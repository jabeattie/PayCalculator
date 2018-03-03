//
//  SlidingTextField.swift
//  PayCalculator
//
//  Created by James Beattie on 12/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit

class SlidingTextField: UITextField {
    
    var slidingLayer: CALayer?
    
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    func animateBackground(color: UIColor) {
        slidingLayer = CALayer()
        slidingLayer?.frame = CGRect(x: -self.bounds.size.width, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        slidingLayer?.backgroundColor = color.cgColor
//        self.layer.addSublayer(slidingLayer!)
        self.layer.insertSublayer(slidingLayer!, at: 0)
        
        let animation = CABasicAnimation()
        animation.keyPath = "position.x"
        animation.byValue = self.bounds.size.width
        animation.duration = 0.25
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        slidingLayer?.add(animation, forKey: "Splash")
    }
    
    func animateBackgroundOut() {
        guard let slidingLayer = slidingLayer else { return }
        
        CATransaction.begin()
        let animation = CABasicAnimation()
        animation.keyPath = "position.x"
        animation.fromValue = self.bounds.size.width / 2
        animation.toValue = -self.bounds.size.width / 2
        animation.duration = 0.25
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//        animation.fillMode = kCAFillModeForwards
//        animation.isRemovedOnCompletion = false
//        slidingLayer.add(animation, forKey: "Splash")
        
        
        // Callback function
//        CATransaction.setCompletionBlock {
//            print("end animation")
//            slidingLayer.removeFromSuperlayer()
//        }
        
        // Do the actual animation and commit the transaction
        slidingLayer.add(animation, forKey: "Splash")
        CATransaction.commit()
    }
}
