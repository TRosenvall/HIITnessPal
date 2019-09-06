//
//  SelectWorkoutViewController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class SelectWorkoutViewController: UIViewController {
    
    @IBOutlet weak var exerciseTableView: UITableView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    static var selected: [Int] = []
    var indexPathSelected: Int = 0
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        nextButton.isEnabled = false
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func infoButtonTapped(_ sender: UIButton!) {
        guard let button = sender else {return}
        let buttonPosition = button.convert(button.bounds.origin, to: exerciseTableView)
        guard let indexPath = exerciseTableView.indexPathForRow(at:buttonPosition) else {return}
        indexPathSelected = indexPath.row
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Identifier
        if segue.identifier == "selectWorkoutCell" {
            //Index and Destination
            guard let destinationVC = segue.destination as? DescriptionViewController else {return}
            //Object to Send
            let exercise = ExerciseController.sharedExercises.workouts[indexPathSelected]
            //Object to Set
            destinationVC.exerciseLandingPad = exercise
        }
    }
}

extension SelectWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExerciseController.sharedExercises.workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectWorkoutCell", for: indexPath) as! SelectWorkoutTableViewCell
        let exercise = ExerciseController.sharedExercises.workouts[indexPath.row]
        cell.layoutIfNeeded()
        cell.workoutNameLabel.text = exercise.name
        cell.borderView.layer.cornerRadius = cell.borderView.frame.height/2
        cell.borderView.layer.borderWidth = 3
        if SelectWorkoutViewController.selected.contains(indexPath.row) {
            cell.borderView.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        } else {
            cell.borderView.layer.borderColor = UIColor.getHIITGray.cgColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return exerciseTableView.frame.height / CGFloat(ExerciseController.sharedExercises.workouts.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if SelectWorkoutViewController.selected.contains(indexPath.row) {
            guard let index = SelectWorkoutViewController.selected.firstIndex(of: indexPath.row) else {return}
            SelectWorkoutViewController.selected.remove(at: index)
        } else {
            if SelectWorkoutViewController.selected.count == 4 {
                SelectWorkoutViewController.selected.remove(at: 0)
            }
            SelectWorkoutViewController.selected.append(indexPath.row)
        }
        exerciseTableView.reloadData()
        if SelectWorkoutViewController.selected.count == 4 {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
}
