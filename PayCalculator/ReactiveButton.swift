//
//  ReactiveButton.swift
//  PayCalculator
//
//  Created by James Beattie on 23/05/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import UIKit
import pop

class ReactiveButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scale = pop_animation(forKey: "scale") as? POPSpringAnimation {
            scale.toValue = NSValue(cgPoint: CGPoint(x: 0.8, y: 0.8))
        } else {
            let scale = POPSpringAnimation(propertyNamed: kPOPViewScaleXY) as POPSpringAnimation
            scale.toValue = NSValue(cgPoint: CGPoint(x: 0.8, y: 0.8))
            scale.springBounciness = 20
            scale.springSpeed = 18.0
            pop_add(scale, forKey: "scale")
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scale = pop_animation(forKey: "scale") as? POPSpringAnimation {
            scale.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
        } else {
            let scale = POPSpringAnimation(propertyNamed: kPOPViewScaleXY) as POPSpringAnimation
            scale.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
            scale.springBounciness = 20
            scale.springSpeed = 18.0
            pop_add(scale, forKey: "scale")
        }
        super.touchesEnded(touches, with: event)
    }

}
