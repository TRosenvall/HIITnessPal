//
//  ProfileViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/19/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // IBOutlets for the Views for the buttons and images.
    // IBOutlets and variables.
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var numberOfExercisesLabel: UILabel!
    @IBOutlet weak var numberOfMinutesExercisedLabel: UILabel!
    @IBOutlet weak var numberOfCaloriesBurnedLabel: UILabel!
    @IBOutlet weak var numberOfExercisesThisWeekLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    
    // Source Of Truth
    lazy var profile = ProfileController.sharedInstance.profile
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the title views gradient and shadow.
        SetGradient.setGradient(view: titleView, mainColor: .getHIITPrimaryOrange, secondColor: .getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }

    func setupViews() {
        guard let profile = profile else {return}
        // Set the outlet numbers
        let numberOfExercises = profile.completedExercises
        let numberOfMinutes = profile.totalTimeExercising
        var calorieBurn: [Double] = []
        for calorie in profile.caloriesBurnedThisWeek{
            calorieBurn.append(calorie.calorieCount)
        }
        let numberOfCalories = calorieBurn.reduce(0, +)
        let numberOfExercisesThisWeek = profile.exercisesThisWeek
        // Set the proper labels
        numberOfExercisesLabel.text = "\(numberOfExercises)"
        numberOfMinutesExercisedLabel.text = "\(numberOfMinutes)"
        // Set the correct numberOfCaloriesBurnedLabel, guard against nil values.
        if numberOfCalories == 0 {
            numberOfCaloriesBurnedLabel.text = "0"
        } else {
            numberOfCaloriesBurnedLabel.text = "\(numberOfCalories)"
        }
        calorieBurn = []
        // Set the correct number of exercises this week from the profile.
        numberOfExercisesThisWeekLabel.text = "\(numberOfExercisesThisWeek)"
    }
}
