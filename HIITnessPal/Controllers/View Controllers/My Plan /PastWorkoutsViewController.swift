//
//  PastWorkoutsViewController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class PastWorkoutsViewController: UIViewController {
    
    // Outlets for the PastWorkoutsViewController
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var inactiveUnderlineView: UIView!
    @IBOutlet weak var upcomingButton: UIButton!
    @IBOutlet weak var pastButton: UIButton!
    @IBOutlet weak var planTableView: UITableView!
    @IBOutlet weak var myPlanImageView: UIImageView!
    @IBOutlet weak var myPlanLabel: UILabel!
    
    
    static var fromUpcoming: Bool = false
    static var fromComplete: Bool = false
    
    var tabBarItemOne: UITabBarItem = UITabBarItem()
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        
        // Set the title view's gradient and shadows.
        titleView.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        titleView.layer.masksToBounds = false
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabBarControllerItems = self.tabBarController?.tabBar.items

        if let arrayOfTabBarItems = tabBarControllerItems as AnyObject as? NSArray{

            tabBarItemOne = arrayOfTabBarItems[1] as! UITabBarItem
            tabBarItemOne.isEnabled = false
            tabBarItemOne.title = ""
            tabBarItemOne.image = UIImage()
        }
        
        MainTabBarViewController.fromPast = true
        initialFade()
        if PastWorkoutsViewController.fromUpcoming == false {
            initialFade()
        } else {
            titleLabel.alpha = 1
            PastWorkoutsViewController.fromUpcoming = false
        }
        
        if PastWorkoutsViewController.fromComplete == true {
            initialFade()
            PastWorkoutsViewController.fromComplete = false
        }
        
        planTableView.reloadData()
        viewDidAppear(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.fadeIn()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarItemOne.isEnabled = true
        tabBarItemOne.title = "My Plan"
    }
    
    // Switch back to the UpcominWorkoutsViewController. These two views were embedded in a navigation controller in order to retain the TabBarController at the bottom. Because of this, this view must be popped instead of dismissed.
    @IBAction func upcomingButtonTapped(_ sender: Any) {
        fadeOutToCurrent { (success) in
            if success {
                UpcomingWorkoutsViewController.fromPast = true
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    func initialFade() {
        for sub in self.view.subviews {
            if sub != titleView && sub != myPlanImageView && sub != self.myPlanLabel && sub != self.upcomingButton && sub != self.pastButton && sub != self.underlineView && sub != self.inactiveUnderlineView {
                sub.alpha = 0
            }
        }
        for sub in titleView.subviews {
            sub.alpha = 0
        }
    }
    
    func fadeOut(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.05, animations: {
            for sub in self.view.subviews {
                if sub != self.titleView && sub != self.myPlanImageView && sub != self.myPlanLabel && sub != self.upcomingButton && sub != self.pastButton && sub != self.underlineView && sub != self.inactiveUnderlineView  {
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
    
    func fadeOutToCurrent(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.05, animations: {
            for sub in self.view.subviews {
                if sub != self.titleView && sub != self.myPlanImageView && sub != self.myPlanLabel && sub != self.upcomingButton && sub != self.pastButton && sub != self.underlineView && sub != self.inactiveUnderlineView  {
                    sub.alpha = 0
                }
            }
        }) { (success) in
            completion(success)
        }
    }
    
    func fadeIn() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.05, animations: {
                for sub in self.view.subviews {
                    if sub != self.titleView && sub != self.myPlanImageView && sub != self.myPlanLabel && sub != self.upcomingButton && sub != self.pastButton && sub != self.underlineView && sub != self.inactiveUnderlineView  {
                        sub.alpha = 1
                    }
                }
                for sub in self.titleView.subviews {
                    sub.alpha = 1
                }
            })
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
    
    func setupConstraints() {
        var titleFontSize: CGFloat = 0
        var titleHeightMultiplier: CGFloat = 0
        var backButtonLeadingConstant: CGFloat = 0
        var backButtonBottomConstant: CGFloat = 0
        var backButtonHeightMultiplier: CGFloat = 0
        var titleLabelWidthMultiplier: CGFloat = 0
        var planTableViewBottomConstant: CGFloat = 0
        var myPlanImageViewCenterXConstant: CGFloat = 0
        var myPlanImageViewTopConstant: CGFloat = 0
        var myPlanImageViewHeightConstant: CGFloat = 0
        var myPlanLabelTopConstant: CGFloat = 0
        
        switch (getiPhoneSize().0) {
        case "small":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.7
            
            titleLabelWidthMultiplier = 0.9
            
            planTableViewBottomConstant = -82
            
            myPlanImageViewCenterXConstant = -1*(self.view.frame.width)/8
            myPlanImageViewTopConstant = 10.5
            myPlanImageViewHeightConstant = 50
            
            myPlanLabelTopConstant = 8
        case "medium":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9
            
            planTableViewBottomConstant = -110
            
            myPlanImageViewCenterXConstant = -1*(self.view.frame.width)/8 + 0.5
            myPlanImageViewTopConstant = 24.5
            myPlanImageViewHeightConstant = 50
            
            myPlanLabelTopConstant = 22
        case "large":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9

            planTableViewBottomConstant = -110
            
            myPlanImageViewCenterXConstant = -1*(self.view.frame.width)/8
            myPlanImageViewTopConstant = 26.5
            myPlanImageViewHeightConstant = 50
            
            myPlanLabelTopConstant = 19.5
        case "x":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9

            planTableViewBottomConstant = -110
            
            myPlanImageViewCenterXConstant = -1*(self.view.frame.width)/8
            myPlanImageViewTopConstant = 7.5
            myPlanImageViewHeightConstant = 50
            
            myPlanLabelTopConstant = 5
        case "r":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9

            planTableViewBottomConstant = -110
            
            //myPlanImageViewCenterXConstant = -51.5
            myPlanImageViewCenterXConstant = -1*(self.view.frame.width)/8
            myPlanImageViewTopConstant = 7.5
            myPlanImageViewHeightConstant = 50
            
            myPlanLabelTopConstant = 5
        default:
            print("Something went wrong getting iphone screen size")
        }
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleLabel.font.withSize(titleFontSize)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.isEnabled = false
        
        upcomingButton.translatesAutoresizingMaskIntoConstraints = false
        upcomingButton.setTitle("Workouts", for: .normal)
        
        pastButton.translatesAutoresizingMaskIntoConstraints = false
        
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        inactiveUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        
        planTableView.translatesAutoresizingMaskIntoConstraints = false
        planTableView.layer.borderColor = UIColor.getHIITGray.cgColor
        planTableView.layer.borderWidth = 1
        
        myPlanImageView.translatesAutoresizingMaskIntoConstraints = false
        
        myPlanLabel.translatesAutoresizingMaskIntoConstraints = false
        myPlanLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        myPlanLabel.textColor = UIColor.getHIITPrimaryOrange
        
        
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
            
            inactiveUnderlineView.bottomAnchor.constraint(equalTo: upcomingButton.bottomAnchor),
            inactiveUnderlineView.widthAnchor.constraint(equalTo: upcomingButton.widthAnchor, multiplier: 1.5),
            inactiveUnderlineView.centerXAnchor.constraint(equalTo: upcomingButton.centerXAnchor),
            inactiveUnderlineView.heightAnchor.constraint(equalTo: upcomingButton.heightAnchor, multiplier: 0.1),
            
            underlineView.bottomAnchor.constraint(equalTo: pastButton.bottomAnchor),
            underlineView.widthAnchor.constraint(equalTo: pastButton.widthAnchor, multiplier: 1.5),
            underlineView.centerXAnchor.constraint(equalTo: pastButton.centerXAnchor),
            underlineView.heightAnchor.constraint(equalTo: pastButton.heightAnchor, multiplier: 0.1),
            
            planTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 2),
            planTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: planTableViewBottomConstant),
            planTableView.topAnchor.constraint(equalTo: upcomingButton.bottomAnchor, constant: 11),
            planTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            myPlanImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: myPlanImageViewCenterXConstant),
            myPlanImageView.topAnchor.constraint(equalTo: planTableView.bottomAnchor, constant: myPlanImageViewTopConstant),
            myPlanImageView.heightAnchor.constraint(equalToConstant: myPlanImageViewHeightConstant),
            myPlanImageView.widthAnchor.constraint(equalTo: myPlanImageView.heightAnchor),
            
            myPlanLabel.topAnchor.constraint(equalTo: myPlanImageView.bottomAnchor, constant: myPlanLabelTopConstant),
            myPlanLabel.centerXAnchor.constraint(equalTo: myPlanImageView.centerXAnchor)
        ])
    }
}

