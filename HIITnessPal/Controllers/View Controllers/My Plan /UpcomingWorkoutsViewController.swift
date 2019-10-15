//
//  UpcomingWorkoutsViewController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class UpcomingWorkoutsViewController: UIViewController {
    
    // Outlets for the SelectWorkoutViewController
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var inactiveUnderlineView: UIView!
    @IBOutlet weak var upcomingButton: UIButton!
    @IBOutlet weak var pastButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var selectWorkoutLabel: UILabel!
    @IBOutlet weak var planTableView: UITableView!
    
    var tabBarItemOne: UITabBarItem = UITabBarItem()
    var workout: [Workout] = []
    static var fromPast: Bool = false
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This viewController is embedded in a navigation controller.
        // Hide the NavigationBar.
        self.navigationController?.isNavigationBarHidden = true
        
        setupConstraints()
        
        // Set the title view gradients and shadow.
        titleView.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        titleView.layer.masksToBounds = false
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // Set this view controller to be the associated tableView's delegate and dataSource. These were typically declared on the storyboards, this is declared here to help debug a problem earlier on.
        planTableView.delegate = self
        planTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MainTabBarViewController.fromPast = false
        
        let tabBarControllerItems = self.tabBarController?.tabBar.items

        if let arrayOfTabBarItems = tabBarControllerItems as AnyObject as? NSArray{

            tabBarItemOne = arrayOfTabBarItems[1] as! UITabBarItem
            tabBarItemOne.title = "My Plan"
        }
        
        // Reload the table view's data whenever the view loads.
        if UpcomingWorkoutsViewController.fromPast == false {
            initialFade()
        }
        planTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UpcomingWorkoutsViewController.fromPast {
            fadeInFromPast()
            UpcomingWorkoutsViewController.fromPast = false
        } else {
            fadeIn()
        }
    }
    
    override func viewWillLayoutSubviews() {
        var height: CGFloat = 0
        switch (getiPhoneSize().0) {
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
    
    @IBAction func pastButtonTapped(_ sender: Any) {
        // Pull the Appropriate storyboard with the needed view controller.
        let storyboard = UIStoryboard(name: "MyHiitnessPlan", bundle: nil)
        // Set our viewController as the PastWorkoutsViewController.
        let viewController = storyboard.instantiateViewController(withIdentifier: "PastWorkoutsStoryboard")
        viewController.modalPresentationStyle = .fullScreen
        // Navigate to the viewController through the navigation controller.
        fadeOutToPast { (success) in
            if success {
                PastWorkoutsViewController.fromUpcoming = true
                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }
    }
    
    @IBAction func createButtonWorkoutTapped(_ sender: Any) {
        // Pull the Appropriate storyboard with the needed view controller.
        let storyboard = UIStoryboard(name: "MyHiitnessPlan", bundle: nil)
        // Set our viewController as the CreateWorkoutViewController.
        let viewController = storyboard.instantiateViewController(withIdentifier: "CreateWorkoutStoryboard")
        viewController.modalPresentationStyle = .fullScreen
        // Present the viewController outside of the navigation controller so as not to carry on the tab bar controller.
        fadeOut { (success) in
            if success {
                self.present(viewController, animated: false, completion: nil)
            }
        }
    }
    
    func getiPhoneSize () -> (String, Int) {
        switch( self.view.frame.height) {
        case 568:
            return ("small", 568)
        case 667:
            return ("medium", 667)
        case 736:
            return ("large", 736)
        case 812:
            return ("x", 812)
        case 896:
            return ("r", 896)
        default:
            print("...")
            print("---")
            print(self.view.frame.height)
            print("---")
            print("...")
        }
        return ("", 0)
    }
    
    func initialFade() {
        for sub in self.view.subviews {
            if sub != titleView && sub != self.upcomingButton && sub != self.pastButton && sub != self.underlineView && sub != self.inactiveUnderlineView {
                sub.alpha = 0
            }
        }
        for sub in titleView.subviews {
            sub.alpha = 0
        }
    }
    
    func fadeOut(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.01, animations: {
            for sub in self.view.subviews {
                if sub != self.titleView && sub != self.upcomingButton && sub != self.pastButton && sub != self.underlineView && sub != self.inactiveUnderlineView  {
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
    
    func fadeOutToPast(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            for sub in self.view.subviews {
                if sub != self.titleView && sub != self.upcomingButton && sub != self.pastButton && sub != self.underlineView && sub != self.inactiveUnderlineView  {
                    sub.alpha = 0
                }
            }
        }) { (success) in
            completion(success)
        }
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.2) {
            for sub in self.view.subviews {
                if sub != self.titleView  {
                    sub.alpha = 1
                }
            }
            for sub in self.titleView.subviews {
                sub.alpha = 1
            }
        }
    }
    
    func fadeInFromPast() {
        UIView.animate(withDuration: 0.2, animations: {
            for sub in self.view.subviews {
                if sub != self.titleView && sub != self.upcomingButton && sub != self.pastButton && sub != self.underlineView && sub != self.inactiveUnderlineView  {
                    sub.alpha = 1
                }
            }
        })
    }
    
    func setupConstraints() {
        var titleFontSize: CGFloat = 0
        var titleHeightMultiplier: CGFloat = 0
        var backButtonLeadingConstant: CGFloat = 0
        var backButtonBottomConstant: CGFloat = 0
        var backButtonHeightMultiplier: CGFloat = 0
        var titleLabelWidthMultiplier: CGFloat = 0
        var planTableViewBottomConstant: CGFloat = 0
        
        switch (getiPhoneSize().0) {
        case "small":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.7
            
            titleLabelWidthMultiplier = 0.9
            
            planTableViewBottomConstant = -82
            
        case "medium":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9
            
            planTableViewBottomConstant = -110
            
        case "large":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9
            
            planTableViewBottomConstant = -110

        case "x":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9
            
            planTableViewBottomConstant = -110

        case "r":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9
            
            planTableViewBottomConstant = -110

        default:
            print("Something went wrong getting iphone screen size")
        }
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleLabel.font.withSize(titleFontSize)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        upcomingButton.translatesAutoresizingMaskIntoConstraints = false
        upcomingButton.setTitle("Workouts", for: .normal)
        
        pastButton.translatesAutoresizingMaskIntoConstraints = false
        
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        inactiveUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        selectWorkoutLabel.translatesAutoresizingMaskIntoConstraints = false
        
        planTableView.translatesAutoresizingMaskIntoConstraints = false
        planTableView.layer.borderColor = UIColor.getHIITGray.cgColor
        planTableView.layer.borderWidth = 1
        
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
            
            upcomingButton.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 22),
            upcomingButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 33),
            upcomingButton.widthAnchor.constraint(equalToConstant: upcomingButton.intrinsicContentSize.width),
            upcomingButton.heightAnchor.constraint(equalToConstant: upcomingButton.intrinsicContentSize.height),
            
            pastButton.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 22),
            pastButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -33),
            pastButton.widthAnchor.constraint(equalTo: upcomingButton.widthAnchor),
            pastButton.heightAnchor.constraint(equalTo: upcomingButton.heightAnchor),
            
            underlineView.bottomAnchor.constraint(equalTo: upcomingButton.bottomAnchor),
            underlineView.widthAnchor.constraint(equalTo: upcomingButton.widthAnchor, multiplier: 1.5),
            underlineView.centerXAnchor.constraint(equalTo: upcomingButton.centerXAnchor),
            underlineView.heightAnchor.constraint(equalTo: upcomingButton.heightAnchor, multiplier: 0.1),
            
            inactiveUnderlineView.bottomAnchor.constraint(equalTo: pastButton.bottomAnchor),
            inactiveUnderlineView.widthAnchor.constraint(equalTo: pastButton.widthAnchor, multiplier: 1.5),
            inactiveUnderlineView.centerXAnchor.constraint(equalTo: pastButton.centerXAnchor),
            inactiveUnderlineView.heightAnchor.constraint(equalTo: pastButton.heightAnchor, multiplier: 0.1),
            
            createButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            createButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),
            createButton.heightAnchor.constraint(equalTo: upcomingButton.heightAnchor, multiplier: 0.85),
            createButton.topAnchor.constraint(equalTo: upcomingButton.bottomAnchor, constant: 16),
            
            selectWorkoutLabel.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 16),
            selectWorkoutLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            selectWorkoutLabel.widthAnchor.constraint(equalToConstant: selectWorkoutLabel.intrinsicContentSize.width),
            selectWorkoutLabel.heightAnchor.constraint(equalToConstant: selectWorkoutLabel.intrinsicContentSize.height),
            
            planTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 2),
            planTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: planTableViewBottomConstant),
            planTableView.topAnchor.constraint(equalTo: selectWorkoutLabel.bottomAnchor, constant: 5),
            planTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
            
        ])
    }
    
    func absoluteValue(number: Double) -> Double {
        if number < 0 {
            return -number
        } else {
            return number
        }
    }
}

