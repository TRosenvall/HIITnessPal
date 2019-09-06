//
//  SelectWorkoutViewController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class SelectWorkoutViewController: UIViewController {
    
    // Outlets for the SelectWorkoutViewController
    @IBOutlet weak var exerciseTableView: UITableView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    // Variables for the SelectWorkoutViewController
    static var selected: [Int] = []
    var indexPathSelected: Int = 0
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the titleView gradient and shadows, disable the next button on loading.
        SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        nextButton.isEnabled = false
    }
    
    // Dismiss the view controller when the back button is tapped.
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Get the correct index path when the infoButton is tapped. This will be used for the segue.
    @IBAction func infoButtonTapped(_ sender: UIButton!) {
        // Unwrap the button.
        guard let button = sender else {return}
        // Find the button position as a CGPoint from the buttons bounds.
        let buttonPosition = button.convert(button.bounds.origin, to: exerciseTableView)
        // Unwrap the button's index path from the position defined above on the table.
        guard let indexPath = exerciseTableView.indexPathForRow(at:buttonPosition) else {return}
        // Set the class variable to the index path found above.
        indexPathSelected = indexPath.row
    }
    
    // Setup Segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segue Identifier
        if segue.identifier == "selectWorkoutCell" {
            // Destination View Controller.
            guard let destinationVC = segue.destination as? DescriptionViewController else {return}
            // Exercise to Send from the indexPath found in the infoButtonTapped IBAction Function.
            let exercise = ExerciseController.sharedInstance.workouts[indexPathSelected]
            // Object to Set
            destinationVC.exerciseLandingPad = exercise
        }
    }
}

extension SelectWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Set the number of rows to be the total number of exercises listed.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExerciseController.sharedInstance.workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set the cell as a SelectWorkoutTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectWorkoutCell", for: indexPath) as! SelectWorkoutTableViewCell
        
        // Pull the appropriate exercise from the ExerciseController.
        let exercise = ExerciseController.sharedInstance.workouts[indexPath.row]
        
        // Layout the cell and set the labels and borders.
        cell.layoutIfNeeded()
        cell.workoutNameLabel.text = exercise.name
        cell.borderView.layer.cornerRadius = cell.borderView.frame.height/2
        cell.borderView.layer.borderWidth = 3
        
        // Set the correct cell border color based on whether or not it's been selected.
        if SelectWorkoutViewController.selected.contains(indexPath.row) {
            cell.borderView.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        } else {
            cell.borderView.layer.borderColor = UIColor.getHIITGray.cgColor
        }
        
        // Return the cell.
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set the height for each row to be proportional to the height of the table and the number of cells. This makes the total number of cells fit perfectly in the table view.
        return exerciseTableView.frame.height / CGFloat(ExerciseController.sharedInstance.workouts.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        // Check if the row has been selected based on whether or not the class array variable 'selected' contrains the indexPath.
        if SelectWorkoutViewController.selected.contains(indexPath.row) {
            // If so, unwrap the index and remove it from the class array variable 'selected.
            guard let index = SelectWorkoutViewController.selected.firstIndex(of: indexPath.row) else {return}
            SelectWorkoutViewController.selected.remove(at: index)
        } else {
            // If the class array variable 'selected' contains four variables already, remove the first index in the array.
            if SelectWorkoutViewController.selected.count == 4 {
                SelectWorkoutViewController.selected.remove(at: 0)
            }
            // Add the newly selected element to the 'selected' array.
            SelectWorkoutViewController.selected.append(indexPath.row)
        }
        
        // Reload the table view data to update the cell borders.
        exerciseTableView.reloadData()
        
        // Once four cells have been selected, enable the next button, otherwise keep it disabled.
        if SelectWorkoutViewController.selected.count == 4 {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
}
