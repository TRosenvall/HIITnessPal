//
//  PastWorkoutsViewController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class PastWorkoutsViewController: UIViewController {
    
    // Outlets for the PastWorkoutsViewController
    @IBOutlet weak var titleView: UIView!
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the title view's gradient and shadows.
        SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    // Switch back to the UpcominWorkoutsViewController. These two views were embedded in a navigation controller in order to retain the TabBarController at the bottom. Because of this, this view must be popped instead of dismissed.
    @IBAction func upcomingButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }

}

extension PastWorkoutsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Set to the total number of workouts
    // TODO: - Needs to be updated to that last used completed workouts.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // TODO: - Add a completedWorkouts array to the workouts controller.
        return WorkoutsController.sharedInstance.totalWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set the cell to be a PastWorkoutsTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastWorkoutCell", for: indexPath) as! PastWorkoutsTableViewCell
        
        // Pull the correct workout from the given index.
        // TODO: - Pull from the to-be-added completeWorkouts array.
        let workouts = WorkoutsController.sharedInstance.totalWorkouts[indexPath.row]
        
        // Setup the cell label.
        cell.workoutNameLabel.text = workouts.name
        
        // Return the cell.
        return cell
    }
}