extension PastWorkoutsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Set to the total number of workouts
    // TODO: - Needs to be updated to that last used completed workouts.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // TODO: - Add a completedWorkouts array to the workouts controller.
        return CompletedWorkoutsController.sharedInstance.completedWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set the cell to be a PastWorkoutsTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastWorkoutCell", for: indexPath) as! PastWorkoutsTableViewCell
        
        // Pull the correct workout from the given index.
        // TODO: - Pull from the to-be-added completeWorkouts array.
        let workouts = CompletedWorkoutsController.sharedInstance.completedWorkouts[indexPath.row]
        
        // Setup the cell label.
        cell.workoutNameLabel.text = workouts.name
        cell.workoutNameLabel.font = cell.workoutNameLabel.font.withSize(14.5)
        
        cell.borderView.translatesAutoresizingMaskIntoConstraints = false
        cell.borderView.layer.cornerRadius = cell.borderView.frame.height/2
        if indexPath.item % 2 == 0 {
            cell.borderView.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        } else {
            cell.borderView.layer.borderColor = UIColor.getHIITPrimaryBlue.cgColor
        }
        cell.borderView.backgroundColor = UIColor.clear
        cell.borderView.layer.borderWidth = 3
        
        cell.workoutNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cell.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.timeLabel.text = workouts.time
        cell.timeLabel.textAlignment = .center
            
        cell.calorieLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.calorieLabel.text = workouts.calories
        cell.calorieLabel.textAlignment = .center
        
        cell.timeExercisedLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.timeExercisedLabel.textAlignment = .center
        
        cell.caloriesBurnedLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.caloriesBurnedLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            cell.contentView.heightAnchor.constraint(equalToConstant: 55),
            cell.contentView.widthAnchor.constraint(equalTo: cell.widthAnchor),
            cell.contentView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            cell.contentView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            
            cell.borderView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 11),
            cell.borderView.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            cell.borderView.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.95),
            cell.borderView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
        
            cell.workoutNameLabel.leadingAnchor.constraint(equalTo: cell.borderView.leadingAnchor, constant: 11),
            cell.workoutNameLabel.centerYAnchor.constraint(equalTo: cell.borderView.centerYAnchor),
            cell.workoutNameLabel.widthAnchor.constraint(equalTo: cell.borderView.widthAnchor, multiplier: 0.33),
            cell.workoutNameLabel.heightAnchor.constraint(equalToConstant: cell.workoutNameLabel.intrinsicContentSize.height),
            
            cell.timeLabel.centerXAnchor.constraint(equalTo: cell.timeExercisedLabel.centerXAnchor),
            cell.timeLabel.widthAnchor.constraint(equalTo: cell.timeExercisedLabel.widthAnchor),
            cell.timeLabel.heightAnchor.constraint(equalToConstant: cell.timeLabel.intrinsicContentSize.height),
            cell.timeLabel.topAnchor.constraint(equalTo: cell.borderView.topAnchor, constant: 6),
            
            cell.calorieLabel.centerXAnchor.constraint(equalTo: cell.caloriesBurnedLabel.centerXAnchor),
            cell.calorieLabel.widthAnchor.constraint(equalTo: cell.caloriesBurnedLabel.widthAnchor),
            cell.calorieLabel.heightAnchor.constraint(equalToConstant: cell.calorieLabel.intrinsicContentSize.height),
            cell.calorieLabel.topAnchor.constraint(equalTo: cell.borderView.topAnchor, constant: 6),
        
             cell.timeExercisedLabel.leadingAnchor.constraint(equalTo: cell.workoutNameLabel  .trailingAnchor, constant: 2),
            cell.timeExercisedLabel.widthAnchor.constraint(equalToConstant: cell.timeExercisedLabel.intrinsicContentSize.width),
            cell.timeExercisedLabel.heightAnchor.constraint(equalToConstant: cell.timeExercisedLabel.intrinsicContentSize.height),
            cell.timeExercisedLabel.topAnchor.constraint(equalTo: cell.timeLabel.bottomAnchor),
        
            cell.caloriesBurnedLabel.leadingAnchor.constraint(equalTo: cell.timeExercisedLabel.trailingAnchor, constant: 7),
            cell.caloriesBurnedLabel.widthAnchor.constraint(equalToConstant: cell.caloriesBurnedLabel.intrinsicContentSize.width),
            cell.caloriesBurnedLabel.heightAnchor.constraint(equalToConstant: cell.caloriesBurnedLabel.intrinsicContentSize.height),
            cell.caloriesBurnedLabel.topAnchor.constraint(equalTo: cell.calorieLabel.bottomAnchor),
        ])
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        // Return the cell.
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {            
            // Pull the Appropriate storyboard with the needed view controller.
            let storyboard = UIStoryboard(name: "HiitnessWorkout", bundle: nil)
            // Set our viewController as the CreateWorkoutViewController.
            let viewController = storyboard.instantiateViewController(withIdentifier: "workoutView") as! WorkoutCompleteViewController
            
            viewController.modalPresentationStyle = .fullScreen
            
            let workouts = CompletedWorkoutsController.sharedInstance.completedWorkouts[indexPath.row]
            viewController.completedWorkout = workouts
            
            // Present the viewController outside of the navigation controller so as not to carry on the tab bar controller.
            self.fadeOut { (success) in
                if success {
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
}
