//
//  SelectWorkoutViewController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class SelectWorkoutViewController: UIViewController {
    
    // Outlets for the SelectWorkoutViewController
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var exerciseTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    // Variables for the SelectWorkoutViewController
    static var selected: [Int] = []
    static var fromWorkoutEditViewController: Bool = false
    static var fromWorkoutDescription: Bool = false
    static var mainView = UIView()
    static var mainTitleView = UIView()
    static var thisViewController = UIViewController()
    static var indexPathSelected: Int = 0
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SelectWorkoutViewController.mainView = self.view
        SelectWorkoutViewController.mainTitleView = self.titleView
        SelectWorkoutViewController.thisViewController = self
        setupConstraints()
        // Set the titleView gradient and shadows, disable the next button on loading.
        titleView.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        titleView.layer.masksToBounds = false
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor.getHIITGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialFade()
        print(SelectWorkoutViewController.selected.count)
        for wasSelected in SelectWorkoutViewController.selected {
            print(wasSelected)
        }
        exerciseTableView.reloadData()
        if SelectWorkoutViewController.fromWorkoutDescription {
            titleView.alpha = 1
            SelectWorkoutViewController.fromWorkoutDescription = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fadeIn()
    }
    
    // Dismiss the view controller when the back button is tapped.
    @IBAction func backButtonTapped(_ sender: Any) {
        WorkoutEditViewController.workoutTitle = ""
        SelectWorkoutViewController.selected = []
        fadeOut { (success) in
            if success {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    // Get the correct index path when the infoButton is tapped. This will be used for the segue.
    @IBAction func infoButtonTapped(_ sender: UIButton!) {
        // Unwrap the button.
        guard let button = sender else {return}
        // Find the button position as a CGPoint from the buttons bounds.
        let buttonPosition = button.convert(button.bounds.origin, to: exerciseTableView)
        // Unwrap the button's index path from the position defined above on the table.
        guard let indexPath = exerciseTableView.indexPathForRow(at:buttonPosition) else {return}
        // Set the class variable to the index path found above.
        SelectWorkoutViewController.indexPathSelected = indexPath.row
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            // Pull the Appropriate storyboard with the needed view controller.
            let storyboard = UIStoryboard(name: "HiitnessWorkout", bundle: nil)
            // Set our viewController as the CreateWorkoutViewController.
            let viewController = storyboard.instantiateViewController(withIdentifier: "editViewController") as! WorkoutEditViewController
            
            viewController.modalPresentationStyle = .fullScreen
            
            viewController.fromSelectWorkoutViewController = true
            
            // Present the viewController outside of the navigation controller so as not to carry on the tab bar controller.
            self.fadeOut { (success) in
                if success {
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
    }
    
    // Setup Segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segue Identifier
        if segue.identifier == "selectWorkoutCell" {
            // Destination View Controller.
            guard let destinationVC = segue.destination as? DescriptionViewController else {return}
            // Exercise to Send from the indexPath found in the infoButtonTapped IBAction Function.
            let exercise = ExerciseController.sharedInstance.workouts[SelectWorkoutViewController.indexPathSelected]
            // Object to Set
            destinationVC.exerciseLandingPad = exercise
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
        
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        exerciseTableView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            instructionLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 22),
            instructionLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            instructionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            exerciseTableView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 22),
            exerciseTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            exerciseTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -22),
            nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4),
            nextButton.heightAnchor.constraint(equalToConstant: 33),
            
            exerciseTableView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -22)
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
    
    static func fadeOutForCell(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            for sub in SelectWorkoutViewController.mainView.subviews {
                if sub != SelectWorkoutViewController.mainView.subviews[1] {
                    sub.alpha = 0
                }
            }
            for sub in [SelectWorkoutViewController.mainTitleView] {
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

extension SelectWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Set the number of rows to be the total number of exercises listed.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExerciseController.sharedInstance.workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set the cell as a SelectWorkoutTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectWorkoutCell", for: indexPath) as! SelectWorkoutTableViewCell
        
        // Pull the appropriate exercise from the ExerciseController.
        let exercise = ExerciseController.sharedInstance.workouts[indexPath.row]
        
        // Layout the cell and set the labels and borders.
        cell.layoutIfNeeded()
        cell.workoutNameLabel.text = exercise.name
        cell.borderView.layer.cornerRadius = cell.borderView.frame.height/2
        cell.borderView.layer.borderWidth = 3
        
        // Set the correct cell border color based on whether or not it's been selected.
        if SelectWorkoutViewController.selected.contains(indexPath.row) {
            cell.borderView.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        } else {
            cell.borderView.layer.borderColor = UIColor.getHIITGray.cgColor
        }
        
        // Return the cell.
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set the height for each row to be proportional to the height of the table and the number of cells. This makes the total number of cells fit perfectly in the table view.
        return exerciseTableView.frame.height / CGFloat(ExerciseController.sharedInstance.workouts.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        // Check if the row has been selected based on whether or not the class array variable 'selected' contrains the indexPath.
        if SelectWorkoutViewController.selected.contains(indexPath.row) {
            // If so, unwrap the index and remove it from the class array variable 'selected.
            guard let index = SelectWorkoutViewController.selected.firstIndex(of: indexPath.row) else {return}
            SelectWorkoutViewController.selected.remove(at: index)
        } else {
            // If the class array variable 'selected' contains four variables already, remove the first index in the array.
            if SelectWorkoutViewController.selected.count == 4 {
                SelectWorkoutViewController.selected.remove(at: 0)
            }
            // Add the newly selected element to the 'selected' array.
            SelectWorkoutViewController.selected.append(indexPath.row)
        }
        
        // Reload the table view data to update the cell borders.
        exerciseTableView.reloadData()
        
        // Once four cells have been selected, enable the next button, otherwise keep it disabled.
        if SelectWorkoutViewController.selected.count == 4 {
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor.getHIITPrimaryOrange
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = UIColor.getHIITGray
        }
    }
}
