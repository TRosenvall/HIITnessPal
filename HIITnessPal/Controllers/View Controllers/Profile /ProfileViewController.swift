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
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var numberOfExercisesLabel: UILabel!
    @IBOutlet weak var exercisesCompletedLabel: UILabel!
    @IBOutlet weak var numberOfMinutesExercisedLabel: UILabel!
    @IBOutlet weak var minSpentExercisingLabel: UILabel!
    @IBOutlet weak var numberOfCaloriesBurnedLabel: UILabel!
    @IBOutlet weak var caloriesBurnedLabel: UILabel!
    @IBOutlet weak var numberOfExercisesThisWeekLabel: UILabel!
    @IBOutlet weak var exercisesThisWeakLabel: UILabel!
    @IBOutlet weak var aboutYouButton: UIButton!
    @IBOutlet weak var yourFitnessPlanButton: UIButton!
    @IBOutlet weak var reminders: UIButton!
    
    // Source Of Truth
    lazy var profile = ProfileController.sharedInstance.profile
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        // Set the title views gradient and shadow.
        titleView.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        titleView.layer.masksToBounds = false
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
        if let name = profile?.name {
            greetingLabel.text = "Hello \(name)!"
        }
        initialFade()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fadeIn()
        backButton.alpha = 0
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
    
    func setupViews() {
        guard let profile = profile else {return}
        // Set the outlet numbers
        let numberOfExercises = profile.completedExercises
        let numberOfMinutes = profile.totalTimeExercising
        var calorieBurn: [Double] = []
        for calorie in profile.caloriesBurnedThisWeek{
            calorieBurn.append(calorie.calorieCount)
        }
        var numberOfCalories = calorieBurn.reduce(0, +)
        let numberOfExercisesThisWeek = profile.exercisesThisWeek.count
        // Set the proper labels
        numberOfExercisesLabel.text = "\(numberOfExercises)"
        var minutes: String = ""
        var seconds: String = ""
        if numberOfMinutes < 10 {
            minutes = "0\(Int(numberOfMinutes))"
        } else {
            minutes = "\(Int(numberOfMinutes))"
        }
        if Int((numberOfMinutes - Double(Int(numberOfMinutes)))*60) < 10 {
            seconds = "0\(Int((numberOfMinutes - Double(Int(numberOfMinutes)))*60))"
        } else {
            seconds = "\(Int((numberOfMinutes - Double(Int(numberOfMinutes)))*60))"
        }
        numberOfMinutesExercisedLabel.text = "\(minutes):\(seconds)"
        // Set the correct numberOfCaloriesBurnedLabel, guard against nil values.
        if numberOfCalories == 0 {
            numberOfCaloriesBurnedLabel.text = "0"
        } else {
            numberOfCalories = Double(Int(numberOfCalories * 100)) / 100
            numberOfCaloriesBurnedLabel.text = "\(numberOfCalories)"
        }
        calorieBurn = []
        // Set the correct number of exercises this week from the profile.
        numberOfExercisesThisWeekLabel.text = "\(numberOfExercisesThisWeek)"
    }
    
    @IBAction func aboutYouButtonTapped(_ sender: Any) {
        WorkoutEditViewController.fromWorkoutMainViewController = true
        DispatchQueue.main.async {
            // Pull the Appropriate storyboard with the needed view controller.
            let storyboard = UIStoryboard(name: "HiitnessProfile", bundle: nil)
            // Set our viewController as the CreateWorkoutViewController.
            let viewController = storyboard.instantiateViewController(withIdentifier: "AboutMeStoryboard")
            
            viewController.modalPresentationStyle = .fullScreen
            
            // Present the viewController outside of the navigation controller so as not to carry on the tab bar controller.
            self.fadeOut { (success) in
                if success {
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
    }
    
    @IBAction func yourFitnessPlanButtonTapped(_ sender: Any) {
        WorkoutEditViewController.fromWorkoutMainViewController = true
        DispatchQueue.main.async {
            // Pull the Appropriate storyboard with the needed view controller.
            let storyboard = UIStoryboard(name: "HiitnessProfile", bundle: nil)
            // Set our viewController as the CreateWorkoutViewController.
            let viewController = storyboard.instantiateViewController(withIdentifier: "MyPlanStoryboard")
            
            viewController.modalPresentationStyle = .fullScreen
            
            // Present the viewController outside of the navigation controller so as not to carry on the tab bar controller.
            self.fadeOut { (success) in
                if success {
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
    }
    
    @IBAction func remindersButtonTapped(_ sender: Any) {
        WorkoutEditViewController.fromWorkoutMainViewController = true
        DispatchQueue.main.async {
            // Pull the Appropriate storyboard with the needed view controller.
            let storyboard = UIStoryboard(name: "HiitnessProfile", bundle: nil)
            // Set our viewController as the CreateWorkoutViewController.
            let viewController = storyboard.instantiateViewController(withIdentifier: "RemindersStoryboard")
            
            viewController.modalPresentationStyle = .fullScreen
            
            // Present the viewController outside of the navigation controller so as not to carry on the tab bar controller.
            self.fadeOut { (success) in
                if success {
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
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
        }
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
    
    func setupConstraints() {
        
        var titleFontSize: CGFloat = 0
        var titleHeightMultiplier: CGFloat = 0
        var backButtonLeadingConstant: CGFloat = 0
        var backButtonBottomConstant: CGFloat = 0
        var aboutYouButtonWidthConstant: CGFloat = 0
        var aboutYouButtonTopConstant: CGFloat = 0
        var numberOfExercisesLabelTopConstant: CGFloat = 0
        var numberOfCaloriesBurnedLabelTopConstant: CGFloat = 0
        var yourFitnessPlanButtonTopConstant: CGFloat = 0
        var remindersTopConstant: CGFloat = 0
        var aboutYouHeightMultiplier: CGFloat = 0
        var backButtonHeightMultiplier: CGFloat = 0
        
        switch (getiPhoneSize()) {
        case "small":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.7
            
            aboutYouButtonWidthConstant = 0.9
            aboutYouButtonTopConstant = 33
            
            numberOfExercisesLabelTopConstant = 22
            numberOfCaloriesBurnedLabelTopConstant = 22
            
            yourFitnessPlanButtonTopConstant = 17
            remindersTopConstant = 17
            
            aboutYouHeightMultiplier = 8
        case "medium":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            
            aboutYouButtonWidthConstant = 0.9
            aboutYouButtonTopConstant = 33
            
            numberOfExercisesLabelTopConstant = 22
            numberOfCaloriesBurnedLabelTopConstant = 22
            
            yourFitnessPlanButtonTopConstant = 22
            remindersTopConstant = 22
            
            aboutYouHeightMultiplier = 8
        case "large":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            
            aboutYouButtonWidthConstant = 0.9
            aboutYouButtonTopConstant = 66
            
            numberOfExercisesLabelTopConstant = 22
            numberOfCaloriesBurnedLabelTopConstant = 22
            
            yourFitnessPlanButtonTopConstant = 22
            remindersTopConstant = 22
            
            aboutYouHeightMultiplier = 9
        case "x":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            
            aboutYouButtonWidthConstant = 0.9
            aboutYouButtonTopConstant = 66
            
            numberOfExercisesLabelTopConstant = 22
            numberOfCaloriesBurnedLabelTopConstant = 22
            
            yourFitnessPlanButtonTopConstant = 22
            remindersTopConstant = 22
            
            aboutYouHeightMultiplier = 10
        case "r":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            
            aboutYouButtonWidthConstant = 0.9
            aboutYouButtonTopConstant = 66
            
            numberOfExercisesLabelTopConstant = 22
            numberOfCaloriesBurnedLabelTopConstant = 22
            
            yourFitnessPlanButtonTopConstant = 22
            remindersTopConstant = 22
            
            aboutYouHeightMultiplier = 10
        default:
            print("Something went wrong in getting the screen size")
        }
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        // This back button was added to help everything be consistent across the storyboards. It is only used for constraint purposes.
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.alpha = 0
        backButton.isEnabled = false
        
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.font = greetingLabel.font.withSize(titleFontSize)
        numberOfExercisesLabel.translatesAutoresizingMaskIntoConstraints = false
        exercisesCompletedLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfMinutesExercisedLabel.translatesAutoresizingMaskIntoConstraints = false
        minSpentExercisingLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfCaloriesBurnedLabel.translatesAutoresizingMaskIntoConstraints = false
        caloriesBurnedLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfExercisesThisWeekLabel.translatesAutoresizingMaskIntoConstraints = false
        exercisesThisWeakLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutYouButton.translatesAutoresizingMaskIntoConstraints = false
        yourFitnessPlanButton.translatesAutoresizingMaskIntoConstraints = false
        reminders.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: self.view.topAnchor),
            titleView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: titleHeightMultiplier),
            titleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: backButtonLeadingConstant),
            backButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: backButtonBottomConstant),
            backButton.heightAnchor.constraint(equalToConstant: titleView.frame.size.height * backButtonHeightMultiplier),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            greetingLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            greetingLabel.widthAnchor.constraint(equalTo: titleView.widthAnchor),
            greetingLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            aboutYouButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: aboutYouButtonWidthConstant),
            aboutYouButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            aboutYouButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/aboutYouHeightMultiplier),
            
            numberOfExercisesLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: numberOfExercisesLabelTopConstant),
            exercisesCompletedLabel.topAnchor.constraint(equalTo: numberOfExercisesLabel.bottomAnchor),
            numberOfCaloriesBurnedLabel.topAnchor.constraint(equalTo: exercisesCompletedLabel.bottomAnchor, constant: numberOfCaloriesBurnedLabelTopConstant),
            
            caloriesBurnedLabel.leadingAnchor.constraint(equalTo: aboutYouButton.leadingAnchor),
            caloriesBurnedLabel.topAnchor.constraint(equalTo: numberOfCaloriesBurnedLabel.bottomAnchor),
            caloriesBurnedLabel.widthAnchor.constraint(equalToConstant: caloriesBurnedLabel.intrinsicContentSize.width),
            caloriesBurnedLabel.heightAnchor.constraint(equalToConstant: caloriesBurnedLabel.intrinsicContentSize.height),
            
            numberOfCaloriesBurnedLabel.leadingAnchor.constraint(equalTo: caloriesBurnedLabel.leadingAnchor),
            numberOfCaloriesBurnedLabel.heightAnchor.constraint(equalToConstant: numberOfCaloriesBurnedLabel.intrinsicContentSize.height),
            numberOfCaloriesBurnedLabel.widthAnchor.constraint(equalToConstant: numberOfCaloriesBurnedLabel.intrinsicContentSize.width),
            
            exercisesCompletedLabel.leadingAnchor.constraint(equalTo: numberOfCaloriesBurnedLabel.leadingAnchor),
            exercisesCompletedLabel.heightAnchor.constraint(equalToConstant: exercisesCompletedLabel.intrinsicContentSize.height),
            exercisesCompletedLabel.widthAnchor.constraint(equalToConstant: exercisesCompletedLabel.intrinsicContentSize.width),
            
            numberOfExercisesLabel.leadingAnchor.constraint(equalTo: exercisesCompletedLabel.leadingAnchor),
            numberOfExercisesLabel.heightAnchor.constraint(equalToConstant: numberOfExercisesLabel.intrinsicContentSize.height),
            numberOfExercisesLabel.widthAnchor.constraint(equalToConstant: numberOfExercisesLabel.intrinsicContentSize.width),
            
            aboutYouButton.topAnchor.constraint(equalTo: caloriesBurnedLabel.bottomAnchor, constant: aboutYouButtonTopConstant),
            
            minSpentExercisingLabel.trailingAnchor.constraint(equalTo: aboutYouButton.trailingAnchor),
            minSpentExercisingLabel.widthAnchor.constraint(equalToConstant: minSpentExercisingLabel.intrinsicContentSize.width),
            minSpentExercisingLabel.heightAnchor.constraint(equalToConstant: minSpentExercisingLabel.intrinsicContentSize.height),
            minSpentExercisingLabel.centerYAnchor.constraint(equalTo: exercisesCompletedLabel.centerYAnchor),
            
            numberOfMinutesExercisedLabel.leadingAnchor.constraint(equalTo: minSpentExercisingLabel.leadingAnchor),
            numberOfMinutesExercisedLabel.heightAnchor.constraint(equalToConstant: numberOfMinutesExercisedLabel.intrinsicContentSize.height),
            numberOfMinutesExercisedLabel.widthAnchor.constraint(equalToConstant: numberOfMinutesExercisedLabel.intrinsicContentSize.width),
            numberOfMinutesExercisedLabel.centerYAnchor.constraint(equalTo: numberOfExercisesLabel.centerYAnchor),
            
            exercisesThisWeakLabel.leadingAnchor.constraint(equalTo: minSpentExercisingLabel.leadingAnchor),
            exercisesThisWeakLabel.widthAnchor.constraint(equalToConstant: exercisesThisWeakLabel.intrinsicContentSize.width),
            exercisesThisWeakLabel.heightAnchor.constraint(equalToConstant: exercisesThisWeakLabel.intrinsicContentSize.height),
            exercisesThisWeakLabel.centerYAnchor.constraint(equalTo: caloriesBurnedLabel.centerYAnchor),
            
            numberOfExercisesThisWeekLabel.leadingAnchor.constraint(equalTo: exercisesThisWeakLabel.leadingAnchor),
            numberOfExercisesThisWeekLabel.heightAnchor.constraint(equalToConstant: numberOfExercisesThisWeekLabel.intrinsicContentSize.height),
            numberOfExercisesThisWeekLabel.widthAnchor.constraint(equalToConstant: numberOfExercisesThisWeekLabel.intrinsicContentSize.width),
            numberOfExercisesThisWeekLabel.centerYAnchor.constraint(equalTo: numberOfCaloriesBurnedLabel.centerYAnchor),
            
            yourFitnessPlanButton.topAnchor.constraint(equalTo: aboutYouButton.bottomAnchor, constant: yourFitnessPlanButtonTopConstant),
            yourFitnessPlanButton.heightAnchor.constraint(equalTo: aboutYouButton.heightAnchor),
            yourFitnessPlanButton.widthAnchor.constraint(equalTo: aboutYouButton.widthAnchor),
            yourFitnessPlanButton.centerXAnchor.constraint(equalTo: aboutYouButton.centerXAnchor),
            
            reminders.topAnchor.constraint(equalTo: yourFitnessPlanButton.bottomAnchor, constant: remindersTopConstant),
            reminders.heightAnchor.constraint(equalTo: aboutYouButton.heightAnchor),
            reminders.widthAnchor.constraint(equalTo: aboutYouButton.widthAnchor),
            reminders.centerXAnchor.constraint(equalTo: aboutYouButton.centerXAnchor)
        ])
    }
}
