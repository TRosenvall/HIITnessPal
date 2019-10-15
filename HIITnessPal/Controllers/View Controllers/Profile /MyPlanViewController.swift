//
//  MyPlanViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class MyPlanViewController: UIViewController {

    // Setup IBOutlets
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var myPlanLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var idealPlanLabel: UILabel!
    @IBOutlet weak var idealPlanSlider: UISlider!
    @IBOutlet weak var chillLabel: UILabel!
    @IBOutlet weak var regularLabel: UILabel!
    @IBOutlet weak var intenseLabel: UILabel!
    @IBOutlet weak var recommendedPlanView: UIView!
    @IBOutlet weak var planImageView: UIImageView!
    @IBOutlet weak var weSuggestLabel: UILabel!
    @IBOutlet weak var scheduleImageView: UIImageView!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var workoutsInAWeekLabel: UILabel!
    @IBOutlet weak var averageWorkoutLengthLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var preferenceLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    let profile = ProfileController.sharedInstance.profile
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        
        // Set the title views gradient and shadow.
        titleView.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        titleView.layer.masksToBounds = false
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)

        // Set the progressView, backButton, nextButton, and preferenceLabel for first time users
        guard let profile = profile else {return}
        if profile.firstLogin {
            progressView.isHidden = false
            doneButton.isHidden = false
            preferenceLabel.isHidden = false
        } else {
            progressView.isHidden = true
            preferenceLabel.isHidden = true
            doneButton.setTitle("Save", for: .normal)
        }
        
        // Set idealPlanSlider
        idealPlanSlider.value = Float(profile.idealPlan)
        workoutsInAWeekLabel.text = "\(Int(idealPlanSlider.value + 1)) Workouts Every Week"
        minutesLabel.text = "\(Int((idealPlanSlider.value*5) + 15)) Minutes"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialFade()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fadeIn()
    }
    
    // Dismiss the viewController when the back button is tapped.
    @IBAction func backButtonTapped(_ sender: Any) {
        fadeOut { (success) in
            if success {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    // Dismiss the view controller when the done botton is tapped.
    @IBAction func doneButtonTapped(_ sender: Any) {
        // Update the profile to indicate it's not the first login, set the idealPlan, and then take you back to the dashboard.
        guard let profile = profile else {return}
        ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: Int(idealPlanSlider.value), reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
        if profile.firstLogin {
            ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: false, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
            fadeOut { (success) in
                if success {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                }
            }
        } else {
            fadeOut { (success) in
                if success {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    @IBAction func idealPlanSliderValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        
        workoutsInAWeekLabel.text = "\(Int(roundedValue + 1)) Workouts Every Week"
        minutesLabel.text = "\(Int((roundedValue*5) + 15)) Minutes"
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
    
    func setupConstraints () {
        
        var titleFontSize: CGFloat = 0
        var titleHeightMultiplier: CGFloat = 0
        var backButtonLeadingConstant: CGFloat = 0
        var backButtonBottomConstant: CGFloat = 0
        var backButtonHeightMultiplier: CGFloat = 0
        var myPlanLabelWidthMultiplier: CGFloat = 0
        var myPlanLabelbottomConstant: CGFloat = 0
        var progressViewBottomConstant: CGFloat = 0
        var progressViewWidthMultiplier: CGFloat = 0
        var idealPlanTopConstant: CGFloat = 0
        var idealPlanSliderLeadingConstant: CGFloat = 0
        var idealPlanSliderTrailingConstant: CGFloat = 0
        var idealPlanSliderTopConstant: CGFloat = 0
        var idealPlanSliderHeightConstant: CGFloat = 0
        var idealPlanSliderWidthMultiplier: CGFloat = 0
        var idealPlanSliderBottomConstant: CGFloat = 0
        var intenseLabelWidthMultiplier: CGFloat = 0
        var intenseLabelTopConstant: CGFloat = 0
        var regularLabelTopConstant: CGFloat = 0
        var recommendedPlanViewTopConstant: CGFloat = 0
        var recommendedPlanViewHeightMultiplier: CGFloat = 0
        var recommendedPlanViewWidthMultiplier: CGFloat = 0
        var planImageViewTopConstant: CGFloat = 0
        var planImageViewLeadingConstant: CGFloat = 0
        var planImageViewWidthConstant: CGFloat = 0
        var scheduleImageViewLeadingConstant: CGFloat = 0
        var scheduleImageViewWidthConstant: CGFloat = 0
        var weSuggestLabelLeadingConstant: CGFloat = 0
        var weSuggestLabelTrailingConstant: CGFloat = 0
        var scheduleLabelLeadingConstant: CGFloat = 0
        var workoutsInAWeekLabelLeadingConstant: CGFloat = 0
        var workoutsInAWeekLabelTrailingConstant: CGFloat = 0
        var averageWorkoutLengthLabelBottomConstant: CGFloat = 0
        var minutesLabelLeadingConstant: CGFloat = 0
        var minutesLabelTrailingConstant: CGFloat = 0
        var doneButtonWidthMultiplier: CGFloat = 0
        var doneButtonHeightConstant: CGFloat = 0
        var doneButtonBottomConstant: CGFloat = 0
        var preferenceLabelBottomConstant: CGFloat = 0
        
        switch (getiPhoneSize()) {
        case "small":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.7
            
            myPlanLabelWidthMultiplier = 0.5
            if profile?.firstLogin == true {
                myPlanLabelbottomConstant = -5
            } else {
                myPlanLabelbottomConstant = 0
            }
            progressViewBottomConstant = -8
            progressViewWidthMultiplier = 0.5
            
            idealPlanTopConstant = 22
            idealPlanSliderLeadingConstant = 22
            idealPlanSliderTrailingConstant = -22
            idealPlanSliderTopConstant = 22
            idealPlanSliderHeightConstant = 44
            idealPlanSliderWidthMultiplier = 0.25
            idealPlanSliderBottomConstant = 11
            intenseLabelWidthMultiplier = 0.25
            intenseLabelTopConstant = 11
            regularLabelTopConstant = 11
            
            recommendedPlanViewTopConstant = 44
            recommendedPlanViewHeightMultiplier = 0.2
            recommendedPlanViewWidthMultiplier = 0.9
            planImageViewTopConstant = 22
            planImageViewLeadingConstant = 11
            planImageViewWidthConstant = 22
            scheduleImageViewLeadingConstant = 11
            scheduleImageViewWidthConstant = 22
            weSuggestLabelLeadingConstant = 10
            weSuggestLabelTrailingConstant = -11
            scheduleLabelLeadingConstant = 11
            workoutsInAWeekLabelLeadingConstant = 11
            workoutsInAWeekLabelTrailingConstant = -11
            averageWorkoutLengthLabelBottomConstant = -22
            minutesLabelLeadingConstant = 11
            minutesLabelTrailingConstant = -11
            workoutsInAWeekLabel.adjustsFontSizeToFitWidth = true
            minutesLabel.adjustsFontSizeToFitWidth = true
            
            doneButtonWidthMultiplier = 0.4
            doneButtonHeightConstant = 44
            doneButtonBottomConstant = -44
            preferenceLabelBottomConstant = -22
        case "medium":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            myPlanLabelWidthMultiplier = 0.5
            if profile?.firstLogin == true {
                myPlanLabelbottomConstant = -8
            } else {
                myPlanLabelbottomConstant = 0
            }
            progressViewBottomConstant = -11
            progressViewWidthMultiplier = 0.5
            
            idealPlanTopConstant = 44
            idealPlanSliderLeadingConstant = 22
            idealPlanSliderTrailingConstant = -22
            idealPlanSliderTopConstant = 22
            idealPlanSliderHeightConstant = 44
            idealPlanSliderWidthMultiplier = 0.25
            idealPlanSliderBottomConstant = 11
            intenseLabelWidthMultiplier = 0.25
            intenseLabelTopConstant = 11
            regularLabelTopConstant = 11
            
            recommendedPlanViewTopConstant = 50
            recommendedPlanViewHeightMultiplier = 0.2
            recommendedPlanViewWidthMultiplier = 0.9
            planImageViewTopConstant = 22
            planImageViewLeadingConstant = 22
            planImageViewWidthConstant = 22
            scheduleImageViewLeadingConstant = 22
            scheduleImageViewWidthConstant = 22
            weSuggestLabelLeadingConstant = 10
            weSuggestLabelTrailingConstant = -11
            scheduleLabelLeadingConstant = 11
            workoutsInAWeekLabelLeadingConstant = 11
            workoutsInAWeekLabelTrailingConstant = -11
            averageWorkoutLengthLabelBottomConstant = -22
            minutesLabelLeadingConstant = 11
            minutesLabelTrailingConstant = -11
            
            doneButtonWidthMultiplier = 0.4
            doneButtonHeightConstant = 44
            doneButtonBottomConstant = -44
            preferenceLabelBottomConstant = -22
        case "large":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            myPlanLabelWidthMultiplier = 0.5
            if profile?.firstLogin == true {
                myPlanLabelbottomConstant = -12
            } else {
                myPlanLabelbottomConstant = 0
            }
            progressViewBottomConstant = -17
            progressViewWidthMultiplier = 0.5
            
            idealPlanTopConstant = 49
            idealPlanSliderLeadingConstant = 22
            idealPlanSliderTrailingConstant = -22
            idealPlanSliderTopConstant = 22
            idealPlanSliderHeightConstant = 44
            idealPlanSliderWidthMultiplier = 0.25
            idealPlanSliderBottomConstant = 11
            intenseLabelWidthMultiplier = 0.25
            intenseLabelTopConstant = 11
            regularLabelTopConstant = 11
            
            recommendedPlanViewTopConstant = 50
            recommendedPlanViewHeightMultiplier = 0.2
            recommendedPlanViewWidthMultiplier = 0.9
            planImageViewTopConstant = 22
            planImageViewLeadingConstant = 22
            planImageViewWidthConstant = 22
            scheduleImageViewLeadingConstant = 22
            scheduleImageViewWidthConstant = 22
            weSuggestLabelLeadingConstant = 10
            weSuggestLabelTrailingConstant = -11
            scheduleLabelLeadingConstant = 11
            workoutsInAWeekLabelLeadingConstant = 11
            workoutsInAWeekLabelTrailingConstant = -11
            averageWorkoutLengthLabelBottomConstant = -22
            minutesLabelLeadingConstant = 11
            minutesLabelTrailingConstant = -11
            
            doneButtonWidthMultiplier = 0.4
            doneButtonHeightConstant = 44
            doneButtonBottomConstant = -44
            preferenceLabelBottomConstant = -22
        case "x":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            myPlanLabelWidthMultiplier = 0.5
            if profile?.firstLogin == true {
                myPlanLabelbottomConstant = -9
            } else {
                myPlanLabelbottomConstant = 0
            }
            progressViewBottomConstant = -17
            progressViewWidthMultiplier = 0.5
            
            idealPlanTopConstant = 99
            idealPlanSliderLeadingConstant = 22
            idealPlanSliderTrailingConstant = -22
            idealPlanSliderTopConstant = 22
            idealPlanSliderHeightConstant = 44
            idealPlanSliderWidthMultiplier = 0.25
            idealPlanSliderBottomConstant = 11
            intenseLabelWidthMultiplier = 0.25
            intenseLabelTopConstant = 11
            regularLabelTopConstant = 11
            
            recommendedPlanViewTopConstant = 100
            recommendedPlanViewHeightMultiplier = 0.2
            recommendedPlanViewWidthMultiplier = 0.9
            planImageViewTopConstant = 22
            planImageViewLeadingConstant = 22
            planImageViewWidthConstant = 22
            scheduleImageViewLeadingConstant = 22
            scheduleImageViewWidthConstant = 22
            weSuggestLabelLeadingConstant = 10
            weSuggestLabelTrailingConstant = -11
            scheduleLabelLeadingConstant = 11
            workoutsInAWeekLabelLeadingConstant = 11
            workoutsInAWeekLabelTrailingConstant = -11
            averageWorkoutLengthLabelBottomConstant = -22
            minutesLabelLeadingConstant = 11
            minutesLabelTrailingConstant = -11
            
            doneButtonWidthMultiplier = 0.4
            doneButtonHeightConstant = 44
            doneButtonBottomConstant = -44
            preferenceLabelBottomConstant = -22
        case "r":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            myPlanLabelWidthMultiplier = 0.5
            if profile?.firstLogin == true {
                myPlanLabelbottomConstant = -9
            } else {
                myPlanLabelbottomConstant = 0
            }
            progressViewBottomConstant = -17
            progressViewWidthMultiplier = 0.5
            
            idealPlanTopConstant = 99
            idealPlanSliderLeadingConstant = 22
            idealPlanSliderTrailingConstant = -22
            idealPlanSliderTopConstant = 22
            idealPlanSliderHeightConstant = 44
            idealPlanSliderWidthMultiplier = 0.25
            idealPlanSliderBottomConstant = 11
            intenseLabelWidthMultiplier = 0.25
            intenseLabelTopConstant = 11
            regularLabelTopConstant = 11
            
            recommendedPlanViewTopConstant = 100
            recommendedPlanViewHeightMultiplier = 0.2
            recommendedPlanViewWidthMultiplier = 0.9
            planImageViewTopConstant = 22
            planImageViewLeadingConstant = 22
            planImageViewWidthConstant = 22
            scheduleImageViewLeadingConstant = 22
            scheduleImageViewWidthConstant = 22
            weSuggestLabelLeadingConstant = 10
            weSuggestLabelTrailingConstant = -11
            scheduleLabelLeadingConstant = 11
            workoutsInAWeekLabelLeadingConstant = 11
            workoutsInAWeekLabelTrailingConstant = -11
            averageWorkoutLengthLabelBottomConstant = -22
            minutesLabelLeadingConstant = 11
            minutesLabelTrailingConstant = -11
            
            doneButtonWidthMultiplier = 0.4
            doneButtonHeightConstant = 44
            doneButtonBottomConstant = -44
            preferenceLabelBottomConstant = -22
        default:
            print("Something went wrong in getting the screen size")
        }
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        myPlanLabel.translatesAutoresizingMaskIntoConstraints = false
        myPlanLabel.font = myPlanLabel.font.withSize(titleFontSize)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        idealPlanLabel.translatesAutoresizingMaskIntoConstraints = false
        idealPlanSlider.translatesAutoresizingMaskIntoConstraints = false
        chillLabel.translatesAutoresizingMaskIntoConstraints = false
        intenseLabel.translatesAutoresizingMaskIntoConstraints = false
        intenseLabel.textAlignment = .right
        regularLabel.translatesAutoresizingMaskIntoConstraints = false
        regularLabel.textAlignment = .center
        recommendedPlanView.translatesAutoresizingMaskIntoConstraints = false
        planImageView.translatesAutoresizingMaskIntoConstraints = false
        scheduleImageView.translatesAutoresizingMaskIntoConstraints = false
        weSuggestLabel.translatesAutoresizingMaskIntoConstraints = false
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        workoutsInAWeekLabel.translatesAutoresizingMaskIntoConstraints = false
        averageWorkoutLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        minutesLabel.translatesAutoresizingMaskIntoConstraints = false
        preferenceLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.backgroundColor = UIColor.getHIITAccentOrange
        
        NSLayoutConstraint.activate([
            
            titleView.topAnchor.constraint(equalTo: self.view.topAnchor),
            titleView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: titleHeightMultiplier),
            titleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: backButtonLeadingConstant),
            backButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: backButtonBottomConstant),
            backButton.heightAnchor.constraint(equalToConstant: titleView.frame.size.height * backButtonHeightMultiplier),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            myPlanLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            myPlanLabel.widthAnchor.constraint(equalTo: titleView.widthAnchor, multiplier: myPlanLabelWidthMultiplier),
            myPlanLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: myPlanLabelbottomConstant),
            
            progressView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            progressView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: progressViewBottomConstant),
            progressView.widthAnchor.constraint(equalTo: titleView.widthAnchor, multiplier: progressViewWidthMultiplier),
            
            idealPlanLabel.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            idealPlanLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            idealPlanLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: idealPlanTopConstant),
            
            idealPlanSlider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: idealPlanSliderLeadingConstant),
            idealPlanSlider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: idealPlanSliderTrailingConstant),
            idealPlanSlider.topAnchor.constraint(equalTo: idealPlanLabel.bottomAnchor, constant: idealPlanSliderTopConstant),
            idealPlanSlider.heightAnchor.constraint(equalToConstant: idealPlanSliderHeightConstant),
            
            chillLabel.leadingAnchor.constraint(equalTo: idealPlanSlider.leadingAnchor),
            chillLabel.widthAnchor.constraint(equalTo: idealPlanSlider.widthAnchor, multiplier: idealPlanSliderWidthMultiplier),
            chillLabel.heightAnchor.constraint(equalTo: idealPlanSlider.heightAnchor),
            chillLabel.topAnchor.constraint(equalTo: idealPlanSlider.bottomAnchor, constant: idealPlanSliderBottomConstant),
            
            intenseLabel.trailingAnchor.constraint(equalTo: idealPlanSlider.trailingAnchor),
            intenseLabel.widthAnchor.constraint(equalTo: idealPlanSlider.widthAnchor, multiplier: intenseLabelWidthMultiplier),
            intenseLabel.heightAnchor.constraint(equalTo: idealPlanSlider.heightAnchor),
            intenseLabel.topAnchor.constraint(equalTo: idealPlanSlider.bottomAnchor, constant: intenseLabelTopConstant),
            
            regularLabel.leadingAnchor.constraint(equalTo: idealPlanSlider.leadingAnchor),
            regularLabel.trailingAnchor.constraint(equalTo: idealPlanSlider.trailingAnchor),
            regularLabel.heightAnchor.constraint(equalTo: idealPlanSlider.heightAnchor),
            regularLabel.topAnchor.constraint(equalTo: idealPlanSlider.bottomAnchor, constant: regularLabelTopConstant),
            
            recommendedPlanView.topAnchor.constraint(equalTo: regularLabel.bottomAnchor, constant: recommendedPlanViewTopConstant),
            recommendedPlanView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: recommendedPlanViewHeightMultiplier),
            recommendedPlanView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: recommendedPlanViewWidthMultiplier),
            recommendedPlanView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        
            planImageView.topAnchor.constraint(equalTo: recommendedPlanView.topAnchor, constant: planImageViewTopConstant),
            planImageView.leadingAnchor.constraint(equalTo: recommendedPlanView.leadingAnchor, constant: planImageViewLeadingConstant),
            planImageView.widthAnchor.constraint(equalToConstant: planImageViewWidthConstant),
            planImageView.heightAnchor.constraint(equalTo: scheduleImageView.widthAnchor),
            
            scheduleImageView.centerYAnchor.constraint(equalTo: recommendedPlanView.centerYAnchor),
            scheduleImageView.leadingAnchor.constraint(equalTo: recommendedPlanView.leadingAnchor, constant: scheduleImageViewLeadingConstant),
            scheduleImageView.widthAnchor.constraint(equalToConstant: scheduleImageViewWidthConstant),
            scheduleImageView.heightAnchor.constraint(equalTo: scheduleImageView.widthAnchor),
            
            weSuggestLabel.centerYAnchor.constraint(equalTo: planImageView.centerYAnchor),
            weSuggestLabel.leadingAnchor.constraint(equalTo: planImageView.trailingAnchor, constant: weSuggestLabelLeadingConstant),
            weSuggestLabel.trailingAnchor.constraint(equalTo: recommendedPlanView.trailingAnchor, constant: weSuggestLabelTrailingConstant),
            weSuggestLabel.heightAnchor.constraint(equalTo: planImageView.heightAnchor),
            
            scheduleLabel.centerYAnchor.constraint(equalTo: scheduleImageView.centerYAnchor),
            scheduleLabel.leadingAnchor.constraint(equalTo: scheduleImageView.trailingAnchor, constant: scheduleLabelLeadingConstant),
            scheduleLabel.trailingAnchor.constraint(equalTo: scheduleLabel.leadingAnchor, constant: scheduleLabel.intrinsicContentSize.width),
            scheduleLabel.heightAnchor.constraint(equalTo: scheduleImageView.heightAnchor),
            
            workoutsInAWeekLabel.centerYAnchor.constraint(equalTo: scheduleLabel.centerYAnchor),
            workoutsInAWeekLabel.leadingAnchor.constraint(equalTo: scheduleLabel.trailingAnchor, constant: workoutsInAWeekLabelLeadingConstant),
            workoutsInAWeekLabel.trailingAnchor.constraint(equalTo: recommendedPlanView.trailingAnchor, constant: workoutsInAWeekLabelTrailingConstant),
            workoutsInAWeekLabel.heightAnchor.constraint(equalTo: scheduleLabel.heightAnchor),
        
            averageWorkoutLengthLabel.leadingAnchor.constraint(equalTo: scheduleLabel.leadingAnchor),
            averageWorkoutLengthLabel.trailingAnchor.constraint(equalTo: averageWorkoutLengthLabel.leadingAnchor, constant: averageWorkoutLengthLabel.intrinsicContentSize.width),
            averageWorkoutLengthLabel.bottomAnchor.constraint(equalTo: recommendedPlanView.bottomAnchor, constant: averageWorkoutLengthLabelBottomConstant),
            averageWorkoutLengthLabel.heightAnchor.constraint(equalTo: scheduleImageView.heightAnchor),
            
            minutesLabel.centerYAnchor.constraint(equalTo: averageWorkoutLengthLabel.centerYAnchor),
            minutesLabel.heightAnchor.constraint(equalTo: averageWorkoutLengthLabel.heightAnchor),
            minutesLabel.leadingAnchor.constraint(equalTo: averageWorkoutLengthLabel.trailingAnchor, constant: minutesLabelLeadingConstant),
            minutesLabel.trailingAnchor.constraint(equalTo: recommendedPlanView.trailingAnchor, constant: minutesLabelTrailingConstant),
            
            doneButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: doneButtonWidthMultiplier),
            doneButton.heightAnchor.constraint(equalToConstant: doneButtonHeightConstant),
            doneButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: doneButtonBottomConstant),
            
            preferenceLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            preferenceLabel.widthAnchor.constraint(equalToConstant: preferenceLabel.intrinsicContentSize.width),
            preferenceLabel.heightAnchor.constraint(equalToConstant: doneButton.intrinsicContentSize.height/2),
            preferenceLabel.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: preferenceLabelBottomConstant)
        ])
    }
    
}
