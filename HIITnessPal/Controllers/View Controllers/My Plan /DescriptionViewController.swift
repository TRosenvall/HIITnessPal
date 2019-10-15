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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var workoutInfoLabel: UILabel!
    
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
        setupConstraints()
        // Set the titleView gradient and shadows, disable the next button on loading.
        titleView.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        titleView.layer.masksToBounds = false
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        SelectWorkoutViewController.fromWorkoutDescription = true
        
        exerciseLandingPad = ExerciseController.sharedInstance.workouts[SelectWorkoutViewController.indexPathSelected]
        descriptionLabel.sizeToFit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialFade()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fadeIn()
    }
    
    // Dismiss the controller when the back button is pressed.
    @IBAction func backButtonTapped(_ sender: Any) {
        fadeOut { (success) in
            if success {
                self.dismiss(animated: false, completion: nil)
            }
        }
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
    
    // Function to update the views.
    func updateViews() {
        // Unwrap the exercise from the landing pad.
        guard let exercise = exerciseLandingPad else {return}
        // Load the views
        loadViewIfNeeded()
        // Set the text labels.
        titleLabel.text = exercise.name
        workoutInfoLabel.text = exercise.description
        exerciseImageView.image = UIImage(named: "\(exercise.image)1")
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
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.71
            
            titleLabelWidthMultiplier = 0.9
        case "large":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.72
            
            titleLabelWidthMultiplier = 0.9
        case "x":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.74
            
            titleLabelWidthMultiplier = 0.9
        case "r":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
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
        
        exerciseImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        workoutInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        workoutInfoLabel.font = workoutInfoLabel.font.withSize(18)
        workoutInfoLabel.sizeToFit()
        
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
            
            exerciseImageView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            exerciseImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),
            exerciseImageView.heightAnchor.constraint(equalTo: exerciseImageView.widthAnchor),
            exerciseImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: exerciseImageView.bottomAnchor, constant: 11),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: descriptionLabel.intrinsicContentSize.height),
            
            workoutInfoLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 11),
            workoutInfoLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor),
            workoutInfoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            workoutInfoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }
}
