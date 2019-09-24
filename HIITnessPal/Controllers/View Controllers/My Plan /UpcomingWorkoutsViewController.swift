//
//  UpcomingWorkoutsViewController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class UpcomingWorkoutsViewController: UIViewController {
    
    // Outlets for the SelectWorkoutViewController
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var planTableView: UITableView!
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This viewController is embedded in a navigation controller.
        // Hide the NavigationBar.
        self.navigationController?.isNavigationBarHidden = true
        // Set the title view gradients and shadow.
        SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // Set this view controller to be the associated tableView's delegate and dataSource. These were typically declared on the storyboards, this is declared here to help debug a problem earlier on.
        planTableView.delegate = self
        planTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload the table view's data whenever the view loads.
        planTableView.reloadData()
    }
    
    @IBAction func pastButtonTapped(_ sender: Any) {
        // Pull the Appropriate storyboard with the needed view controller.
        let storyboard = UIStoryboard(name: "MyHiitnessPlan", bundle: nil)
        // Set our viewController as the PastWorkoutsViewController.
        let viewController = storyboard.instantiateViewController(withIdentifier: "PastWorkoutsStoryboard")
        // Navigate to the viewController through the navigation controller.
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func createButtonWorkoutTapped(_ sender: Any) {
        // Pull the Appropriate storyboard with the needed view controller.
        let storyboard = UIStoryboard(name: "MyHiitnessPlan", bundle: nil)
        // Set our viewController as the CreateWorkoutViewController.
        let viewController = storyboard.instantiateViewController(withIdentifier: "CreateWorkoutStoryboard")
        // Present the viewController outside of the navigation controller so as not to carry on the tab bar controller.
        self.present(viewController, animated: true, completion: nil)
    }
}

extension UpcomingWorkoutsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Set the number of rows to be the total number of workouts created.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutsController.sharedInstance.totalWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set the cell as an UpcomingWorkoutsTableViewCell.
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingWorkoutCell", for: indexPath) as! UpcomingWorkoutsTableViewCell
        
        // Select the specific workout for each cell.
        let workout = WorkoutsController.sharedInstance.totalWorkouts[indexPath.row]
        
        // Set the correct labels for the cell. based on the workout.
        cell.workoutNameLabel.text = workout.name
        cell.workout1Label.text = workout.workouts[0].name
        cell.workout2Label.text = workout.workouts[1].name
        cell.workout3Label.text = workout.workouts[2].name
        cell.workout4Label.text = workout.workouts[3].name
        
        // Calculate the time to be displayed
        // Place holder for the total time.
        var totalTime: Int = 0
        // Total the duration and rest time for each exercise in the workout.
        for exercise in workout.workouts {
            totalTime += exercise.duration + exercise.rest
        }
        // Factor in the multiplier.
        totalTime *= workout.multiplier
        // Setup the minutes and seconds label.
        let minutesLabel = "\(totalTime/60)"
        let secondsLabel = "\(totalTime%60)"
        // Set the labels in the cell's totalTimeLabel.
        cell.totalTimeLabel.text = "\(minutesLabel):\(secondsLabel)"
        cell.calorieCount.text = "\(-Double(Int(HealthKitController.sharedInstance.getCaloriesBurned(durationOfWorkoutInMinutes: Double(totalTime)/60)*100))/100)"
        
        // Set the cells borders
        cell.layer.cornerRadius = cell.frame.height/5
        cell.layer.borderColor = UIColor.getHIITGray.cgColor
        cell.layer.borderWidth = 2
        
        // Inset the cells height by a little bit. (This might not work correctly right now.
        cell.bounds.insetBy(dx: 0, dy: 3)
        
        // Return the cell.
        return cell
    }
}
