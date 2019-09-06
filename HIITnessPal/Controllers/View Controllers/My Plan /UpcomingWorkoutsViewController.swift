//
//  UpcomingWorkoutsViewController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class UpcomingWorkoutsViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var planTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
         SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        // Do any additional setup after loading the view.
        planTableView.delegate = self
        planTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        planTableView.reloadData()
    }
    
    @IBAction func pastButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MyPlan", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PastWorkoutsStoryboard")
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func createButtonWorkoutTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MyPlan", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CreateWorkoutStoryboard")
        self.present(viewController, animated: true, completion: nil)
    }
}

extension UpcomingWorkoutsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutsController.sharedInstance.totalWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingWorkoutCell", for: indexPath) as! UpcomingWorkoutsTableViewCell
        
        let workout = WorkoutsController.sharedInstance.totalWorkouts[indexPath.row]
        
        cell.workoutNameLabel.text = workout.name
        cell.workout1Label.text = workout.workouts[0].name
        cell.workout2Label.text = workout.workouts[1].name
        cell.workout3Label.text = workout.workouts[2].name
        cell.workout4Label.text = workout.workouts[3].name
        
        var totalTime: Int = 0
        for exercise in workout.workouts {
            totalTime += exercise.duration + exercise.rest
        }
        totalTime *= workout.multiplier
        let minutesLabel = "\(totalTime/60)"
        let secondsLabel = "\(totalTime%60)"
        cell.totalTimeLabel.text = "\(minutesLabel):\(secondsLabel)"
        
        cell.layer.cornerRadius = cell.frame.height/5
        cell.layer.borderColor = UIColor.getHIITGray.cgColor
        cell.layer.borderWidth = 2
        
        cell.bounds.insetBy(dx: 0, dy: 3)
        
        return cell
    }
    
    
    
    
}
