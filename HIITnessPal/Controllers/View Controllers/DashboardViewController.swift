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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let profile = ProfileController.sharedInstance.profile else {return}
        var calories: Double = 0.0
        var time: Int = 0
        var heartRate: Double = 0.0
        for cal in profile.caloriesBurnedThisWeek {
            calories += cal.calorieCount
        }
        for exercise in profile.exercisesThisWeek {
            time += exercise.exercise
        }
        for rate in profile.averageHeartRate {
            heartRate += rate.heartRate
        }
        heartRate = heartRate/Double(profile.averageHeartRate.count)
        if heartRate.isNaN {
            weeklyAvgHeartRateLabel.text = "N/A"
        } else {
            heartRate =
                Double( Int( heartRate/Double(profile.averageHeartRate.count)*100 ) )/100
            weeklyAvgHeartRateLabel.text = "\(heartRate)"
        }
        weeklyWorkoutMinLabel.text = "\(time)"
        weeklyCalLabel.text = "\(calories)"
        // Set some temporary data for the chart.
        for exercise in profile.exercisesThisWeek {
            let minute = ChartDataEntry(x: Double(exercise.daysElapsed), y: Double(exercise.exercise))
            // Append the temporary data to be read by the chart.
            self.minutes.append(minute)
        }
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



