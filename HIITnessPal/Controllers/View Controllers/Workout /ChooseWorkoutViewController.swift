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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var workoutTableView: UITableView!
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        
        // Set the gradient and the shadow for the title view.
        titleView.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        titleView.layer.masksToBounds = false
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload the tableView's data when the view appears.
        workoutTableView.reloadData()
        initialFade()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fadeIn()
    }
    
    // Dismiss the view when the back button is tapped.
    @IBAction func backButtonTapped(_ sender: Any) {
        fadeOut { (success) in
            if success {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func getiPhoneSize () -> String {
        switch( self.view.frame.height) {
        case 568:
            return "small"
        case 667:
            return "medium"
        case 736:
            return "large"
        case 812:
            return "x"
        case 896:
            return "r"
        default:
            print("...")
            print("---")
            print(self.view.frame.height)
            print("---")
            print("...")
        }
        return ""
    }
    
    func setupConstraints() {
        var titleFontSize: CGFloat = 0
        var titleHeightMultiplier: CGFloat = 0
        var backButtonLeadingConstant: CGFloat = 0
        var backButtonBottomConstant: CGFloat = 0
        var backButtonHeightMultiplier: CGFloat = 0
        var titleLabelWidthMultiplier: CGFloat = 0
        
        switch (getiPhoneSize()) {
        case "small":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.7
            
            titleLabelWidthMultiplier = 0.9
            
        case "medium":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9
            
        case "large":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9

        case "x":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9

        case "r":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9

        default:
            print("Something went wrong getting iphone screen size")
        }
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleLabel.font.withSize(titleFontSize)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        workoutTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: self.view.topAnchor),
            titleView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: titleHeightMultiplier),
            titleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        
            backButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: backButtonLeadingConstant),
            backButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: backButtonBottomConstant),
            backButton.heightAnchor.constraint(equalToConstant: titleView.frame.size.height * backButtonHeightMultiplier),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: titleView.widthAnchor, multiplier: titleLabelWidthMultiplier),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            workoutTableView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            workoutTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            workoutTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            workoutTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func initialFade() {
        for sub in self.view.subviews {
            if sub != titleView {
                sub.alpha = 0
            }
        }
        for sub in titleView.subviews {
            sub.alpha = 0
        }
    }
    
    func fadeOut(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            for sub in self.view.subviews {
                if sub != self.titleView {
                    sub.alpha = 0
                }
            }
            for sub in self.titleView.subviews {
                sub.alpha = 0
            }
        }) { (success) in
            completion(success)
        }
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.2) {
            for sub in self.view.subviews {
                if sub != self.titleView {
                    sub.alpha = 1
                }
            }
            for sub in self.titleView.subviews {
                sub.alpha = 1
            }
        }
    }
}

extension ChooseWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    // Select the appropriate number of rows based on the workouts that exist.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutsController.sharedInstance.totalWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as! ChooseWorkoutTableViewCell
        // Select the given workout from the total workouts.
        let workout = WorkoutsController.sharedInstance.totalWorkouts[indexPath.row]

        // Display the cell label as the name of the workout.
        cell.titleLabel.text = workout.name
        var time = 0
        for exercise in workout.workouts {
            time += exercise.duration + exercise.rest
        }
        time = time * workout.multiplier
        cell.timeLabel.text = "\(time/60):\(time%60)"
        
        cell.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.boarderView.translatesAutoresizingMaskIntoConstraints = false
        cell.frame.size.height = 88
        var cellBoarderViewTopConstant: CGFloat = 0
        if indexPath.row == 0 {
            cellBoarderViewTopConstant = 4
        } else {
            cellBoarderViewTopConstant = 2
        }
        
        NSLayoutConstraint.activate([
            cell.boarderView.topAnchor.constraint(equalTo: cell.topAnchor, constant: cellBoarderViewTopConstant),
            cell.boarderView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -2),
            cell.boarderView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 4),
            cell.boarderView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -4),
            
            cell.timeLabel.trailingAnchor.constraint(equalTo: cell.boarderView.trailingAnchor, constant: -22),
            cell.timeLabel.centerYAnchor.constraint(equalTo: cell.boarderView.centerYAnchor),
            cell.timeLabel.widthAnchor.constraint(equalToConstant: cell.timeLabel.intrinsicContentSize.width),
            cell.timeLabel.heightAnchor.constraint(equalToConstant: cell.timeLabel.intrinsicContentSize.height),
            
            cell.titleLabel.leadingAnchor.constraint(equalTo: cell.boarderView.leadingAnchor, constant: 22),
            cell.titleLabel.centerYAnchor.constraint(equalTo: cell.boarderView.centerYAnchor),
            cell.titleLabel.widthAnchor.constraint(equalToConstant: cell.titleLabel.intrinsicContentSize.width),
            cell.titleLabel.heightAnchor.constraint(equalToConstant: cell.titleLabel.intrinsicContentSize.height),
        ])
        
        cell.boarderView.layer.cornerRadius = cell.boarderView.frame.height/2.5
        if indexPath.row % 2 == 0 {
            cell.boarderView.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        } else {
            cell.boarderView.layer.borderColor = UIColor.getHIITPrimaryBlue.cgColor
        }
        cell.boarderView.layer.borderWidth = 4
        
        // Return the cell.
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Pass the index back to the WorkoutMainViewController and dismiss the view.
        WorkoutMainViewController.selectedIndex = indexPath.row
        WorkoutMainViewController.lastSelectedIndex = indexPath.row
        fadeOut { (success) in
            if success {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            WorkoutMainViewController.lastSelectedIndex = 0
            let workout = WorkoutsController.sharedInstance.totalWorkouts[indexPath.row]
            WorkoutsController.sharedInstance.deleteWorkout(workout: workout)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let count = WorkoutsController.sharedInstance.totalWorkouts.count
        if count == 1 {
            return .none
        } else {
            return .delete
        }
    }
}
