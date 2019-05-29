//
//  HamburgerButton.swift
//  PayCalculator
//
//  Created by James Beattie on 23/05/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import UIKit
import pop

class HamburgerButton: ReactiveButton {

    var top: UIView!
    var middle: UIView!
    var bottom: UIView!
    var open = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupButton()
    }
    
    func setupButton() {
        backgroundColor = UIColor.clear
        
        let sectionWidth = bounds.size.width
        let sectionHeight = 0.2*bounds.size.height
        
        top = UIView(frame: CGRect(x: 0, y: 0, width: sectionWidth, height: sectionHeight))
        top.backgroundColor = UIColor(red: 171/255.0, green: 26/255.0, blue: 37/255.0, alpha: 1.0)
        top.isUserInteractionEnabled = false
        top.layer.cornerRadius = sectionHeight/2
        addSubview(top)
        
        middle = UIView(frame: CGRect(x: 0, y: 0.4*bounds.size.height, width: sectionWidth, height: sectionHeight))
        middle.backgroundColor = UIColor(red: 171/255.0, green: 26/255.0, blue: 37/255.0, alpha: 1.0)
        middle.isUserInteractionEnabled = false
        middle.layer.cornerRadius = sectionHeight/2
        addSubview(middle)
        
        bottom = UIView(frame: CGRect(x: 0, y: 0.8*bounds.size.height, width: sectionWidth, height: sectionHeight))
        bottom.backgroundColor = UIColor(red: 171/255.0, green: 26/255.0, blue: 37/255.0, alpha: 1.0)
        bottom.isUserInteractionEnabled = false
        bottom.layer.cornerRadius = sectionHeight/2
        addSubview(bottom)
        
        addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
  
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    @objc func didTap(_ sender: HamburgerButton) {
        if open {
            open = false
            
            UIView.animate(withDuration: 0.2, animations: { 
                self.middle.alpha = 1.0
            })
            
            if let topRotate = top.layer.pop_animation(forKey: "topRotate") as? POPSpringAnimation {
                topRotate.toValue = 0
            } else {
                let topRotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
                topRotate?.toValue = 0
                topRotate?.springSpeed = 18
                topRotate?.springBounciness = 11
                top.layer.pop_add(topRotate, forKey: "topRotate")
            }
            
            if let bottomRotate = bottom.layer.pop_animation(forKey: "bottomRotate") as? POPSpringAnimation {
                bottomRotate.toValue = 0
            } else {
                let bottomRotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
                bottomRotate?.toValue = 0
                bottomRotate?.springSpeed = 18
                bottomRotate?.springBounciness = 11
                bottom.layer.pop_add(bottomRotate, forKey: "bottomRotate")
            }
            
            if let topPosition = top.layer.pop_animation(forKey: "topPosition") as? POPSpringAnimation {
                topPosition.toValue = 0
            } else {
                let topPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                topPosition?.toValue = 0
                topPosition?.springSpeed = 18
                topPosition?.springBounciness = 0
                top.layer.pop_add(topPosition, forKey: "topPosition")
            }
            
            if let bottomPosition = bottom.layer.pop_animation(forKey: "bottomPosition") as? POPSpringAnimation {
                bottomPosition.toValue = 0
            } else {
                let bottomPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                bottomPosition?.toValue = 0
                bottomPosition?.springSpeed = 18
                bottomPosition?.springBounciness = 0
                bottom.layer.pop_add(bottomPosition, forKey: "bottomPosition")
            }
            
            if let topColor = top.layer.pop_animation(forKey: "topColor") as? POPSpringAnimation {
                topColor.toValue = UIColor(red: 171/255.0, green: 26/255.0, blue: 37/255.0, alpha: 1.0)
            } else {
                let topColor = POPSpringAnimation(propertyNamed: kPOPLayerBackgroundColor)
                topColor?.toValue = UIColor(red: 171/255.0, green: 26/255.0, blue: 37/255.0, alpha: 1.0)
                topColor?.springSpeed = 18
                topColor?.springBounciness = 0
                top.layer.pop_add(topColor, forKey: "topColor")
            }
            
            if let bottomColor = bottom.layer.pop_animation(forKey: "bottomColor") as? POPSpringAnimation {
                bottomColor.toValue = UIColor(red: 171/255.0, green: 26/255.0, blue: 37/255.0, alpha: 1.0)

            } else {
                let bottomColor = POPSpringAnimation(propertyNamed: kPOPLayerBackgroundColor)
                bottomColor?.toValue = UIColor(red: 171/255.0, green: 26/255.0, blue: 37/255.0, alpha: 1.0)
                bottomColor?.springSpeed = 18
                bottomColor?.springBounciness = 0
                bottom.layer.pop_add(bottomColor, forKey: "bottomColor")
            }
            
        } else {
            open = true
          
            UIView.animate(withDuration: 0.2, animations: {
                self.middle.alpha = 0.0
            })
            
            if let topRotate = top.layer.pop_animation(forKey: "topRotate") as? POPSpringAnimation {
                topRotate.toValue = -Double.pi / 4
            } else {
                let topRotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
                topRotate?.toValue = -Double.pi / 4
                topRotate?.springSpeed = 18
                topRotate?.springBounciness = 11
                top.layer.pop_add(topRotate, forKey: "topRotate")
            }
            
            if let bottomRotate = bottom.layer.pop_animation(forKey: "bottomRotate") as? POPSpringAnimation {
                bottomRotate.toValue = Double.pi / 4
            } else {
                let bottomRotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
                bottomRotate?.toValue = Double.pi / 4
                bottomRotate?.springSpeed = 18
                bottomRotate?.springBounciness = 11
                bottom.layer.pop_add(bottomRotate, forKey: "bottomRotate")
            }
            
            if let topPosition = top.layer.pop_animation(forKey: "topPosition") as? POPSpringAnimation {
                topPosition.toValue = bounds.size.height*0.4
            } else {
                let topPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                topPosition?.toValue = bounds.size.height*0.4
                topPosition?.springSpeed = 18
                topPosition?.springBounciness = 5
                top.layer.pop_add(topPosition, forKey: "topPosition")
            }
            
            if let bottomPosition = bottom.layer.pop_animation(forKey: "bottomPosition") as? POPSpringAnimation {
                bottomPosition.toValue = -bounds.size.height*0.4
            } else {
                let bottomPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                bottomPosition?.toValue = -bounds.size.height*0.4
                bottomPosition?.springSpeed = 18
                bottomPosition?.springBounciness = 5
                bottom.layer.pop_add(bottomPosition, forKey: "bottomPosition")
            }
            
            if let topColor = top.layer.pop_animation(forKey: "topColor") as? POPSpringAnimation {
                topColor.toValue = UIColor(red: 0, green: 38/255.0, blue: 53/255.0, alpha: 1.0)
                topColor.toValue = UIColor.red
            } else {
                let topColor = POPSpringAnimation(propertyNamed: kPOPLayerBackgroundColor)
                topColor?.toValue = UIColor(red: 0, green: 38/255.0, blue: 53/255.0, alpha: 1.0)
                topColor?.springSpeed = 18
                topColor?.springBounciness = 0
                top.layer.pop_add(topColor, forKey: "topColor")
            }
            
            if let bottomColor = bottom.layer.pop_animation(forKey: "bottomColor") as? POPSpringAnimation {
                bottomColor.toValue = UIColor(red: 0, green: 38/255.0, blue: 53/255.0, alpha: 1.0)
                bottomColor.toValue = UIColor.red
                
            } else {
                let bottomColor = POPSpringAnimation(propertyNamed: kPOPLayerBackgroundColor)
                bottomColor?.toValue = UIColor(red: 0, green: 38/255.0, blue: 53/255.0, alpha: 1.0)
                bottomColor?.springSpeed = 18
                bottomColor?.springBounciness = 0
                bottom.layer.pop_add(bottomColor, forKey: "bottomColor")
            }
        }
    }
}
