//
//  MyPlanViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class MyPlanViewController: UIViewController {

    // Setup IBOutlets
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var preferenceLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var idealPlanSlider: UISlider!
    @IBOutlet weak var workoutsInAWeekLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    
    let profile = ProfileController.sharedInstance.profile
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the title views gradient and shadow.
        SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)

        // Set the progressView, backButton, nextButton, and preferenceLabel for first time users
        guard let profile = profile else {return}
        if profile.firstLogin {
            progressView.isHidden = false
            doneButton.isHidden = false
            preferenceLabel.isHidden = false
        } else {
            progressView.isHidden = true
            preferenceLabel.isHidden = true
            doneButton.setTitle("Save", for: .normal)
        }
        
        // Set idealPlanSlider
        idealPlanSlider.value = Float(profile.idealPlan)
        workoutsInAWeekLabel.text = "\(Int(idealPlanSlider.value + 1)) Workouts Every Week"
        minutesLabel.text = "\(Int((idealPlanSlider.value*5) + 15)) Minutes"
    }
    
    // Dismiss the viewController when the back button is tapped.
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Dismiss the view controller when the done botton is tapped.
    @IBAction func doneButtonTapped(_ sender: Any) {
        // Update the profile to indicate it's not the first login, set the idealPlan, and then take you back to the dashboard.
        guard let profile = profile else {return}
        ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: Int(idealPlanSlider.value), reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, weightsForWeeklyPlot: nil, caloriesBurnedThisWeek: nil)
        if profile.firstLogin {
            ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: false, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, weightsForWeeklyPlot: nil, caloriesBurnedThisWeek: nil)
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func idealPlanSliderValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        
        workoutsInAWeekLabel.text = "\(Int(roundedValue + 1)) Workouts Every Week"
        minutesLabel.text = "\(Int((roundedValue*5) + 15)) Minutes"
    }
    
}
