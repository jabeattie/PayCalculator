//
//  ChartViewController.swift
//  PayCalculator
//
//  Created by James Beattie on 09/10/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var timeFrame: UISegmentedControl!
    
    let individual = Individual.sharedInstance
    var currencyFormatter = ChartsNumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupChart()
        
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = Locale.current.currencySymbol
        currencyFormatter.maximumFractionDigits = 0
        
        switch individual.preferredTimeFrame {
        case .yearly: timeFrame.selectedSegmentIndex = 0
        case .monthly: timeFrame.selectedSegmentIndex = 1
        case .weekly: timeFrame.selectedSegmentIndex = 2
        case .daily: timeFrame.selectedSegmentIndex = 3
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadChartData()
    }
    
    func setupChart() {
        let legend = pieChartView.legend
        legend.textColor = Constants.Colours.OffWhite
        legend.font = UIFont.systemFont(ofSize: 14)
        legend.horizontalAlignment = .center
        pieChartView.backgroundColor = UIColor.clear
        pieChartView.holeColor = Constants.Colours.DarkGray
        pieChartView.drawCenterTextEnabled = false
        pieChartView.holeRadiusPercent = 0.8
        pieChartView.transparentCircleRadiusPercent = 0.8
        let description = Description()
        description.text = ""
        pieChartView.chartDescription = description
    }
    
    
    
    func loadChartData() {
        
        let values = individual.money.getValues(.value)
        
        var dataValues = [PieChartDataEntry]()
        for value in values {
            dataValues.append(PieChartDataEntry(value: value.value, label: value.key.description))
        }
        
        let dataSet = PieChartDataSet(values: dataValues, label: "")
        dataSet.xValuePosition = .insideSlice
        dataSet.yValuePosition = .insideSlice
        dataSet.valueTextColor = Constants.Colours.OffWhite
        dataSet.valueFont = UIFont.systemFont(ofSize: 14)
        
        dataSet.valueFormatter = currencyFormatter
        
        var colours = [UIColor]()
        colours.append(Constants.Colours.Blue)
        colours.append(Constants.Colours.Red)
        colours.append(Constants.Colours.Amber)
        colours.append(Constants.Colours.Yellow)
        colours.append(Constants.Colours.Green)
        
        dataSet.colors = colours
        
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.animate(yAxisDuration: 1, easingOption: .easeOutQuad)
    }
    
    @IBAction func timeFrameChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            individual.preferredTimeFrame = .yearly
        case 1:
            individual.preferredTimeFrame = .monthly
        case 2:
            individual.preferredTimeFrame = .weekly
        case 3:
            individual.preferredTimeFrame = .daily
        default:
            individual.preferredTimeFrame = .yearly
        }
        loadChartData()
    }
    
}
