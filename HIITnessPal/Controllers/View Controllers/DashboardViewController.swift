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

    // Outlets for the dashboard 
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var dashboardGradient: UIView!
    @IBOutlet weak var weeklyCalLabel: UILabel!
    @IBOutlet weak var weeklyWorkoutMinLabel: UILabel!
    @IBOutlet weak var weeklyAvgHeartRateLabel: UILabel!
    
    // Variables for the dashboard chart.
    var minutes: [ChartDataEntry] = []
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the gradient and the shadow for the title view.
        SetGradient.setGradient(view: dashboardGradient, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        dashboardGradient.layer.shadowOpacity = 0.3
        dashboardGradient.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // Set the chart description text
        lineChart.chartDescription?.text = ""
        
        // Set some temporary data for the chart.
        let minutes = ChartDataEntry(x: 10, y: 100)
        let minutes1 = ChartDataEntry(x: 20, y: 200)
        let minutes2 = ChartDataEntry(x: 30, y: 300)
        // Append the temporary data to be read by the chart.
        self.minutes.append(minutes)
        self.minutes.append(minutes1)
        self.minutes.append(minutes2)
        // Run the function to update the chart.
        updateDataChart()
    }
    
    // Function to update the chart.
    func updateDataChart() {
        // Set the chart data set from the controller data set.
        let chartDataSet = LineChartDataSet(entries: minutes, label: "Minutes")
        // Build the chart data from the data set.
        let chartData = LineChartData(dataSet: chartDataSet)
        // Build the chart specifications from the chart data set.
        chartDataSet.colors = [UIColor.getHIITPrimaryOrange]
        chartDataSet.circleColors = [UIColor.getHIITPrimaryOrange]
        chartDataSet.circleHoleColor = UIColor.getHIITPrimaryOrange
        chartDataSet.lineWidth = 3
       // chartDataSet.fill?.setGradient = SetGradient.setGradient(view: dashboardGradient, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange) as! CGGradient
        chartDataSet.valueTextColor = .clear
        
        // Build the chart.
        lineChart.data = chartData
    }
}



