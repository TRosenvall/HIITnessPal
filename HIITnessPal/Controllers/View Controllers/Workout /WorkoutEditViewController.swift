//
//  WorkoutEditViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class WorkoutEditViewController: UIViewController {
    
    // Set IBOutlets
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var workoutTitleLabel: UILabel!
    @IBOutlet weak var workoutTitleTextField: UITextField!
    @IBOutlet weak var workoutTableView: UITableView!
    @IBOutlet weak var workoutCyclesLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var multiplierLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var totalWorkoutTime: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    // Variables
    var workouts: Workouts? // Workout Landing Pad.
    var timeTotal: Int = 0
    var workoutSegue: Workout?
    let exerciseList = ExerciseController.sharedInstance.workouts
    let existingWorkouts: [Workout] = []
    var exercises: [Workout] = []
    var fromSelectWorkoutViewController: Bool = false
    static var fromWorkoutMainViewController: Bool = false
    static var workoutTitle: String = ""
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        
        if WorkoutEditViewController.fromWorkoutMainViewController == true {
            workouts =  WorkoutsController.sharedInstance.totalWorkouts[WorkoutMainViewController.selectedIndex]
            WorkoutEditViewController.fromWorkoutMainViewController = false
        }
        
        if fromSelectWorkoutViewController == true {
            
            populateExercises()
            workouts = Workouts(name: "", multiplier: 1, workouts: self.exercises)
            multiplierLabel.text = "x1"
        } else {
            // Unwrap the passed in workout from the landing pad.
            guard let workout = workouts else {return}
            multiplierLabel.text = "x\(workout.multiplier)"
        }
        
        // Set the titleView's gradient and shadows.
        titleView.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        titleView.layer.masksToBounds = false
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        // Set the title based on the passed in workout.
        workoutTitleTextField.text = workouts?.name
        workoutTitleTextField.delegate = self
        // Set the multiplier border constraints and label.
        multiplierLabel.layer.cornerRadius = multiplierLabel.frame.height/2
        multiplierLabel.layer.borderColor = UIColor.getHIITBlack.cgColor
        multiplierLabel.layer.borderWidth = 1
        
        // Round the save button's corners.
        saveButton.layer.cornerRadius = saveButton.frame.height/2
        if workoutTitleTextField.text == "" {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.getHIITGray
        }
        titleView.alpha = 1
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        workoutTableView.reloadData()
        titleView.alpha = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Call the function to set the total time.
        setTotalTime()
        initialFade()
        if fromSelectWorkoutViewController {
            workoutTitleTextField.text = WorkoutEditViewController.workoutTitle
        }
        DispatchQueue.main.async {
            self.titleView.alpha = 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.titleView.alpha = 1
        }
        fadeIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // Dismiss the viewController when the back button tapped.
    @IBAction func backButtonTapped(_ sender: Any) {
        if fromSelectWorkoutViewController {
            guard let workoutTitleFromTextField = workoutTitleTextField.text else {return}
            WorkoutEditViewController.workoutTitle = workoutTitleFromTextField
            SelectWorkoutViewController.fromWorkoutEditViewController = true
        }
        fadeOut { (success) in
            if success {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    // Lower the multiplier and reset the total time displayed.
    @IBAction func multiplierSubtractButtonTapped(_ sender: Any) {
        if workouts!.multiplier > 1 {
            workouts?.multiplier -= 1
        }
        if let multiplier = workouts?.multiplier {
            multiplierLabel.text = "x\(multiplier)"
        }
        setTotalTime()
    }
    
    // Raise the multiplier and reset the total time displayed.
    @IBAction func multiplierAddButtonTapped(_ sender: Any) {
        workouts?.multiplier += 1
        if let multiplier = workouts?.multiplier {
            multiplierLabel.text = "x\(multiplier)"
        }
        setTotalTime()
    }
    
    // If the save button is tapped
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Unwrap all if the text fields.
        guard let workouts = workouts else {return}
        guard let title = workoutTitleTextField.text else {return}
        guard var multiplierText = multiplierLabel.text else {return}
        guard let index = multiplierText.firstIndex(of: "x") else {return}
        multiplierText.remove(at: index)
        guard let multiplier = Int(multiplierText) else {return}
        // Update a workout using the unwrapped text fields.
        if fromSelectWorkoutViewController == false {
            WorkoutsController.sharedInstance.updateWorkout(workout: workouts, name: title, workouts: workouts.workouts, multiplier: multiplier)
            // Dismiss the view controllers back to the tabBarController.
            fadeOut { (success) in
                if success {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        } else {
            SelectWorkoutViewController.selected = []
            WorkoutEditViewController.workoutTitle = ""
            WorkoutsController.sharedInstance.createWorkout(name: title, workouts: workouts.workouts, multiplier: multiplier)
            fromSelectWorkoutViewController = false
            fadeOut { (success) in
                if success {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    // Function to set the total time.
    func setTotalTime() {
        // Setup variables
        var tempTimeTotal: Int = 0
        
        // Unwrap the workouts from the landing pad.
        if let workouts = workouts?.workouts {
            // Total the time for all the variables in the given workout.
            for workout in workouts {
                tempTimeTotal += workout.duration + workout.rest
            }
        }
        
        // Reset the totalTime to the appropriate sum from above.
        if timeTotal != tempTimeTotal {
            timeTotal = tempTimeTotal
            tempTimeTotal = 0
        }
        
        // Unwrap the workouts more permanently.
        guard let workouts = workouts else {return}
        // Factor in the workout's multiplier.
        timeTotal *= workouts.multiplier
        
        // Set the minutes and seconds from the total time.
        let minutes = timeTotal / 60
        let seconds = timeTotal % 60
        
        // Establish a placeholder label for the minutes and seconds.
        var minutesLabel = ""
        var secondsLabel = ""
        
        // Handle errors if both minutes and seconds are less than 10.
        if minutes < 10 {
            minutesLabel = "0\(minutes)"
        } else {
            minutesLabel = "\(minutes)"
        }
        
        if seconds < 10 {
            secondsLabel = "0\(seconds)"
        } else {
            secondsLabel = "\(seconds)"
        }
        
        // Fill in the totalTimeLabel.
        totalTimeLabel.text = minutesLabel + ":" + secondsLabel
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
        var workoutTitleTextFieldTopConstant: CGFloat = 0
        var saveButtonBottomConstant: CGFloat = 0
        var saveButtonWidthMultiplier: CGFloat = 0
        var totalWorkoutTimeBottomConstant: CGFloat = 0
        var totalWorkoutTimeTrailingConstant: CGFloat = 0
        var workoutCyclesLabelLeadingConstant: CGFloat = 0
        var multiplierLabelBottomConstant: CGFloat = 0
        var workoutTableViewBottomConstant: CGFloat = 0
        var workoutTitleViewTopConstant: CGFloat = 0
        
        switch (getiPhoneSize()) {
        case "small":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.7
            
            titleLabelWidthMultiplier = 0.9
            
            workoutTitleTextFieldTopConstant = 11
            
            saveButtonBottomConstant = -22
            saveButtonWidthMultiplier = 0.5
            
            totalWorkoutTimeBottomConstant = -6
            
            totalWorkoutTimeTrailingConstant = -33
            
            workoutCyclesLabelLeadingConstant = 33
            
            multiplierLabelBottomConstant = -6

            workoutTableViewBottomConstant = -6
            workoutTitleViewTopConstant = 6
            
        case "medium":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9
            
            workoutTitleTextFieldTopConstant = 11
            
            saveButtonBottomConstant = -22
            saveButtonWidthMultiplier = 0.5
            
            totalWorkoutTimeBottomConstant = -6
            
            totalWorkoutTimeTrailingConstant = -22
            
            workoutCyclesLabelLeadingConstant = 22
            
            multiplierLabelBottomConstant = -6

            workoutTableViewBottomConstant = -6
            workoutTitleViewTopConstant = 6
            
        case "large":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9

            workoutTitleTextFieldTopConstant = 11
            
            saveButtonBottomConstant = -22
            saveButtonWidthMultiplier = 0.5
            
            totalWorkoutTimeBottomConstant = -6
            
            totalWorkoutTimeTrailingConstant = -22
            
            workoutCyclesLabelLeadingConstant = 22
            
            multiplierLabelBottomConstant = -6

            workoutTableViewBottomConstant = -6
            workoutTitleViewTopConstant = 6
            
        case "x":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9

            workoutTitleTextFieldTopConstant = 11
            
            saveButtonBottomConstant = -22
            saveButtonWidthMultiplier = 0.5
            
            totalWorkoutTimeBottomConstant = -6
            
            totalWorkoutTimeTrailingConstant = -22
            
            workoutCyclesLabelLeadingConstant = 22
            
            multiplierLabelBottomConstant = -6
            
            workoutTableViewBottomConstant = -6
            workoutTitleViewTopConstant = 6
            
        case "r":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9

            workoutTitleTextFieldTopConstant = 11
            
            saveButtonBottomConstant = -22
            saveButtonWidthMultiplier = 0.5
            
            totalWorkoutTimeBottomConstant = -6
            
            totalWorkoutTimeTrailingConstant = -22
            
            workoutCyclesLabelLeadingConstant = 22
            
            multiplierLabelBottomConstant = -6
            
            workoutTableViewBottomConstant = -6
            workoutTitleViewTopConstant = 6
        default:
            print("Something went wrong getting iphone screen size")
        }
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleLabel.font.withSize(titleFontSize)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        workoutTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        workoutTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        totalWorkoutTime.translatesAutoresizingMaskIntoConstraints = false
        workoutCyclesLabel.translatesAutoresizingMaskIntoConstraints = false
        workoutCyclesLabel.font = workoutCyclesLabel.font.withSize(totalWorkoutTime.intrinsicContentSize.height)
        multiplierLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        workoutTableView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.isHidden = true
        
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
            
            workoutTitleTextField.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: workoutTitleTextFieldTopConstant),
            workoutTitleTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            workoutTitleLabel.centerYAnchor.constraint(equalTo: workoutTitleTextField.centerYAnchor),
            workoutTitleLabel.heightAnchor.constraint(equalToConstant: workoutTitleLabel.intrinsicContentSize.height),
            workoutTitleLabel.widthAnchor.constraint(equalToConstant: workoutTitleLabel.intrinsicContentSize.width),
            workoutTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            workoutTitleTextField.leadingAnchor.constraint(equalTo: workoutTitleLabel.trailingAnchor),
            workoutTitleTextField.heightAnchor.constraint(equalTo: workoutTitleLabel.heightAnchor),

            saveButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: saveButtonBottomConstant),
            saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: saveButtonWidthMultiplier),
            
            totalWorkoutTime.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: totalWorkoutTimeBottomConstant),
            totalWorkoutTime.heightAnchor.constraint(equalToConstant: totalWorkoutTime.intrinsicContentSize.height),
            totalWorkoutTime.widthAnchor.constraint(equalToConstant: totalWorkoutTime.intrinsicContentSize.width),
            totalWorkoutTime.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: totalWorkoutTimeTrailingConstant),
            
            workoutCyclesLabel.bottomAnchor.constraint(equalTo: totalWorkoutTime.bottomAnchor),
            workoutCyclesLabel.heightAnchor.constraint(equalTo: totalWorkoutTime.heightAnchor),
            workoutCyclesLabel.widthAnchor.constraint(equalToConstant: workoutCyclesLabel.intrinsicContentSize.width),
            workoutCyclesLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: workoutCyclesLabelLeadingConstant),
            
            multiplierLabel.centerXAnchor.constraint(equalTo: workoutCyclesLabel.centerXAnchor),
            multiplierLabel.heightAnchor.constraint(equalToConstant: multiplierLabel.intrinsicContentSize.height),
            multiplierLabel.widthAnchor.constraint(equalToConstant: multiplierLabel.intrinsicContentSize.width + 16),
            multiplierLabel.bottomAnchor.constraint(equalTo: workoutCyclesLabel.topAnchor, constant: multiplierLabelBottomConstant),
            
            addButton.centerYAnchor.constraint(equalTo: multiplierLabel.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: addButton.intrinsicContentSize.width + 8),
            addButton.heightAnchor.constraint(equalToConstant: addButton.intrinsicContentSize.height),
            addButton.leadingAnchor.constraint(equalTo: multiplierLabel.trailingAnchor),
            
            minusButton.centerYAnchor.constraint(equalTo: multiplierLabel.centerYAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: minusButton.intrinsicContentSize.width + 8),
            minusButton.heightAnchor.constraint(equalToConstant: minusButton.intrinsicContentSize.height),
            minusButton.trailingAnchor.constraint(equalTo: multiplierLabel.leadingAnchor),
            
            totalTimeLabel.centerXAnchor.constraint(equalTo: totalWorkoutTime.centerXAnchor),
            totalTimeLabel.heightAnchor.constraint(equalTo: multiplierLabel.heightAnchor),
            totalTimeLabel.widthAnchor.constraint(equalToConstant: totalTimeLabel.intrinsicContentSize.width),
            totalTimeLabel.bottomAnchor.constraint(equalTo: multiplierLabel.bottomAnchor),
            
            workoutTableView.bottomAnchor.constraint(equalTo: multiplierLabel.topAnchor, constant: workoutTableViewBottomConstant),
            workoutTableView.topAnchor.constraint(equalTo: workoutTitleLabel.bottomAnchor, constant: workoutTitleViewTopConstant),
            workoutTableView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            workoutTableView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
        
        titleView.alpha = 1
    }
    
    // Function used to fill out the exercises variable above.
    func populateExercises() {
        // Set the exercises from the selected list in the SelectWorkoutViewController.
        let list: [Int] = SelectWorkoutViewController.selected
        // Pull each integer from the list and compare it to the exercise list to get the right exercises. Set those to the correct exercises.
        for x in list {
            let workout = exerciseList[x]
            exercises.append(workout)
        }
        titleView.alpha = 1
    }
}

extension WorkoutEditViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The tableview will only ever have four rows.
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Unwrap the appropriate type of cell declared as a CreateWorkoutTableViewCell.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutEditCell", for: indexPath) as? WorkoutEditTableViewCell else {return UITableViewCell()}
        // Pull out the correct workouts from the indexPath.
        if workoutSegue == nil {
            let workout = workouts?.workouts[indexPath.row]
            // Select the correct workout for the cell.
            cell.workout = workout
            
            // Display the correct image and name.
            if let workout = workout {
                cell.workoutImageView.image = UIImage(named: "\(workout.image)0")
                print("\(workout.image)0")
                cell.workoutTitle.text = workout.name
            }
            
            // Display the correct times for the workout.
            if let duration = workout?.duration {
                let minutes = duration / 60
                let seconds = duration % 60
                cell.workoutTimeLabel.text = "\(minutes):\(seconds)"
            }
            
            // Display the correct times for the rest.
            if let rest = workout?.rest {
                let minutes = rest / 60
                let seconds = rest % 60
                cell.restTimeLabel.text = "\(minutes):\(seconds)"
            }
            
            //self.timeTotal += cell.totalTimeInCell()
            if indexPath.row == indexPath.count - 1 {
                setTotalTime()
            }
        } else if let workout = workoutSegue {
            // Select the correct workout for the cell.
            cell.workout = workout
            
            // Display the correct image and name.
            cell.workoutImageView.image = UIImage(named: "\(workout.image)0")
            print("\(workout.image)0")
            cell.workoutTitle.text = workout.name
            
            // Display the correct times for the workout.
            let duration = workout.duration
            let minutes = duration / 60
            let seconds = duration % 60
            cell.workoutTimeLabel.text = "\(minutes):\(seconds)"
            
            // Display the correct times for the rest.
            let rest = workout.rest
            let restMinutes = rest / 60
            let restSeconds = rest % 60
            cell.restTimeLabel.text = "\(restMinutes):\(restSeconds)"
            
            //self.timeTotal += cell.totalTimeInCell()
            if indexPath.row == indexPath.count - 1 {
                setTotalTime()
            }
        }
        
        // Set the correct layer constraints for the workout part of the cell.
        //cell.workoutView.layer.cornerRadius = cell.workoutView.frame.height/2
        cell.workoutView.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        cell.workoutView.layer.borderWidth = 3
        
        // Set the correct layer constraints for the rest part of the cell.
        cell.restView.layer.cornerRadius = cell.restView.frame.height/2
        cell.restView.layer.borderColor = UIColor.getHIITPrimaryBlue.cgColor
        cell.restView.layer.borderWidth = 3
        
        cell.workoutView.translatesAutoresizingMaskIntoConstraints = false
        cell.restView.translatesAutoresizingMaskIntoConstraints = false
        cell.workoutImageView.translatesAutoresizingMaskIntoConstraints = false
        cell.restImageView.translatesAutoresizingMaskIntoConstraints = false
        cell.workoutTitle.translatesAutoresizingMaskIntoConstraints = false
        cell.restTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.workoutSubtractionButton.translatesAutoresizingMaskIntoConstraints = false
        cell.workoutTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.workoutTimeLabel.textAlignment = .center
        cell.workoutAdditionButton.translatesAutoresizingMaskIntoConstraints = false
        cell.restSubtractionButton.translatesAutoresizingMaskIntoConstraints = false
        cell.restTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.restTimeLabel.textAlignment = .center
        cell.restAdditionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cell.workoutView.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 26/56),
            cell.workoutView.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            cell.workoutView.centerXAnchor.constraint(equalTo: workoutTableView.centerXAnchor),
            cell.workoutView.topAnchor.constraint(equalTo: cell.topAnchor, constant: cell.frame.height * 1/56),
        
            cell.restView.widthAnchor.constraint(equalTo: cell.workoutView.widthAnchor),
            cell.restView.heightAnchor.constraint(equalTo: cell.workoutView.heightAnchor),
            cell.restView.centerXAnchor.constraint(equalTo: cell.workoutView.centerXAnchor),
            cell.restView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -cell.frame.height * 1/56),
            
            cell.workoutImageView.heightAnchor.constraint(equalTo: cell.workoutView.heightAnchor, multiplier: 3/4),
            cell.workoutImageView.leadingAnchor.constraint(equalTo: cell.workoutView.leadingAnchor, constant: cell.workoutView.frame.height/3),
            cell.workoutImageView.centerYAnchor.constraint(equalTo: cell.workoutView.centerYAnchor),
            cell.workoutImageView.widthAnchor.constraint(equalTo: cell.workoutImageView.heightAnchor),
            
            cell.restImageView.heightAnchor.constraint(equalTo: cell.restView.heightAnchor, multiplier: 3/4),
            cell.restImageView.leadingAnchor.constraint(equalTo: cell.restView.leadingAnchor, constant: cell.restView.frame.height/3),
            cell.restImageView.centerYAnchor.constraint(equalTo: cell.restView.centerYAnchor),
            cell.restImageView.widthAnchor.constraint(equalTo: cell.restImageView.heightAnchor),
            
            cell.workoutTitle.centerXAnchor.constraint(equalTo: cell.workoutView.centerXAnchor, constant: -cell.workoutView.frame.width/7),
            cell.workoutTitle.heightAnchor.constraint(equalTo: cell.workoutImageView.heightAnchor),
            cell.workoutTitle.centerYAnchor.constraint(equalTo: cell.workoutImageView.centerYAnchor),
            cell.workoutTitle.widthAnchor.constraint(equalToConstant: cell.workoutTitle.intrinsicContentSize.width),
            
            cell.restTitleLabel.centerXAnchor.constraint(equalTo: cell.restView.centerXAnchor, constant: -cell.restView.frame.width/7),
            cell.restTitleLabel.heightAnchor.constraint(equalTo: cell.restImageView.heightAnchor),
            cell.restTitleLabel.centerYAnchor.constraint(equalTo: cell.restImageView.centerYAnchor),
            cell.restTitleLabel.widthAnchor.constraint(equalToConstant: cell.workoutTitle.intrinsicContentSize.width),
            
            cell.workoutAdditionButton.trailingAnchor.constraint(equalTo: cell.workoutView.trailingAnchor, constant: -cell.workoutView.frame.height/3),
            cell.workoutAdditionButton.centerYAnchor.constraint(equalTo: cell.workoutImageView.centerYAnchor),
            cell.workoutAdditionButton.widthAnchor.constraint(equalToConstant: cell.workoutAdditionButton.intrinsicContentSize.width),
            cell.workoutAdditionButton.heightAnchor.constraint(equalTo: cell.workoutImageView.heightAnchor),
            
            cell.workoutTimeLabel.trailingAnchor.constraint(equalTo: cell.workoutAdditionButton.leadingAnchor),
            cell.workoutTimeLabel.heightAnchor.constraint(equalTo: cell.workoutImageView.heightAnchor),
            cell.workoutTimeLabel.widthAnchor.constraint(equalToConstant: 60),
            cell.workoutTimeLabel.centerYAnchor.constraint(equalTo: cell.workoutAdditionButton.centerYAnchor),
            
            cell.workoutSubtractionButton.trailingAnchor.constraint(equalTo: cell.workoutTimeLabel.leadingAnchor),
            cell.workoutSubtractionButton.heightAnchor.constraint(equalTo: cell.workoutImageView.heightAnchor),
            cell.workoutSubtractionButton.widthAnchor.constraint(equalToConstant: cell.workoutSubtractionButton.intrinsicContentSize.width),
            cell.workoutSubtractionButton.centerYAnchor.constraint(equalTo: cell.workoutImageView.centerYAnchor),
            
            cell.restAdditionButton.centerYAnchor.constraint(equalTo: cell.restImageView.centerYAnchor),
            cell.restAdditionButton.centerXAnchor.constraint(equalTo: cell.workoutAdditionButton.centerXAnchor),
            cell.restAdditionButton.heightAnchor.constraint(equalTo: cell.workoutAdditionButton.heightAnchor),
            cell.restAdditionButton.widthAnchor.constraint(equalTo: cell.workoutAdditionButton.widthAnchor),
            
            cell.restTimeLabel.centerXAnchor.constraint(equalTo: cell.workoutTimeLabel.centerXAnchor),
            cell.restTimeLabel.centerYAnchor.constraint(equalTo: cell.restImageView.centerYAnchor),
            cell.restTimeLabel.widthAnchor.constraint(equalTo: cell.workoutTimeLabel.widthAnchor),
            cell.restTimeLabel.heightAnchor.constraint(equalTo: cell.workoutTimeLabel.heightAnchor),
            
            cell.restSubtractionButton.centerXAnchor.constraint(equalTo: cell.workoutSubtractionButton.centerXAnchor),
            cell.restSubtractionButton.centerYAnchor.constraint(equalTo: cell.restImageView.centerYAnchor),
            cell.restSubtractionButton.heightAnchor.constraint(equalTo: cell.workoutSubtractionButton.heightAnchor),
            cell.restSubtractionButton.widthAnchor.constraint(equalTo: cell.workoutSubtractionButton.widthAnchor)
        ])
        
        cell.workoutView.layer.cornerRadius = cell.workoutView.frame.height/2
        
        titleView.alpha = 1
        // Return the cell.
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set each of the four cells height to be one fourth of the total table view height so they perfectly fill the table view.
        return workoutTableView.frame.height/4
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
}

extension WorkoutEditViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Ignore the character limit if the backspace is being called.
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        // Unwrap the current text field
        guard let text = workoutTitleTextField.text else {return false}
        // If it's the field for the age or weight
        if textField == workoutTitleTextField {
            // Limit to Three characters
            return text.count < 11
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if workoutTitleTextField.text == "" {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.getHIITGray
        } else {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor.getHIITPrimaryOrange
        }
    }
}
