//
//  ProfileViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/19/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    // IBOutlets for the Views for the buttons and images.
    // IBOutlets and variables.
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var numberOfExercisesLabel: UILabel!
    @IBOutlet weak var numberOfMinutesExercisedLabel: UILabel!
    @IBOutlet weak var numberOfCaloriesBurnedLabel: UILabel!
    @IBOutlet weak var numberOfExercisesThisWeekLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    // Source Of Truth
    var profile = ProfileController.sharedInstance.profile
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradient(view: titleView, chooseTwo: true, primaryBlue: false, accentOrange: true, accentBlue: false)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }
    
    func setupViews() {
        // Set the name
        let name = profile.name
        if name == "" {
 //           greetingLabel.text = "Hey there!"
        } else {
 //           greetingLabel.text = "Hey \(name)!"
        }
        // Set the outlet numbers
        let numberOfExercises = profile.completedExercises
        let numberOfMinutes = profile.totalTimeExercising
        let numberOfCalories = profile.caloriesBurnedThisWeek.reduce(0, +)
        let numberOfExercisesThisWeek = profile.exercisesThisWeek
        // Set the proper labels
        numberOfExercisesLabel.text = "\(numberOfExercises)"
        numberOfMinutesExercisedLabel.text = "\(numberOfMinutes)"
        if numberOfCalories == 0 {
            numberOfCaloriesBurnedLabel.text = "0"
        } else {
            numberOfCaloriesBurnedLabel.text = "\(numberOfCalories)"
        }
        numberOfExercisesThisWeekLabel.text = "\(numberOfExercisesThisWeek)"
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
