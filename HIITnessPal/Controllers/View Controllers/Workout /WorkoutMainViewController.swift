//
//  WorkoutMainViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/27/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class WorkoutMainViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var workoutSummaryView: UIView!
    @IBOutlet weak var currentWorkoutTableView: UITableView!
    
    @IBOutlet weak var workoutMultiplierLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    var timeTotal: Int = 0
    static var lastSelectedIndex: Int = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradient(view: titleView, chooseTwo: true, primaryBlue: false, accentOrange: true, accentBlue: false)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        workoutSummaryView.layer.cornerRadius = workoutSummaryView.frame.width/2
        workoutSummaryView.layer.borderColor = UIColor.clear.cgColor
        workoutSummaryView.layer.borderWidth = 6
        gradientForWorkoutSummaryView()
        
        currentWorkoutTableView.backgroundColor = .clear
        
        startButton.layer.cornerRadius = startButton.frame.height/4
        
        editButton.layer.cornerRadius = editButton.frame.height/4
        editButton.layer.borderWidth = 3
        editButton.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        editButton.layer.shadowOpacity = 0.25
        editButton.layer.shadowRadius = 4
        editButton.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentWorkoutTableView.reloadData()
        let tempWorkouts = WorkoutsController.sharedInstance.totalWorkouts[WorkoutMainViewController.lastSelectedIndex]
        
        titleLabel.text = "\(tempWorkouts.name)"
        
        workoutMultiplierLabel.text = "\(tempWorkouts.multiplier)X"
        
        var tempTimeTotal: Int = 0
        for workout in tempWorkouts.workouts {
            tempTimeTotal += workout.duration + workout.rest
        }
        if timeTotal != tempTimeTotal {
            timeTotal = tempTimeTotal
            tempTimeTotal = 0
        }
        
        timeTotal *= tempWorkouts.multiplier
        
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
        
        totalTimeLabel.text = minutesLabel + ":" + secondsLabel + " Total"
    }
    
    func gradientForWorkoutSummaryView () {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: self.workoutSummaryView.frame.size)
        gradient.colors = [UIColor.getHIITAccentOrange.cgColor, UIColor.getHIITPrimaryOrange.cgColor]
        
        let path = UIBezierPath(roundedRect: self.workoutSummaryView.bounds.insetBy(dx: self.workoutSummaryView.layer.borderWidth/2, dy: self.workoutSummaryView.layer.borderWidth/2), cornerRadius: self.workoutSummaryView.layer.cornerRadius)
        
        let shape = CAShapeLayer()
        shape.lineWidth = self.workoutSummaryView.layer.borderWidth
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        self.workoutSummaryView.layer.addSublayer(gradient)
    }
    
    func setGradient(view: UIView, chooseTwo primaryOrange: Bool, primaryBlue: Bool, accentOrange: Bool, accentBlue: Bool, verticalFlip: Bool = false) {
        
        var color1: UIColor = .getHIITPrimaryOrange
        var color2: UIColor = .getHIITAccentOrange
        var placeholder: UIColor = UIColor()
        
        switch (primaryOrange, primaryBlue, accentOrange, accentBlue) {
        case (true, true, false, false):
            color1 = .getHIITPrimaryOrange
            color2 = .getHIITPrimaryBlue
        case (true, false, true, false):
            color1 = .getHIITPrimaryOrange
            color2 = .getHIITAccentOrange
        case (false, true, false, true):
            color1 = .getHIITPrimaryBlue
            color2 = .getHIITAccentBlue
        default:
            print("That gradient didnt work")
        }
        
        if verticalFlip == true {
            placeholder = color1
            color1 = color2
            color2 = placeholder
            placeholder = UIColor()
        }
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        
        view.layer.insertSublayer(gradient, at: 0)
    }
}

extension WorkoutMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currentWorkoutCell", for: indexPath) as? WorkoutTableViewCell else {return UITableViewCell()}
        cell.layoutIfNeeded()
        cell.backgroundColor = .clear
        
        cell.dotView.layer.cornerRadius = cell.dotView.frame.height/2

        cell.exerciseView.layer.cornerRadius = cell.exerciseView.bounds.height/2
        cell.exerciseView.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        cell.exerciseView.layer.borderWidth = 3
        cell.exerciseView.clipsToBounds = true

        cell.restView.layer.cornerRadius = cell.restView.frame.height/2
        cell.restView.layer.borderColor = UIColor.getHIITPrimaryBlue.cgColor
        cell.restView.layer.borderWidth = 3
        cell.restView.clipsToBounds = true
        
        let tempWorkouts = WorkoutsController.sharedInstance.totalWorkouts[0]
        let exercise = tempWorkouts.workouts[indexPath.row]
        cell.titleLabel.text = exercise.name
        cell.exerciseTimeLabel.text = "Duration: \(exercise.duration)s"
        cell.restTimeLabel.text = "Rest: \(exercise.rest)s"
        cell.exerciseImageView.image = UIImage(named: exercise.image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentWorkoutTableView.frame.height/4
    }
    
    // Mark: - Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Identifier
        if segue.identifier == "toWorkoutEdit" {
            //Index and Destination
            guard let destinationVC = segue.destination as?  WorkoutEditViewController else {return}
            //Object to Send
            let workouts = WorkoutsController.sharedInstance.totalWorkouts[0]
            //Object to Set
            destinationVC.workouts = workouts
        }
    }
}
