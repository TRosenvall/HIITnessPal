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
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dashboardImageView: UIImageView!
    @IBOutlet weak var calImageView: UIImageView!
    @IBOutlet weak var weeklyCalLabel: UILabel!
    @IBOutlet weak var weeklyCaloriesLabel: UILabel!
    @IBOutlet weak var minutesImageView: UIImageView!
    @IBOutlet weak var weeklyWorkoutMinLabel: UILabel!
    @IBOutlet weak var weeklyWorkoutMinutesLabel: UILabel!
    @IBOutlet weak var heartRateImageView: UIImageView!
    @IBOutlet weak var weeklyAvgHeartRateLabel: UILabel!
    @IBOutlet weak var weeklyheartRateLabel: UILabel!
    @IBOutlet weak var chartImageView: UIImageView!
    @IBOutlet weak var workoutMinutes: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var dashboardTabBarItem: UITabBarItem!
    
    // Variables for the dashboard chart.
    var minutes: [ChartDataEntry] = []
    var tabBarItemOne: UITabBarItem = UITabBarItem()
    static var fromWorkoutMainView: Bool = false
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        // Set the titleView gradient and shadows, disable the next button on loading.
        titleView.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        titleView.layer.masksToBounds = false
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        backButton.isHidden = true
        backButton.isEnabled = false
        
        chartImageView.isHidden = true
        workoutMinutes.isHidden = true
        // Set the chart description text
        lineChart.chartDescription?.text = ""
        
        lineChart.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabBarControllerItems = self.tabBarController?.tabBar.items

        if let arrayOfTabBarItems = tabBarControllerItems as AnyObject as? NSArray{

            tabBarItemOne = arrayOfTabBarItems[1] as! UITabBarItem
            tabBarItemOne.title = "My Plan"
        }
        
        setTabBarItems()
        initialFade()
        if DashboardViewController.fromWorkoutMainView == true {
            tabBarController?.tabBar.alpha = 0
        }
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
        weeklyCalLabel.text = "\(Double(Int(calories * 100))/100)"
        // Set some temporary data for the chart.
        for exercise in profile.exercisesThisWeek {
            let minute = ChartDataEntry(x: Double(exercise.daysElapsed), y: Double(exercise.exercise))
            // Append the temporary data to be read by the chart.
            self.minutes.append(minute)
        }
        // Run the function to update the chart.
        updateDataChart()
        
        self.viewDidAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //if DashboardViewController.fromWorkoutMainView == true {
            fadeIn()
            DashboardViewController.fromWorkoutMainView = false
            WorkoutTimerViewController.fromWorkoutComplete = false
        //}
    }
    
    override func viewWillLayoutSubviews() {
        var height: CGFloat = 0
        switch (getiPhoneSize()) {
        case "small":
            height = 82
        case "medium":
            height = 110
        case "large":
            height = 105
        case "x":
            height = 110
        case "r":
            height = 110
        default:
            print("Something went wrong getting iphone screen size")
        }
        // Set the height variable for the tab bar, here it's defined as 110 points above it's normal.
        var tabFrame: CGRect = (self.tabBarController?.tabBar.frame)!
        // Change the height of the tabBar, then move it up by that amount from the bottom.
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        // Set the new frame size here.
        self.tabBarController?.tabBar.frame = tabFrame
    }
    
    func getiPhoneSize () -> String {
        switch( self.view.frame.height) {
        case 568:
            return "small"
        case 667:
            return "medium"
        case 736:
            return "large"
        case 812:
            return "x"
        case 896:
            return "r"
        default:
            print("...")
            print("---")
            print(self.view.frame.height)
            print("---")
            print("...")
        }
        return ""
    }
    
    func initialFade() {
        for sub in self.view.subviews {
            if sub != titleView {
                sub.alpha = 0
            }
        }
        for sub in titleView.subviews {
            sub.alpha = 0
        }
    }
    
    func fadeOut(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            for sub in self.view.subviews {
                if sub != self.titleView {
                    sub.alpha = 0
                }
            }
            for sub in self.titleView.subviews {
                sub.alpha = 0
            }
        }) { (success) in
            completion(success)
        }
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.2) {
            for sub in self.view.subviews {
                if sub != self.titleView {
                    sub.alpha = 1
                }
            }
            for sub in self.titleView.subviews {
                sub.alpha = 1
            }
            self.tabBarController?.tabBar.alpha = 1
        }
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
        //chartDataSet.fill?.setGradient = SetGradient.setGradient(view: dashboardGradient, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange) as! CGGradient
        chartDataSet.valueTextColor = .clear
        
        // Build the chart.
        lineChart.data = chartData
    }
    
    // Function used to set the appropriate fonts and sizes for the tab bar item titles.
    func setTabBarItems() {
        dashboardTabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.getHIITPrimaryOrange], for: .selected)
        dashboardTabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.getHIITGray], for: .normal)
    }
    
    func setupConstraints() {
        var titleFontSize: CGFloat = 0
        var titleHeightMultiplier: CGFloat = 0
        var backButtonLeadingConstant: CGFloat = 0
        var backButtonBottomConstant: CGFloat = 0
        var backButtonHeightMultiplier: CGFloat = 0
        var titleLabelWidthMultiplier: CGFloat = 0
        var lineChartBottomConstant: CGFloat = 0
        
        switch (getiPhoneSize()) {
        case "small":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.7
            
            titleLabelWidthMultiplier = 0.9
            
            lineChartBottomConstant = -66
        case "medium":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.71
            
            titleLabelWidthMultiplier = 0.9
            
            lineChartBottomConstant = -88
        case "large":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.72
            
            titleLabelWidthMultiplier = 0.9
            
            lineChartBottomConstant = -88
        case "x":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.74
            
            titleLabelWidthMultiplier = 0.9
            
            lineChartBottomConstant = -88
        case "r":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9
            
            lineChartBottomConstant = -88
        default:
            print("Something went wrong getting iphone screen size")
        }
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleLabel.font.withSize(titleFontSize)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        dashboardImageView.translatesAutoresizingMaskIntoConstraints = false
        
        calImageView.translatesAutoresizingMaskIntoConstraints = false
        weeklyCaloriesLabel.translatesAutoresizingMaskIntoConstraints = false
        weeklyCalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        minutesImageView.translatesAutoresizingMaskIntoConstraints = false
        weeklyWorkoutMinLabel.translatesAutoresizingMaskIntoConstraints = false
        weeklyWorkoutMinutesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        heartRateImageView.translatesAutoresizingMaskIntoConstraints = false
        weeklyAvgHeartRateLabel.translatesAutoresizingMaskIntoConstraints = false
        weeklyheartRateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        chartImageView.translatesAutoresizingMaskIntoConstraints = false
        workoutMinutes.translatesAutoresizingMaskIntoConstraints = false
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: self.view.topAnchor),
            titleView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: titleHeightMultiplier),
            titleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        
            backButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: backButtonLeadingConstant),
            backButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: backButtonBottomConstant),
            backButton.heightAnchor.constraint(equalToConstant: titleView.frame.size.height * backButtonHeightMultiplier),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: titleView.widthAnchor, multiplier: titleLabelWidthMultiplier),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            dashboardImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            dashboardImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4),
            dashboardImageView.heightAnchor.constraint(equalTo: dashboardImageView.widthAnchor),
            dashboardImageView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -5),
            
            calImageView.topAnchor.constraint(equalTo: dashboardImageView.bottomAnchor, constant: -5),
            calImageView.heightAnchor.constraint(equalTo: dashboardImageView.heightAnchor, multiplier: 0.33),
            calImageView.widthAnchor.constraint(equalTo: calImageView.heightAnchor),
            calImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            weeklyCalLabel.topAnchor.constraint(equalTo: calImageView.topAnchor),
            weeklyCalLabel.leadingAnchor.constraint(equalTo: calImageView.trailingAnchor, constant: 6),
            weeklyCalLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            weeklyCalLabel.heightAnchor.constraint(equalTo: calImageView.heightAnchor, multiplier: 0.55),
            
            weeklyCaloriesLabel.bottomAnchor.constraint(equalTo: calImageView.bottomAnchor),
            weeklyCaloriesLabel.leadingAnchor.constraint(equalTo: calImageView.trailingAnchor, constant: 6),
            weeklyCaloriesLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            weeklyCaloriesLabel.heightAnchor.constraint(equalTo: calImageView.heightAnchor, multiplier: 0.35),
            
            
            minutesImageView.topAnchor.constraint(equalTo: calImageView.bottomAnchor, constant: 11),
            minutesImageView.heightAnchor.constraint(equalTo: dashboardImageView.heightAnchor, multiplier: 0.33),
            minutesImageView.widthAnchor.constraint(equalTo: calImageView.heightAnchor),
            minutesImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            weeklyWorkoutMinLabel.topAnchor.constraint(equalTo: minutesImageView.topAnchor),
            weeklyWorkoutMinLabel.leadingAnchor.constraint(equalTo: minutesImageView.trailingAnchor, constant: 6),
            weeklyWorkoutMinLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            weeklyWorkoutMinLabel.heightAnchor.constraint(equalTo: minutesImageView.heightAnchor, multiplier: 0.55),
            
            weeklyWorkoutMinutesLabel.bottomAnchor.constraint(equalTo: minutesImageView.bottomAnchor),
            weeklyWorkoutMinutesLabel.leadingAnchor.constraint(equalTo: minutesImageView.trailingAnchor, constant: 6),
            weeklyWorkoutMinutesLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            weeklyWorkoutMinutesLabel.heightAnchor.constraint(equalTo: minutesImageView.heightAnchor, multiplier: 0.35),
            
            
            heartRateImageView.topAnchor.constraint(equalTo: minutesImageView.bottomAnchor, constant: 11),
            heartRateImageView.heightAnchor.constraint(equalTo: dashboardImageView.heightAnchor, multiplier: 0.33),
            heartRateImageView.widthAnchor.constraint(equalTo: calImageView.heightAnchor),
            heartRateImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            weeklyAvgHeartRateLabel.topAnchor.constraint(equalTo: heartRateImageView.topAnchor),
            weeklyAvgHeartRateLabel.leadingAnchor.constraint(equalTo: heartRateImageView.trailingAnchor, constant: 6),
            weeklyAvgHeartRateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            weeklyAvgHeartRateLabel.heightAnchor.constraint(equalTo: heartRateImageView.heightAnchor, multiplier: 0.55),

            weeklyheartRateLabel.bottomAnchor.constraint(equalTo: heartRateImageView.bottomAnchor),
            weeklyheartRateLabel.leadingAnchor.constraint(equalTo: heartRateImageView.trailingAnchor, constant: 6),
            weeklyheartRateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            weeklyheartRateLabel.heightAnchor.constraint(equalTo: heartRateImageView.heightAnchor, multiplier: 0.35),
            
            chartImageView.topAnchor.constraint(equalTo: heartRateImageView.bottomAnchor, constant: 11),
            chartImageView.heightAnchor.constraint(equalTo: dashboardImageView.heightAnchor, multiplier: 0.33),
            chartImageView.widthAnchor.constraint(equalTo: calImageView.heightAnchor),
            chartImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            workoutMinutes.centerYAnchor.constraint(equalTo: chartImageView.centerYAnchor),
            workoutMinutes.leadingAnchor.constraint(equalTo: heartRateImageView.trailingAnchor, constant: 6),
            workoutMinutes.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            workoutMinutes.heightAnchor.constraint(equalTo: chartImageView.heightAnchor, multiplier: 0.55),
            
            lineChart.topAnchor.constraint(equalTo: chartImageView.topAnchor),
            lineChart.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            lineChart.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: lineChartBottomConstant),
            lineChart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}



