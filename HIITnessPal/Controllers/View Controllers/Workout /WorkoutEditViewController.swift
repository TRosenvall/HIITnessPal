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
    @IBOutlet weak var workoutTitleTextField: UITextField!
    @IBOutlet weak var workoutTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var multiplierLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    // Variables
    var workouts: Workouts? // Workout Landing Pad.
    var timeTotal: Int = 0
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Unwrap the passed in workout from the landing pad.
        guard let workout = workouts else {return}
        // Set the titleView's gradient and shadows.
        SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        // Set the title based on the passed in workout.
        workoutTitleTextField.text = workouts?.name
        
        // Set the multiplier border constraints and label.
        multiplierLabel.layer.cornerRadius = multiplierLabel.frame.height/2
        multiplierLabel.layer.borderColor = UIColor.getHIITBlack.cgColor
        multiplierLabel.layer.borderWidth = 1
        multiplierLabel.text = "x\(workout.multiplier)"
        
        // Round the save button's corners.
        saveButton.layer.cornerRadius = saveButton.frame.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Call the function to set the total time.
        setTotalTime()
    }
    
    // Dismiss the viewController when the back button tapped.
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Lower the multiplier and reset the total time displayed.
    @IBAction func multiplierSubtractButtonTapped(_ sender: Any) {
        workouts?.multiplier -= 1
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
        WorkoutsController.sharedInstance.updateWorkout(workout: workouts, name: title, workouts: workouts.workouts, multiplier: multiplier)
        // Dismiss the view controllers back to the tabBarController.
        self.dismiss(animated: true, completion: nil)
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
        let workout = workouts?.workouts[indexPath.row]
        
        // Set the correct layer constraints for the workout part of the cell.
        cell.workoutView.layer.cornerRadius = cell.workoutView.frame.height/2
        cell.workoutView.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        cell.workoutView.layer.borderWidth = 3
        
        // Set the correct layer constraints for the rest part of the cell.
        cell.restView.layer.cornerRadius = cell.restView.frame.height/2
        cell.restView.layer.borderColor = UIColor.getHIITPrimaryBlue.cgColor
        cell.restView.layer.borderWidth = 3
        
        // Select the correct workout for the cell.
        cell.workout = workout
        
        // Display the correct image and name.
        if let workout = workout {
            cell.workoutImageView.image = UIImage(named: workout.image)
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
        
        // Return the cell.
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set each of the four cells height to be one fourth of the total table view height so they perfectly fill the table view.
        return workoutTableView.frame.height/4
    }
}


