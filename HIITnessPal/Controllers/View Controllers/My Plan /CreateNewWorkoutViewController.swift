//
//  CreateNewWorkoutViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class CreateNewWorkoutViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var workoutTitleTextField: UITextField!
    @IBOutlet weak var workoutTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var multiplierLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    let exerciseList = ExerciseController.sharedExercises.workouts
    let existingWorkouts: [Workout] = []
    var exercises: [Workout] = []
    
    lazy var workouts: Workouts = Workouts(name: "", workouts: self.exercises, multiplier: 1)
    var timeTotal: Int = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateExercises()
        SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        workoutTitleTextField.text = workouts.name
        
        multiplierLabel.layer.cornerRadius = multiplierLabel.frame.height/2
        multiplierLabel.layer.borderColor = UIColor.getHIITBlack.cgColor
        multiplierLabel.layer.borderWidth = 1
        multiplierLabel.text = "x\(workouts.multiplier)"
        
        saveButton.layer.cornerRadius = saveButton.frame.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTotalTime()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func multiplierSubtractButtonTapped(_ sender: Any) {
        workouts.multiplier -= 1
        let multiplier = workouts.multiplier
        multiplierLabel.text = "x\(multiplier)"
        setTotalTime()
    }
    
    @IBAction func multiplierAddButtonTapped(_ sender: Any) {
        workouts.multiplier += 1
        let multiplier = workouts.multiplier
        multiplierLabel.text = "x\(multiplier)"
        setTotalTime()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = workoutTitleTextField.text else {return}
        guard var multiplierText = multiplierLabel.text else {return}
        guard let index = multiplierText.firstIndex(of: "x") else {return}
        multiplierText.remove(at: index)
        guard let multiplier = Int(multiplierText) else {return}
        WorkoutsController.sharedInstance.createWorkout(name: title, workouts: workouts.workouts, multiplier: multiplier)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setTotalTime() {
        var tempTimeTotal: Int = 0
        let workout = workouts.workouts
            for exercise in workout {
                tempTimeTotal += exercise.duration + exercise.rest
            }
        if timeTotal != tempTimeTotal {
            timeTotal = tempTimeTotal
            tempTimeTotal = 0
        }
        timeTotal *= workouts.multiplier
        
        let minutes = timeTotal / 60
        var minutesLabel = ""
        let seconds = timeTotal % 60
        var secondsLabel = ""
        
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
        
        totalTimeLabel.text = minutesLabel + ":" + secondsLabel
    }
    
    func populateExercises() {
        let list: [Int] = SelectWorkoutViewController.selected
        for x in list {
            let workout = exerciseList[x]
            exercises.append(workout)
        }
    }

}

extension CreateNewWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "createWorkoutCell", for: indexPath) as? CreateWorkoutTableViewCell else {return UITableViewCell()}
        let workout = workouts.workouts[indexPath.row]
        
        cell.workoutView.layer.cornerRadius = cell.workoutView.frame.height/2
        cell.workoutView.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        cell.workoutView.layer.borderWidth = 3
        
        cell.restView.layer.cornerRadius = cell.restView.frame.height/2
        cell.restView.layer.borderColor = UIColor.getHIITPrimaryBlue.cgColor
        cell.restView.layer.borderWidth = 3
        
        cell.workout = workout
        
        cell.workoutImageView.image = UIImage(named: workout.image)
        cell.workoutTitle.text = workout.name

        let workoutMinutes = workout.duration / 60
        let workoutSeconds = workout.duration % 60
        cell.workoutTimeLabel.text = "\(workoutMinutes):\(workoutSeconds)"
        
        let minutes = workout.rest / 60
        let seconds = workout.rest % 60
        cell.restTimeLabel.text = "\(minutes):\(seconds)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return workoutTableView.frame.height/4
    }
}
