//
//  MenuViewController.swift
//  PayCalculator
//
//  Created by James Beattie on 07/10/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var input: UIButton!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var savedTable: UITableView!
    @IBOutlet weak var recentTable: UITableView!
    
    lazy var individuals = Individuals.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        savedTable.dataSource = self
        savedTable.delegate = self
        recentTable.dataSource = self
        recentTable.delegate = self
    }
    
    @IBAction func didTap(_ sender: UIButton) {
        let navigationController = sideMenuViewController?.contentViewController as? UINavigationController
        let viewControllers = (sideMenuViewController?.contentViewController as? UINavigationController)?.viewControllers
        guard let currentViewController = navigationController?.visibleViewController else { return }
        
        switch sender {
        case input:
            var vC = viewControllers?.filter({ $0 as? ViewController != nil }).first as? ViewController
            if vC == currentViewController {
                break
            } else if vC == nil {
                vC = UIStoryboard(name: "Main", bundle: Bundle.main)
                  .instantiateViewController(withIdentifier: "MainViewController") as? ViewController
                _ = vC?.view
                navigationController?.pushViewController(vC!, animated: false)
            } else {
                _ = navigationController?.popToViewController(vC!, animated: false)
            }
        case settings:
            var settingsVC = viewControllers?.filter({ $0 as? SettingsViewController != nil }).first as? SettingsViewController
            if settingsVC == currentViewController {
                break
            } else if settingsVC == nil {
              settingsVC = UIStoryboard(name: "Main", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
              _ = settingsVC?.view
              navigationController?.pushViewController(settingsVC!, animated: false)
            } else {
                _ = navigationController?.popToViewController(settingsVC!, animated: false)
            }
        default:
            break
        }
        
        sideMenuViewController?.hideMenuViewController()
    }

}

extension MenuViewController: UITableViewDelegate {
    
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView == savedTable ?
          tableView.dequeueReusableCell(withIdentifier: "SavedCell")! :
          tableView.dequeueReusableCell(withIdentifier: "RecentCell")!
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = Constants.Colours.OffWhite
        cell.textLabel?.text = "Coming soon"
        return cell
    }
    
}
