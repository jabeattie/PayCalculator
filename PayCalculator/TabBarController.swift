//
//  TabBarController.swift
//  PayCalculator
//
//  Created by James Beattie on 04/03/2018.
//  Copyright © 2018 James Beattie. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = InputViewModel()
        let inputViewController = InputViewController(viewModel: viewModel)
        let inputNavController = UINavigationController(rootViewController: inputViewController)
        inputNavController.navigationBar.barStyle = .black
        inputNavController.tabBarItem.image = UIImage(named: "Calculator")
        
        let settingsViewModel = SettingsViewModel()
        let settingsViewController = SettingsViewController(viewModel: settingsViewModel)
        let settingsNavController = UINavigationController(rootViewController: settingsViewController)
        self.viewControllers = [inputNavController, settingsNavController]
        
        self.tabBar.barStyle = .black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
