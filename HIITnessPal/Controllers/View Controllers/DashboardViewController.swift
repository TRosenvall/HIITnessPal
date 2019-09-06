//
//  DashboardViewController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: UIViewController {

    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var weeklyWorkoutMinLabel: UILabel!
    @IBOutlet weak var weeklyCalLabel: UILabel!
    @IBOutlet weak var dashboardGradient: UIView!
    @IBOutlet weak var weeklyAvgHeartRateLabel: UILabel!
    
    var minutes: [ChartDataEntry] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardGradient.layer.shadowOpacity = 0.3
        dashboardGradient.layer.shadowOffset = CGSize(width: 0, height: 3)
        lineChart.chartDescription?.text = ""
        
          SetGradient.setGradient(view: dashboardGradient, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)

        // Do any additional setup after loading the view.
        
        let minutes = ChartDataEntry(x: 10, y: 100)
        let minutes1 = ChartDataEntry(x: 20, y: 200)
        let minutes2 = ChartDataEntry(x: 30, y: 300)
        self.minutes.append(minutes)
        self.minutes.append(minutes1)
        self.minutes.append(minutes2)
        updateDataChart()
    } 
    
    func updateDataChart() {
        print(minutes)
        let chartDataSet = LineChartDataSet(entries: minutes, label: "Minutes")
        let chartData = LineChartData(dataSet: chartDataSet)
        chartDataSet.colors = [UIColor.getHIITPrimaryOrange]
        chartDataSet.circleColors = [UIColor.getHIITPrimaryOrange]
        chartDataSet.circleHoleColor = UIColor.getHIITPrimaryOrange
        chartDataSet.lineWidth = 3
       // chartDataSet.fill?.setGradient = SetGradient.setGradient(view: dashboardGradient, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange) as! CGGradient
        chartDataSet.valueTextColor = .clear
        
        lineChart.data = chartData
        
    }
}



