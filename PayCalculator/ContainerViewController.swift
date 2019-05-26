//
//  ContainerViewController.swift
//  PayCalculator
//
//  Created by James Beattie on 12/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit

protocol ContainerViewControllerDelegate {
    func valuesUpdated()
    func moveToView(segue: Segue)
    func viewLoaded(segue: Segue, callback: ((Bool) -> ())?)
}

enum Segue: String {
    case input = "embedFirst"
    case bars = "embedSecond"
}

class ContainerViewController: UIViewController {
    
    var currentSegueIdentifier: Segue = .input {
        didSet {
            performSegue(withIdentifier: currentSegueIdentifier.rawValue, sender: nil)
        }
    }
    
    var delegate: ContainerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Segue.input.rawValue) {
            guard let inputViewController = segue.destination as? InputViewController else { return }
            inputViewController.delegate = self
          if (children.count > 0) {
            swapFromViewController(fromViewController: children[0], toViewController: inputViewController)
            } else {
            addChild(inputViewController)
                inputViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
                view.addSubview(inputViewController.view)
            inputViewController.didMove(toParent: self)
            }
        } else if (segue.identifier == Segue.bars.rawValue) {
            guard let barsViewController = segue.destination as? BarsViewController else { return }
            barsViewController.delegate = self
          swapFromViewController(fromViewController: children[0], toViewController: barsViewController)
        }
    }
    
    func setup() {
        self.currentSegueIdentifier = Segue.input;
    }
    
    func swapFromViewController(fromViewController: UIViewController, toViewController: UIViewController) {
      toViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
      fromViewController.willMove(toParent: nil)
      addChild(toViewController)
      transition(from: fromViewController, to: toViewController, duration: 0.0, options: .transitionCrossDissolve, animations: nil) { (finished) in
        fromViewController.removeFromParent()
        toViewController.didMove(toParent: self)
      }
    }
    
    func swapViewControllers() {
        switch currentSegueIdentifier {
        case .bars:
            currentSegueIdentifier = .input
        case .input:
            currentSegueIdentifier = .bars
        }
    }
    
    func goToView(segue: Segue) {
        guard segue != currentSegueIdentifier else { return }
        currentSegueIdentifier = segue
    }

}

extension ContainerViewController: InputViewControllerDelegate {
    func calculatePressed() {
        delegate?.moveToView(segue: .bars)
    }
    
    func valuesUpdated() {
        delegate?.valuesUpdated()
    }
    
    func inputViewAppeared() {
        delegate?.viewLoaded(segue: .input, callback: nil)
    }
}

extension ContainerViewController: BarsViewControllerDelegate {
    func barsViewAppeared(callback: ((Bool) -> ())?) {
        delegate?.viewLoaded(segue: .bars, callback: callback)
    }
}
