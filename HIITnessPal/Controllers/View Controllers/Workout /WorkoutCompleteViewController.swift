//
//  WorkoutCompleteViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 9/2/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class WorkoutCompleteViewController: UIViewController {

    // Set IBOutlets
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var calorieCount: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var averageHeartRate: UILabel!
    
    let profile = ProfileController.sharedInstance.profile
    
    // Variable - Time placeholder.
    var time: Double = 0
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the title view's gradient and shadows.
        SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // Set the total time from the WorkoutTimerViewController
        time = WorkoutTimerViewController.totalTime
        // Set the minutes and seconds strings for the total time.
        let minutesString = "\( Int(time / 60) )"
        let secondsString = "\(Int(time.truncatingRemainder(dividingBy: 60.0)))"
        totalTime.text = minutesString + ":" + secondsString
        // Reset the totalTime for the next workout.
        WorkoutTimerViewController.totalTime = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        averageHeartRate.text = "\(HealthKitController.sharedInstance.averageHeartRate)"
        let minutes = time/60
        let calories = HealthKitController.sharedInstance.getCaloriesBurned(durationOfWorkoutInMinutes: minutes)
        let calorieDisplay = Double(Int(calories*100))/100
        calorieCount.text = "\(calorieDisplay)"
    }
    
    // Dismiss the current view controller and it's parent view controller.
    @IBAction func backButtonTapped(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // Dismiss the current view controller and it's parent view controller.
    // TODO: - Make saving do something.
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let profile = profile else {return}
        guard let calorie = calorieCount.text else {return}
        guard let calorieDouble = Double(calorie) else {return}
        ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: [Exercises(exercise: 1, daysElapsed: 0)], completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, weightsForWeeklyPlot: nil, caloriesBurnedThisWeek: [Calories(calorieCount: calorieDouble, daysElapsed: 0)])
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
        
        
        
        
    }
}
