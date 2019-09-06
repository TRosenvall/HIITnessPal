//
//  ChooseWorkoutViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/31/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class ChooseWorkoutViewController: UIViewController {
    
    // Set IBOutlets
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var workoutTableView: UITableView!
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the gradient and the shadow for the title view.
        SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload the tableView's data when the view appears.
        workoutTableView.reloadData()
    }
    
    // Dismiss the view when the back button is tapped.
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChooseWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    // Select the appropriate number of rows based on the workouts that exist.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutsController.sharedInstance.totalWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath)
        // Select the given workout from the total workouts.
        let workout = WorkoutsController.sharedInstance.totalWorkouts[indexPath.row]
        
        // Display the cell label as the name of the workout.
        cell.textLabel?.text = workout.name
        
        // Return the cell.
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Pass the index back to the WorkoutMainViewController and dismiss the view.
        WorkoutMainViewController.lastSelectedIndex = indexPath.row
        self.dismiss(animated: true, completion: nil)
    }
}