extension UpcomingWorkoutsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Set the number of rows to be the total number of workouts created.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutsController.sharedInstance.totalWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set the cell as an UpcomingWorkoutsTableViewCell.
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingWorkoutCell", for: indexPath) as! UpcomingWorkoutsTableViewCell
        
        // Select the specific workout for each cell.
        let workout = WorkoutsController.sharedInstance.totalWorkouts[indexPath.row]
        
        // Set the correct labels for the cell. based on the workout.
        cell.workoutNameLabel.text = workout.name
        cell.workout1Label.text = workout.workouts[0].name
        cell.workout2Label.text = workout.workouts[1].name
        cell.workout3Label.text = workout.workouts[2].name
        cell.workout4Label.text = workout.workouts[3].name
        
        // Calculate the time to be displayed
        // Place holder for the total time.
        var totalTime: Int = 0
        // Total the duration and rest time for each exercise in the workout.
        for exercise in workout.workouts {
            totalTime += exercise.duration + exercise.rest
        }
        // Factor in the multiplier.
        totalTime *= workout.multiplier
        // Setup the minutes and seconds label.
        let minutesLabel = "\(totalTime/60)"
        let secondsLabel = "\(totalTime%60)"
        // Set the labels in the cell's totalTimeLabel.
        cell.totalTimeLabel.text = "\(minutesLabel):\(secondsLabel)"
        cell.calorieCount.text = "\(absoluteValue(number: Double(Int(HealthKitController.sharedInstance.getCaloriesBurned(durationOfWorkoutInMinutes: Double(totalTime)/60)*100))/100))"
        
        // Set the cells borders
        //cell.layer.cornerRadius = cell.frame.height/5
        //cell.layer.borderColor = UIColor.getHIITGray.cgColor
        //cell.layer.borderWidth = 2
        
        switch (getiPhoneSize().0) {
        case "small":
            print("waiting for constants")
        case "medium":
            print("waiting for constants")
        case "large":
            print("waiting for constants")
        case "x":
            print("waiting for constants")
        case "r":
            print("waiting for constants")
        default:
            print("Something went wrong getting iphone screen size")
        }
        
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.borderView.translatesAutoresizingMaskIntoConstraints = false
        if indexPath.item % 2 == 0 {
            cell.borderView.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
            cell.borderView.layer.borderWidth = 3
        } else {
            cell.borderView.layer.borderColor = UIColor.getHIITPrimaryBlue.cgColor
            cell.borderView.layer.borderWidth = 3
        }
        cell.borderView.layer.cornerRadius = cell.borderView.frame.height/3.5
    
        cell.workoutNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cell.workout1Label.translatesAutoresizingMaskIntoConstraints = false
        cell.workout1UnderlineView.translatesAutoresizingMaskIntoConstraints = false
        if indexPath.item % 2 == 0 {
            cell.workout1UnderlineView.backgroundColor = UIColor.getHIITPrimaryBlue
        } else {
            cell.workout1UnderlineView.backgroundColor = UIColor.getHIITPrimaryOrange
        }
        
        cell.workout2Label.translatesAutoresizingMaskIntoConstraints = false
        cell.workout2UnderlineView.translatesAutoresizingMaskIntoConstraints = false
        if indexPath.item % 2 == 0 {
            cell.workout2UnderlineView.backgroundColor = UIColor.getHIITPrimaryBlue
        } else {
            cell.workout2UnderlineView.backgroundColor = UIColor.getHIITPrimaryOrange
        }
        
        cell.workout3Label.translatesAutoresizingMaskIntoConstraints = false
        cell.workout3UnderlineView.translatesAutoresizingMaskIntoConstraints = false
        if indexPath.item % 2 == 0 {
            cell.workout3UnderlineView.backgroundColor = UIColor.getHIITPrimaryBlue
        } else {
            cell.workout3UnderlineView.backgroundColor = UIColor.getHIITPrimaryOrange
        }
        
        cell.workout4Label.translatesAutoresizingMaskIntoConstraints = false
        cell.workout4UnderlineView.translatesAutoresizingMaskIntoConstraints = false
        if indexPath.item % 2 == 0 {
            cell.workout4UnderlineView.backgroundColor = UIColor.getHIITPrimaryBlue
        } else {
            cell.workout4UnderlineView.backgroundColor = UIColor.getHIITPrimaryOrange
        }
        
        cell.totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.totalTimeLabel.textAlignment = .center
        
        cell.time.translatesAutoresizingMaskIntoConstraints = false
        cell.time.font = cell.time.font.withSize(12)
        
        cell.calorieCount.translatesAutoresizingMaskIntoConstraints = false
        cell.calorieCount.textAlignment = .center
        
        cell.cal.translatesAutoresizingMaskIntoConstraints = false
        cell.cal.font = cell.cal.font.withSize(12)
        cell.cal.text = "Calories"
        
        NSLayoutConstraint.activate([
            cell.contentView.heightAnchor.constraint(equalToConstant: 200),
            cell.contentView.widthAnchor.constraint(equalTo: cell.widthAnchor),
            cell.contentView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            cell.contentView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            
            cell.borderView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 11),
            cell.borderView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -11),
            cell.borderView.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.9),
            cell.borderView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            
            cell.workoutNameLabel.topAnchor.constraint(equalTo: cell.borderView.topAnchor, constant: 11),
            cell.workoutNameLabel.centerXAnchor.constraint(equalTo: cell.borderView.centerXAnchor),
            cell.workoutNameLabel.heightAnchor.constraint(equalToConstant: cell.workoutNameLabel.intrinsicContentSize.height),
            cell.workoutNameLabel.widthAnchor.constraint(equalTo: cell.borderView.widthAnchor, multiplier: 0.9),
            
            cell.workout1UnderlineView.widthAnchor.constraint(equalTo: cell.borderView.widthAnchor, multiplier: 0.4),
            cell.workout1UnderlineView.leadingAnchor.constraint(equalTo: cell.workoutNameLabel.leadingAnchor),
            cell.workout1UnderlineView.topAnchor.constraint(equalTo: cell.workoutNameLabel.bottomAnchor, constant: 30),
            cell.workout1UnderlineView.heightAnchor.constraint(equalToConstant: 3),
            
            cell.workout1Label.centerXAnchor.constraint(equalTo: cell.workout1UnderlineView.centerXAnchor),
            cell.workout1Label.bottomAnchor.constraint(equalTo: cell.workout1UnderlineView.topAnchor),
            
            cell.workout2UnderlineView.widthAnchor.constraint(equalTo: cell.borderView.widthAnchor, multiplier: 0.4),
            cell.workout2UnderlineView.trailingAnchor.constraint(equalTo: cell.workoutNameLabel.trailingAnchor),
            cell.workout2UnderlineView.topAnchor.constraint(equalTo: cell.workoutNameLabel.bottomAnchor, constant: 30),
            cell.workout2UnderlineView.heightAnchor.constraint(equalToConstant: 3),
            
            cell.workout2Label.centerXAnchor.constraint(equalTo: cell.workout2UnderlineView.centerXAnchor),
            cell.workout2Label.bottomAnchor.constraint(equalTo: cell.workout2UnderlineView.topAnchor),
            
            cell.workout3UnderlineView.widthAnchor.constraint(equalTo: cell.borderView.widthAnchor, multiplier: 0.4),
            cell.workout3UnderlineView.leadingAnchor.constraint(equalTo: cell.workoutNameLabel.leadingAnchor),
            cell.workout3UnderlineView.topAnchor.constraint(equalTo: cell.workout1UnderlineView.bottomAnchor, constant: 30),
            cell.workout3UnderlineView.heightAnchor.constraint(equalToConstant: 3),
            
            cell.workout3Label.centerXAnchor.constraint(equalTo: cell.workout3UnderlineView.centerXAnchor),
            cell.workout3Label.bottomAnchor.constraint(equalTo: cell.workout3UnderlineView.topAnchor),
            
            cell.workout4UnderlineView.widthAnchor.constraint(equalTo: cell.borderView.widthAnchor, multiplier: 0.4),
            cell.workout4UnderlineView.trailingAnchor.constraint(equalTo: cell.workoutNameLabel.trailingAnchor),
            cell.workout4UnderlineView.topAnchor.constraint(equalTo: cell.workout2UnderlineView.bottomAnchor, constant: 30),
            cell.workout4UnderlineView.heightAnchor.constraint(equalToConstant: 3),
            
            cell.workout4Label.centerXAnchor.constraint(equalTo: cell.workout4UnderlineView.centerXAnchor),
            cell.workout4Label.bottomAnchor.constraint(equalTo: cell.workout4UnderlineView.topAnchor),
            
            cell.totalTimeLabel.leadingAnchor.constraint(equalTo: cell.workoutNameLabel.leadingAnchor),
            cell.totalTimeLabel.widthAnchor.constraint(equalTo: cell.workout1UnderlineView.widthAnchor),
            cell.totalTimeLabel.topAnchor.constraint(equalTo: cell.workout3UnderlineView.bottomAnchor, constant: 16),
            
            cell.calorieCount.trailingAnchor.constraint(equalTo: cell.workoutNameLabel.trailingAnchor),
            cell.calorieCount.widthAnchor.constraint(equalTo: cell.workout2UnderlineView
                .widthAnchor),
            cell.calorieCount.topAnchor.constraint(equalTo: cell.workout4UnderlineView.bottomAnchor, constant: 16),
            
            cell.time.centerXAnchor.constraint(equalTo: cell.totalTimeLabel.centerXAnchor),
            cell.time.topAnchor.constraint(equalTo: cell.totalTimeLabel.bottomAnchor),
            
            cell.cal.centerXAnchor.constraint(equalTo: cell.calorieCount.centerXAnchor),
            cell.cal.topAnchor.constraint(equalTo: cell.calorieCount.bottomAnchor)
        ])
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        // Return the cell.
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let workout = WorkoutsController.sharedInstance.totalWorkouts[indexPath.row]
            
            // Pull the Appropriate storyboard with the needed view controller.
            let storyboard = UIStoryboard(name: "HiitnessWorkout", bundle: nil)
            // Set our viewController as the CreateWorkoutViewController.
            let viewController = storyboard.instantiateViewController(withIdentifier: "editViewController") as! WorkoutEditViewController
            
            viewController.modalPresentationStyle = .fullScreen
            
            viewController.workouts = workout
            
            
            // Present the viewController outside of the navigation controller so as not to carry on the tab bar controller.
            self.fadeOut { (success) in
                if success {
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
    }
}
