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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var workoutCompleteImageView: UIImageView!
    @IBOutlet weak var calorieImage: UIImageView!
    @IBOutlet weak var calorieCount: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var workoutMinutesLabel: UILabel!
    @IBOutlet weak var heartRateImageView: UIImageView!
    @IBOutlet weak var averageHeartRate: UILabel!
    @IBOutlet weak var averageHeartRateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var darkOverlayView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var alertReturnButton: UIButton!
    
    let profile = ProfileController.sharedInstance.profile
    
    // Variable - Time placeholder.
    var time: Double = 0
    var workouts: Workouts = WorkoutsController.sharedInstance.totalWorkouts[WorkoutMainViewController.lastSelectedIndex]
    var completedWorkout: CompletedWorkout?
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        darkOverlayView.isHidden = true
        alertView.isHidden = true
        //Set the title view's gradient and shadows.
        titleView.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        titleView.layer.masksToBounds = false
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        saveButton.layer.cornerRadius = saveButton.frame.height/3
        // Set the total time from the WorkoutTimerViewController
        if completedWorkout == nil {
            time = WorkoutTimerViewController.totalTime
            // Set the minutes and seconds strings for the total time.
            let minutesString = "\( Int(time / 60) )"
            let secondsString = "\(Int(time.truncatingRemainder(dividingBy: 60.0)))"
        
            totalTime.text = minutesString + ":" + secondsString
        } else {
            guard let time = completedWorkout?.time else {return}
            totalTime.text = time
        }
        
        // Reset the totalTime for the next workout.
        WorkoutTimerViewController.totalTime = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialFade()
        print("What")
        WorkoutMainViewController.fromWorkoutCompleted = true
        if completedWorkout == nil {
            saveButton.setTitle("Save", for: .normal)
            backButton.isHidden = false
            backButton.isEnabled = true
            averageHeartRate.text = "\(HealthKitController.sharedInstance.averageHeartRate)"
            let minutes = time/60
            let calories = HealthKitController.sharedInstance.getCaloriesBurned(durationOfWorkoutInMinutes: minutes)
            let calorieDisplay = Double(Int(calories*100))/100
            calorieCount.text = "\(calorieDisplay)"
        } else {
            saveButton.setTitle("Back", for: .normal)
            backButton.isHidden = true
            backButton.isEnabled = false
            guard let heartRate = completedWorkout?.heartRate, let calorie = completedWorkout?.calories else {return}
            averageHeartRate.text = heartRate
            calorieCount.text = calorie
        }
        self.viewDidAppear(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        print("The")
        DispatchQueue.main.async {
            self.fadeIn()
        }
    }
    
    // Dismiss the current view controller and it's parent view controller.
    @IBAction func backButtonTapped(_ sender: Any) {
        backButton.isEnabled = false
        saveButton.isEnabled = false
        darkOverlayView.isHidden = false
        alertView.isHidden = false
    }
    
    @IBAction func alertDiscardButtonTapped(_ sender: Any) {
        fadeOut { (success) in
            if success {
                WorkoutMainViewController.fromWorkoutCompleted = true
                self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func alertSaveButtonTapped(_ sender: Any) {
        guard let profile = profile else {return}
        guard let calorie = calorieCount.text else {return}
        guard let calorieDouble = Double(calorie) else {return}
        let completedName = workouts.name
        guard let completedCal = calorieCount?.text else {return}
        guard let completedTime = workoutMinutesLabel?.text else {return}
        guard let completedHeartRate = averageHeartRate?.text else {return}
        let minutes = Double(Int(time*100/60))/100
        ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: [Exercises(exercise: 1, daysElapsed: 0, dateOfCreation: Date())], completedExercises: 1, totalTimeExercising: minutes, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: [HeartRate(heartRate: HealthKitController.sharedInstance.averageHeartRate, daysElapsed: 0, dateOfCreation: Date())], caloriesBurnedThisWeek: [Calories(calorieCount: calorieDouble, daysElapsed: 0, dateOfCreation: Date())])
        CompletedWorkoutsController.sharedInstance.createCompletedWorkout(name: completedName, calories: completedCal, time: completedTime, heartRate: completedHeartRate)
        fadeOut { (success) in
            if success {
                WorkoutMainViewController.fromWorkoutCompleted = true
                self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func alertReturnButtonTapped(_ sender: Any) {
        backButton.isEnabled = true
        saveButton.isEnabled = true
        darkOverlayView.isHidden = true
        alertView.isHidden = true
    }
    
    // Dismiss the current view controller and it's parent view controller.
    // TODO: - Make saving do something.
    @IBAction func saveButtonTapped(_ sender: Any) {
        if completedWorkout == nil {
            guard let profile = profile else {return}
            guard let calorie = calorieCount.text else {return}
            guard let calorieDouble = Double(calorie) else {return}
            let completedName = workouts.name
            guard let completedCal = calorieCount?.text else {return}
            guard let completedTime = totalTime?.text else {return}
            guard let completedHeartRate = averageHeartRate?.text else {return}
            let minutes = Double(Int(time*100/60))/100
            ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: [Exercises(exercise: 1, daysElapsed: 0, dateOfCreation: Date())], completedExercises: 1, totalTimeExercising: minutes, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: [HeartRate(heartRate: HealthKitController.sharedInstance.averageHeartRate, daysElapsed: 0, dateOfCreation: Date())], caloriesBurnedThisWeek: [Calories(calorieCount: calorieDouble, daysElapsed: 0, dateOfCreation: Date())])
            CompletedWorkoutsController.sharedInstance.createCompletedWorkout(name: completedName, calories: completedCal, time: completedTime, heartRate: completedHeartRate)
            fadeOut { (success) in
                if success {
                    WorkoutMainViewController.fromWorkoutCompleted = true
                    self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                }
            }
        } else {
            fadeOut { (success) in
                if success {
                    self.presentingViewController?.dismiss(animated: false, completion: nil)
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
        var backButtonHeightMultiplier: CGFloat = 0
        var titleLabelWidthMultiplier: CGFloat = 0
        
        switch (getiPhoneSize()) {
        case "small":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 9
            backButtonHeightMultiplier = 0.7
            
            titleLabelWidthMultiplier = 0.9
        case "medium":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.71
            
            titleLabelWidthMultiplier = 0.9
        case "large":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.72
            
            titleLabelWidthMultiplier = 0.9
        case "x":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.74
            
            titleLabelWidthMultiplier = 0.9
        case "r":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9
        default:
            print("Something went wrong getting iphone screen size")
        }
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleLabel.font.withSize(titleFontSize)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        workoutCompleteImageView.translatesAutoresizingMaskIntoConstraints = false
        
        calorieImage.translatesAutoresizingMaskIntoConstraints = false
        calorieCount.translatesAutoresizingMaskIntoConstraints = false
        calorieCount.textAlignment = .right
        calorieLabel.translatesAutoresizingMaskIntoConstraints = false
        calorieLabel.textAlignment = .right
        
        timeImageView.translatesAutoresizingMaskIntoConstraints = false
        totalTime.translatesAutoresizingMaskIntoConstraints = false
        totalTime.textAlignment = .right
        workoutMinutesLabel.translatesAutoresizingMaskIntoConstraints = false
        workoutMinutesLabel.textAlignment = .right
        
        heartRateImageView.translatesAutoresizingMaskIntoConstraints = false
        averageHeartRate.translatesAutoresizingMaskIntoConstraints = false
        averageHeartRate.textAlignment = .right
        averageHeartRateLabel.translatesAutoresizingMaskIntoConstraints = false
        averageHeartRateLabel.textAlignment = .right
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        darkOverlayView.translatesAutoresizingMaskIntoConstraints = false
        darkOverlayView.layer.backgroundColor = UIColor.black.cgColor
        darkOverlayView.alpha = 0.8
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.layer.borderColor = UIColor.black.cgColor
        alertView.layer.borderWidth = 0.33
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        borderView.layer.borderWidth = 3
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.font = alertLabel.font.withSize(22)
        
        quitButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.layer.cornerRadius = quitButton.frame.height/2
        quitButton.layer.borderColor = UIColor.getHIITPrimaryBlue.cgColor
        quitButton.layer.borderWidth = 3
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.layer.cornerRadius = continueButton.frame.height/2
        continueButton.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        continueButton.layer.borderWidth = 3
        
        alertReturnButton.translatesAutoresizingMaskIntoConstraints = false
        alertReturnButton.layer.cornerRadius = alertReturnButton.frame.height/2
        
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
            
            workoutCompleteImageView.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 0.75),
            workoutCompleteImageView.heightAnchor.constraint(equalTo: workoutCompleteImageView.widthAnchor),
            workoutCompleteImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            workoutCompleteImageView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            
            calorieImage.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 0.2),
            calorieImage.leadingAnchor.constraint(equalTo: workoutCompleteImageView.leadingAnchor, constant: 11),
            calorieImage.heightAnchor.constraint(equalTo: calorieImage.widthAnchor),
            calorieImage.topAnchor.constraint(equalTo: workoutCompleteImageView.bottomAnchor, constant: 11),
            
            calorieCount.topAnchor.constraint(equalTo: calorieImage.topAnchor, constant: 6),
            calorieCount.heightAnchor.constraint(equalTo: calorieImage.heightAnchor, multiplier: 0.5),
            calorieCount.trailingAnchor.constraint(equalTo: workoutCompleteImageView.trailingAnchor, constant: -11),
            calorieCount.leadingAnchor.constraint(equalTo: calorieImage.trailingAnchor, constant: 11),
            
            calorieLabel.bottomAnchor.constraint(equalTo: calorieImage.bottomAnchor, constant: -6),
            calorieLabel.widthAnchor.constraint(equalTo: calorieCount.widthAnchor),
            calorieLabel.trailingAnchor.constraint(equalTo: workoutCompleteImageView.trailingAnchor, constant: -11),
            calorieLabel.heightAnchor.constraint(equalTo: calorieImage.heightAnchor, multiplier: 0.25),
            
            timeImageView.widthAnchor.constraint(equalTo: calorieImage.widthAnchor),
            timeImageView.leadingAnchor.constraint(equalTo: workoutCompleteImageView.leadingAnchor, constant: 11),
            timeImageView.heightAnchor.constraint(equalTo: timeImageView.widthAnchor),
            timeImageView.topAnchor.constraint(equalTo: calorieImage.bottomAnchor, constant: 11),
            
            totalTime.topAnchor.constraint(equalTo: timeImageView.topAnchor, constant: 6),
            totalTime.heightAnchor.constraint(equalTo: timeImageView.heightAnchor, multiplier: 0.5),
            totalTime.trailingAnchor.constraint(equalTo: workoutCompleteImageView.trailingAnchor, constant: -11),
            totalTime.leadingAnchor.constraint(equalTo: timeImageView.trailingAnchor, constant: 11),
            
            workoutMinutesLabel.bottomAnchor.constraint(equalTo: timeImageView.bottomAnchor, constant: -6),
            workoutMinutesLabel.widthAnchor.constraint(equalTo: totalTime.widthAnchor),
            workoutMinutesLabel.trailingAnchor.constraint(equalTo: workoutCompleteImageView.trailingAnchor, constant: -11),
            workoutMinutesLabel.heightAnchor.constraint(equalTo: timeImageView.heightAnchor, multiplier: 0.25),
            
            heartRateImageView.widthAnchor.constraint(equalTo: timeImageView.widthAnchor),
            heartRateImageView.leadingAnchor.constraint(equalTo: workoutCompleteImageView.leadingAnchor, constant: 11),
            heartRateImageView.heightAnchor.constraint(equalTo: heartRateImageView.widthAnchor),
            heartRateImageView.topAnchor.constraint(equalTo: timeImageView.bottomAnchor, constant: 11),
            
            averageHeartRate.topAnchor.constraint(equalTo: heartRateImageView.topAnchor, constant: 6),
            averageHeartRate.heightAnchor.constraint(equalTo: heartRateImageView.heightAnchor, multiplier: 0.5),
            averageHeartRate.trailingAnchor.constraint(equalTo: workoutCompleteImageView.trailingAnchor, constant: -11),
            averageHeartRate.leadingAnchor.constraint(equalTo: heartRateImageView.trailingAnchor, constant: 11),
            
            averageHeartRateLabel.bottomAnchor.constraint(equalTo: heartRateImageView.bottomAnchor, constant: -6),
            averageHeartRateLabel.widthAnchor.constraint(equalTo: averageHeartRate.widthAnchor),
            averageHeartRateLabel.trailingAnchor.constraint(equalTo: workoutCompleteImageView.trailingAnchor, constant: -11),
            averageHeartRateLabel.heightAnchor.constraint(equalTo: heartRateImageView.heightAnchor, multiplier: 0.25),
            
            saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: heartRateImageView.bottomAnchor, constant: 11),
            saveButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            
            darkOverlayView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            darkOverlayView.topAnchor.constraint(equalTo: self.view.topAnchor),
            darkOverlayView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            darkOverlayView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            alertView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            alertView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.28),
            
            borderView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 6),
            borderView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -6),
            borderView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 6),
            borderView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -6),
            
            alertLabel.widthAnchor.constraint(equalTo: alertView.widthAnchor, multiplier: 0.8),
            alertLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 6),
            alertLabel.heightAnchor.constraint(equalTo: alertView.heightAnchor, multiplier: 1/2),
            alertLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            
            alertReturnButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            alertReturnButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -16),
            alertReturnButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),
            alertReturnButton.heightAnchor.constraint(equalTo: alertView.heightAnchor, multiplier: 0.2),
            
            quitButton.widthAnchor.constraint(equalTo: alertView.widthAnchor, multiplier: 0.43),
            quitButton.bottomAnchor.constraint(equalTo: alertReturnButton.topAnchor, constant: -5),
            quitButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            quitButton.heightAnchor.constraint(equalTo: alertView.heightAnchor, multiplier: 0.2),
            
            continueButton.widthAnchor.constraint(equalTo: alertView.widthAnchor, multiplier: 0.43),
            continueButton.bottomAnchor.constraint(equalTo: alertReturnButton.topAnchor, constant: -5),
            continueButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalTo: alertView.heightAnchor, multiplier: 0.2),
        ])
    }
}
