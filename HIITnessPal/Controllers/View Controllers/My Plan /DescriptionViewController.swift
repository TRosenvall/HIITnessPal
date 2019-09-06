//
//  DescriptionViewController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    // Outlets for the DiscriptionViewController
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var HeaderTitleLabel: UILabel!
    @IBOutlet weak var workoutInfoLabel: UILabel!
    @IBOutlet weak var exerciseImageView: UIImageView!
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Workout landing pad for the segue from the SelectWorkoutViewController.
    var exerciseLandingPad: Workout?{
        didSet {
            // Update the views when this is set.
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the title view griadient and shadows.
        SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    // Dismiss the controller when the back button is pressed.
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to update the views.
    func updateViews() {
        // Unwrap the exercise from the landing pad.
        guard let exercise = exerciseLandingPad else {return}
        // Load the views
        loadViewIfNeeded()
        // Set the text labels.
        HeaderTitleLabel.text = exercise.name
        workoutInfoLabel.text = exercise.description
        exerciseImageView.image = UIImage(named: exercise.image)
    }
}
