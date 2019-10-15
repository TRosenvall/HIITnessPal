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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var rotationImageView: UIImageView!
    @IBOutlet weak var changeWorkoutButton: UIButton!
    @IBOutlet weak var currentWorkoutTableView: UITableView!
    @IBOutlet weak var workoutCyclesLabel: UILabel!
    @IBOutlet weak var workoutMultiplierLabel: UILabel!
    @IBOutlet weak var totalWorkoutTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    var timeTotal: Int = 0
    static var selectedIndex: Int = 0
    static var lastSelectedIndex: Int = 0
    static var fromWorkoutCompleted: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        
        titleView.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        titleView.layer.masksToBounds = false
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        currentWorkoutTableView.backgroundColor = .clear
        
        startButton.layer.cornerRadius = startButton.frame.height/3
        
        
        editButton.layer.cornerRadius = editButton.frame.height/4
        editButton.layer.borderWidth = 3
        editButton.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        editButton.layer.shadowOpacity = 0.25
        editButton.layer.shadowRadius = 4
        editButton.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initialFade()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.getHIITPrimaryOrange], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.getHIITGray], for: .normal)
        
        if WorkoutMainViewController.fromWorkoutCompleted == true {
            WorkoutMainViewController.fromWorkoutCompleted = false
            DashboardViewController.fromWorkoutMainView = true
            tabBarController?.selectedIndex = 0
        }
        
        fadeIn()
        backButton.alpha = 0
        
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
        
        totalTimeLabel.text = minutesLabel + ":" + secondsLabel
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        WorkoutEditViewController.fromWorkoutMainViewController = true
        DispatchQueue.main.async {
            // Pull the Appropriate storyboard with the needed view controller.
            let storyboard = UIStoryboard(name: "HiitnessWorkout", bundle: nil)
            // Set our viewController as the CreateWorkoutViewController.
            let viewController = storyboard.instantiateViewController(withIdentifier: "editViewController") as! WorkoutEditViewController
            
            viewController.modalPresentationStyle = .fullScreen
            
            // Present the viewController outside of the navigation controller so as not to carry on the tab bar controller.
            self.fadeOut { (success) in
                if success {
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
    }
    
    @IBAction func chooseWorkoutButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            // Pull the Appropriate storyboard with the needed view controller.
            let storyboard = UIStoryboard(name: "HiitnessWorkout", bundle: nil)
            // Set our viewController as the CreateWorkoutViewController.
            let viewController = storyboard.instantiateViewController(withIdentifier: "chooseWorkout")
            
            viewController.modalPresentationStyle = .fullScreen
            
            // Present the viewController outside of the navigation controller so as not to carry on the tab bar controller.
            self.fadeOut { (success) in
                if success {
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            // Pull the Appropriate storyboard with the needed view controller.
            let storyboard = UIStoryboard(name: "HiitnessWorkout", bundle: nil)
            // Set our viewController as the CreateWorkoutViewController.
            let viewController = storyboard.instantiateViewController(withIdentifier: "workoutTimer")
            
            viewController.modalPresentationStyle = .fullScreen
            
            // Present the viewController outside of the navigation controller so as not to carry on the tab bar controller.
            self.fadeOut { (success) in
                if success {
                    self.present(viewController, animated: false, completion: nil)
                }
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
    
    override func viewWillLayoutSubviews() {
        var height: CGFloat = 0
        switch (getiPhoneSize()) {
        case "small":
            height = 82
        case "medium":
            height = 110
        case "large":
            height = 105
        case "x":
            height = 110
        case "r":
            height = 110
        default:
            print("Something went wrong getting iphone screen size")
        }
        // Set the height variable for the tab bar, here it's defined as 110 points above it's normal.
        var tabFrame: CGRect = (self.tabBarController?.tabBar.frame)!
        // Change the height of the tabBar, then move it up by that amount from the bottom.
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        // Set the new frame size here.
        self.tabBarController?.tabBar.frame = tabFrame
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
    
    func setupConstraints() {
        var titleFontSize: CGFloat = 0
        var titleHeightMultiplier: CGFloat = 0
        var backButtonLeadingConstant: CGFloat = 0
        var backButtonBottomConstant: CGFloat = 0
        var backButtonHeightMultiplier: CGFloat = 0
        var rotationImageViewTopConstant: CGFloat = 0
        var rotationImageViewHeightMultiplier: CGFloat = 0
        var rotationImageViewWidthMultiplier: CGFloat = 0
        var titleLabelWidthMultiplier: CGFloat = 0
        var currentWorkoutTableViewLeadingConstant: CGFloat = 0
        var currentWorkoutTableViewHeightMultiplier: CGFloat = 0
        var workoutCyclesLabelTopConstant: CGFloat = 0
        var workoutCyclesLabelFontSize: CGFloat = 0
        var workoutMultiplierLabelTopConstant: CGFloat = 0
        var editButtonWidthMultiplier: CGFloat = 0
        var editButtonTopConstant: CGFloat = 0
        
        switch (getiPhoneSize()) {
        case "small":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.7
            
            titleLabelWidthMultiplier = 0.9
            
            rotationImageViewTopConstant = 11
            rotationImageViewHeightMultiplier = 0.5
            rotationImageViewWidthMultiplier = 0.19
            
            currentWorkoutTableViewLeadingConstant = -22.625
            currentWorkoutTableViewHeightMultiplier = 0.97
            
            workoutCyclesLabelTopConstant = 8
            workoutCyclesLabelFontSize = 10
            
            workoutMultiplierLabelTopConstant = 2
            
            editButtonWidthMultiplier = 0.5
            editButtonTopConstant = 11
        case "medium":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9
            
            rotationImageViewTopConstant = 11
            rotationImageViewHeightMultiplier = 0.5
            rotationImageViewWidthMultiplier = 0.19
            
            currentWorkoutTableViewLeadingConstant = -26.1
            currentWorkoutTableViewHeightMultiplier = 0.97
            
            workoutCyclesLabelTopConstant = 11
            workoutCyclesLabelFontSize = 10
            
            workoutMultiplierLabelTopConstant = 11
            
            editButtonWidthMultiplier = 0.5
            editButtonTopConstant = 11
        case "large":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9

            rotationImageViewTopConstant = 11
            rotationImageViewHeightMultiplier = 0.55
            rotationImageViewWidthMultiplier = 0.19
            
            currentWorkoutTableViewLeadingConstant = -29
            currentWorkoutTableViewHeightMultiplier = 0.97
            
            workoutCyclesLabelTopConstant = 11
            workoutCyclesLabelFontSize = 10
            
            workoutMultiplierLabelTopConstant = 11
            
            editButtonWidthMultiplier = 0.5
            editButtonTopConstant = 11
        case "x":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9

            rotationImageViewTopConstant = 11
            rotationImageViewHeightMultiplier = 0.58
            rotationImageViewWidthMultiplier = 0.19
            
            currentWorkoutTableViewLeadingConstant = -27.4
            currentWorkoutTableViewHeightMultiplier = 0.97
            
            workoutCyclesLabelTopConstant = 11
            workoutCyclesLabelFontSize = 10
            
            workoutMultiplierLabelTopConstant = 11
            
            editButtonWidthMultiplier = 0.5
            editButtonTopConstant = 11
        case "r":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9

            rotationImageViewTopConstant = 11
            rotationImageViewHeightMultiplier = 0.58
            rotationImageViewWidthMultiplier = 0.19
            
            currentWorkoutTableViewLeadingConstant = -31.1
            currentWorkoutTableViewHeightMultiplier = 0.97
            
            workoutCyclesLabelTopConstant = 11
            workoutCyclesLabelFontSize = 10
            
            workoutMultiplierLabelTopConstant = 11
            
            editButtonWidthMultiplier = 0.5
            editButtonTopConstant = 11
        default:
            print("Something went wrong getting iphone screen size")
        }
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleLabel.font.withSize(titleFontSize)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.isEnabled = false
        backButton.alpha = 0
        rotationImageView.translatesAutoresizingMaskIntoConstraints = false
        changeWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.sendSubviewToBack(rotationImageView)
        currentWorkoutTableView.translatesAutoresizingMaskIntoConstraints = false
        workoutCyclesLabel.translatesAutoresizingMaskIntoConstraints = false
        workoutMultiplierLabel.translatesAutoresizingMaskIntoConstraints = false
        workoutCyclesLabel.font = workoutCyclesLabel.font.withSize(workoutCyclesLabelFontSize)
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        totalTimeLabel.textAlignment = .right
        totalWorkoutTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        totalWorkoutTimeLabel.font = workoutCyclesLabel.font.withSize(workoutCyclesLabelFontSize)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            changeWorkoutButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            changeWorkoutButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -backButtonLeadingConstant),
            changeWorkoutButton.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            changeWorkoutButton.widthAnchor.constraint(equalTo: changeWorkoutButton.heightAnchor),
            
            rotationImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            rotationImageView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: rotationImageViewTopConstant),
            rotationImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: rotationImageViewHeightMultiplier),
            rotationImageView.widthAnchor.constraint(equalTo: rotationImageView.heightAnchor, multiplier: rotationImageViewWidthMultiplier),
            
            currentWorkoutTableView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            currentWorkoutTableView.heightAnchor.constraint(equalTo: rotationImageView.heightAnchor, multiplier: currentWorkoutTableViewHeightMultiplier),
            currentWorkoutTableView.leadingAnchor.constraint(equalTo: rotationImageView.trailingAnchor, constant: currentWorkoutTableViewLeadingConstant),
            currentWorkoutTableView.centerYAnchor.constraint(equalTo: rotationImageView.centerYAnchor),
            
            workoutCyclesLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            workoutCyclesLabel.topAnchor.constraint(equalTo: rotationImageView.bottomAnchor, constant: workoutCyclesLabelTopConstant),
            workoutCyclesLabel.heightAnchor.constraint(equalToConstant: workoutCyclesLabel.intrinsicContentSize.height),
            workoutCyclesLabel.widthAnchor.constraint(equalToConstant: workoutCyclesLabel.intrinsicContentSize.width),
            
            totalWorkoutTimeLabel.centerYAnchor.constraint(equalTo: workoutCyclesLabel.centerYAnchor),
            totalWorkoutTimeLabel.trailingAnchor.constraint(equalTo: currentWorkoutTableView.trailingAnchor),
            totalWorkoutTimeLabel.heightAnchor.constraint(equalToConstant: totalWorkoutTimeLabel.intrinsicContentSize.height),
            totalWorkoutTimeLabel.widthAnchor.constraint(equalToConstant: totalWorkoutTimeLabel.intrinsicContentSize.width),
            
            workoutMultiplierLabel.leadingAnchor.constraint(equalTo: workoutCyclesLabel.leadingAnchor),
            workoutMultiplierLabel.topAnchor.constraint(equalTo: workoutCyclesLabel.bottomAnchor, constant: workoutMultiplierLabelTopConstant),
            workoutMultiplierLabel.heightAnchor.constraint(equalToConstant: workoutMultiplierLabel.intrinsicContentSize.height),
            workoutMultiplierLabel.widthAnchor.constraint(equalToConstant: workoutMultiplierLabel.intrinsicContentSize.width),
            
            totalTimeLabel.trailingAnchor.constraint(equalTo: totalWorkoutTimeLabel.trailingAnchor),
            totalTimeLabel.centerYAnchor.constraint(equalTo: workoutMultiplierLabel.centerYAnchor),
            totalTimeLabel.heightAnchor.constraint(equalToConstant: totalTimeLabel.intrinsicContentSize.height),
            totalTimeLabel.widthAnchor.constraint(equalToConstant: totalTimeLabel.intrinsicContentSize.width),
            
            editButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            editButton.widthAnchor.constraint(equalTo: currentWorkoutTableView.widthAnchor, multiplier: editButtonWidthMultiplier),
            editButton.topAnchor.constraint(equalTo: workoutMultiplierLabel.bottomAnchor, constant: editButtonTopConstant),
            
            startButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            startButton.widthAnchor.constraint(equalTo: editButton.widthAnchor),
            startButton.centerYAnchor.constraint(equalTo: editButton.centerYAnchor)
        ])
    }
}

extension WorkoutMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tempWorkouts = WorkoutsController.sharedInstance.totalWorkouts[WorkoutMainViewController.selectedIndex]
        
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
        
        let exercise = tempWorkouts.workouts[indexPath.row]
        cell.titleLabel.text = exercise.name
        cell.titleLabel.font = cell.titleLabel.font.withSize(cell.exerciseView.frame.height/2.5)
        cell.exerciseTimeLabel.text = "Duration: \(exercise.duration)s"
        cell.restTimeLabel.text = "Rest: \(exercise.rest)s"
        cell.exerciseImageView.image = UIImage(named: "\(exercise.image)1")
        cell.restTimeLabel.font = cell.restTimeLabel.font.withSize(cell.restView.frame.height/2)
        
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
            let workouts = WorkoutsController.sharedInstance.totalWorkouts[WorkoutMainViewController.selectedIndex]
            //Object to Set
            destinationVC.workouts = workouts
        }
    }
}
