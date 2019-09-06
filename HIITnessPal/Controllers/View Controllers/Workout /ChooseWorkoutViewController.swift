//
//  ChooseWorkoutViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/31/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class ChooseWorkoutViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var workoutTableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        workoutTableView.reloadData()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChooseWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutsController.sharedInstance.totalWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath)
        let workout = WorkoutsController.sharedInstance.totalWorkouts[indexPath.row]
        cell.textLabel?.text = workout.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        WorkoutMainViewController.lastSelectedIndex = indexPath.row
        self.dismiss(animated: true, completion: nil)
    }
}
