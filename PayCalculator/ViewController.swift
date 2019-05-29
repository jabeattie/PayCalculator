//
//  ViewController.swift
//  PayCalculator
//
//  Created by James Beattie on 21/05/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import UIKit
import pop

class ViewController: UIViewController {
    
    @IBOutlet weak var menu: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    enum AnimationDirection {
        case inLeft
        case outLeft
        case inRight
        case outRight
    }
    
    var containerViewController: ContainerViewController?
    
    let individual = Individual.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.transform = CATransform3DMakeTranslation(view.bounds.size.width, 0, 0)
        previousBtn.layer.transform = CATransform3DMakeTranslation(40, 0, 0)
        previousBtn.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animate(animationDirection: .inRight, completionBlock: nil)
        descriptionLabel.text = individual.description
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedContainer" {
            containerViewController = segue.destination as? ContainerViewController
            containerViewController?.delegate = self
        }
    }
    
    @IBAction func didTap(_ sender: UIButton) {
        if sender == menu {
            self.sideMenuViewController?.localPresentLeftMenuViewController()
        } else if sender == previousBtn {
            animate(animationDirection: .outRight) { [unowned self] (_, finished) -> Void in
                if finished {
                    self.containerViewController?.goToView(segue: .input)
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
        
    }
    
    fileprivate func animate(animationDirection: AnimationDirection, completionBlock: ((POPAnimation?, Bool) -> Void)?) {
        if let containerViewPosition = containerView.layer.pop_animation(forKey: "containerViewPosition") as? POPSpringAnimation {
            switch animationDirection {
            case .inLeft, .inRight:
                containerViewPosition.toValue = 0
            case .outLeft:
                containerViewPosition.toValue = -view.bounds.size.width
            case .outRight:
                containerViewPosition.toValue = view.bounds.size.width
            }
        } else {
            let containerViewPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationX)
            switch animationDirection {
            case .inLeft, .inRight:
                containerViewPosition?.toValue = 0
            case .outLeft:
                containerViewPosition?.toValue = -view.bounds.size.width
            case .outRight:
                containerViewPosition?.toValue = view.bounds.size.width
            }
            containerViewPosition?.springSpeed = 18
            containerViewPosition?.springBounciness = 5
            containerViewPosition?.completionBlock = completionBlock
            containerView.layer.pop_add(containerViewPosition, forKey: "containerViewPosition")
        }
    }
  
    // swiftlint:disable:next function_body_length
    func animate(button: UIView, animateIn: Bool) {
        if let buttonScale = button.layer.pop_animation(forKey: "buttonScale") as? POPSpringAnimation {
            if animateIn {
                buttonScale.toValue = CGSize(width: 1, height: 1)
            } else {
                buttonScale.toValue = CGSize(width: 0.4, height: 0.4)
            }
        } else {
            let buttonScale = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            if animateIn {
                buttonScale?.fromValue = CGSize(width: 0.4, height: 0.4)
                buttonScale?.toValue = CGSize(width: 1, height: 1)
            } else {
                buttonScale?.fromValue = CGSize(width: 1, height: 1)
                buttonScale?.toValue = CGSize(width: 0.4, height: 0.4)
            }
            buttonScale?.springSpeed = 20
            buttonScale?.springBounciness = 12
            buttonScale?.completionBlock = nil
            button.layer.pop_add(buttonScale, forKey: "buttonScale")
        }
        if let buttonAlpha = button.layer.pop_animation(forKey: "buttonAlpha") as? POPBasicAnimation {
            if animateIn {
                buttonAlpha.toValue = 1
            } else {
                buttonAlpha.toValue = 0
            }
        } else {
            let buttonAlpha = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            if animateIn {
                buttonAlpha?.fromValue = 0
                buttonAlpha?.toValue = 1
            } else {
                buttonAlpha?.fromValue = 1
                buttonAlpha?.toValue = 0
            }
            buttonAlpha?.duration = 0.5
            buttonAlpha?.completionBlock = nil
            button.pop_add(buttonAlpha, forKey: "buttonAlpha")
        }
        if let buttonPosition = button.layer.pop_animation(forKey: "buttonPosition") as? POPSpringAnimation {
            if animateIn {
                buttonPosition.toValue = 0
            } else {
                buttonPosition.toValue = 50
            }
        } else {
            let buttonPosition = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
            if animateIn {
                buttonPosition?.fromValue = 50
                buttonPosition?.toValue = 0
            } else {
                buttonPosition?.fromValue = 0
                buttonPosition?.toValue = 50
            }
            buttonPosition?.springSpeed = 20
            buttonPosition?.springBounciness = 12
            buttonPosition?.completionBlock = nil
            button.layer.pop_add(buttonPosition, forKey: "buttonPosition")
        }
    }

}

extension ViewController: ContainerViewControllerDelegate {
    func valuesUpdated() {
        descriptionLabel.text = individual.description
    }
    
    func moveToView(segue: Segue) {
        print(segue.rawValue)
        let animationDirection: AnimationDirection
        switch segue {
        case .bars:
            animationDirection = .outLeft
        case .input:
            animationDirection = .outRight
        }
        animate(animationDirection: animationDirection) { [unowned self] (_, finished) -> Void in
            if finished {
                self.containerViewController?.goToView(segue: segue)
            }
        }
        
    }
    
    func viewLoaded(segue: Segue, callback: ((Bool) -> Void)?) {
        switch segue {
        case .bars:
            containerView.layer.transform = CATransform3DMakeTranslation(view.bounds.size.width, 0, 0)
            animate(animationDirection: .inRight) { [unowned self] (_, finished) in
                if finished {
                    callback?(true)
                    self.animate(button: self.previousBtn, animateIn: true)
                }
                
            }
        case .input:
            containerView.layer.transform = CATransform3DMakeTranslation(-view.bounds.size.width, 0, 0)
            animate(animationDirection: .inLeft) { [unowned self] (_, finished) in
                if finished {
                    self.animate(button: self.previousBtn, animateIn: false)
                }
            }
        }
    }
}
