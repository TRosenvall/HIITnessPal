//
//  AboutMeViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/20/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit
import HealthKit

class AboutMeViewController: UIViewController {

    // Setup IBOutlets
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var aboutMeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var healthAppConnectLabel: UILabel!
    @IBOutlet weak var healthKitSwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageTextField: PasteDisabledTextField!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightTextField: PasteDisabledTextField!
    @IBOutlet weak var preferenceLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    // Set the user profile and create a Picker View for the gender
    let profile = ProfileController.sharedInstance.profile
    let genderPicker = UIPickerView()
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDisplay()
        
        // Set the title views gradient and shadow.
        titleView.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        titleView.layer.masksToBounds = false
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // Set the progressView, backButton, nextButton, and preferenceLabel for first time users
        
        guard let profile = profile else {return}
        if profile.firstLogin {
            progressView.isHidden = false
            nextButton.isHidden = false
            preferenceLabel.isHidden = false
            backButton.isHidden = true
        } else {
            progressView.isHidden = true
            preferenceLabel.isHidden = true
            backButton.isHidden = false
            nextButton.setTitle("Save", for: .normal)
        }
        
        // Call the functions to setup the views, the picker view and set the right value for the switch.
        setupViews()
        setupPickerView()
        setupHealthKitSwitch()
        
        updateButtons()
        
        // Setup an observer to see if the view re-enters the foreground so that it can update the switch settings if the user manually changed the health kit permissions from the health app.
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        // Setup an observer to see if healthKit is enabled so the apple watch functionality can start.
        print("----")
        print("Setup userToggledHealthKit")
        NotificationCenter.default.post(name: NSNotification.Name("userToggledHealthKit"), object: profile.healthKitIsOn)
        print("----")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialFade()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fadeIn()
    }
    
    // The function that is called if the view enters the foreground from the background.
    @objc func willEnterForeground() {
        // Update the switch
        setupHealthKitSwitch()
    }
    
    // Tapping the switch to turn on or off HealthKit functionality.
    @IBAction func healthKitSwitchTapped(_ sender: UISwitch) {
        guard let profile = profile else {return}
        // Call for authorization if it hasn't already been called. This will open a view to allow access to change the health settings from the Health app in this app.
        HealthKitController.sharedInstance.authorizeHeatlhKitInApp { (success) in
            if success{
                DispatchQueue.main.async {
                    // If access is rejected, called the function to disable the switch and turn it off.
                    self.setupHealthKitSwitch()
                }
            }
        }
        // Set the profile healthKitSetting to the switch's
        ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: healthKitSwitch.isOn, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
        
    }
    
    // Check if the back button has been tapped.
    @IBAction func backButtonTapped(_ sender: Any) {
        // Dismiss the view to go back to the profile view.
        fadeOut { (success) in
            if success {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    // General Screen Tapped Gesture Recognizer
    @IBAction func screenTapped(_ sender: Any) {
        // Update the values, this is called here to dismiss the first responder as well.
        setProfileValues()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        // Update the values for the profile so they stay up to date.
        setProfileValues()
        guard let profile = profile else {return}
        if profile.firstLogin {
            // If it's the first login present MyPlanStoryboard.
            let storyboard = UIStoryboard(name: "HiitnessProfile", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MyPlanStoryboard")
            viewController.modalPresentationStyle = .fullScreen
            
            fadeOut { (success) in
                if success {
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        } else {
            // Dismiss the storyboard.
            fadeOut { (success) in
                if success {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    func setupDisplay() {
        
        var titleFontSize: CGFloat = 0
        var titleHeightMultiplier: CGFloat = 0
        var backButtonLeadingConstant: CGFloat = 0
        var backButtonBottomConstant: CGFloat = 0
        var backButtonHeightMultiplier: CGFloat = 0
        var aboutMeLabelWidthMultiplier: CGFloat = 0
        var aboutMeLabelbottomConstant: CGFloat = 0
        var progressViewBottomConstant: CGFloat = 0
        var progressViewWidthMultiplier: CGFloat = 0
        
        var informationLabelTopConstant: CGFloat = 0
        var informationLabelWidthMultiplier: CGFloat = 0
        var healthAppConnectLabelTopConstant: CGFloat = 0
        
        var nameLabelTopConstant: CGFloat = 0
        var genderLabelTopConstant: CGFloat = 0
        var ageLabelTopConstant: CGFloat = 0
        var weightLabelTopConstant: CGFloat = 0
        
        var nextButtonWidthMultiplier: CGFloat = 0
        var nextButtonHeightConstant: CGFloat = 0
        var nextButtonBottomConstant: CGFloat = 0
        var preferenceLabelBottomConstant: CGFloat = 0
        
        switch (getiPhoneSize()) {
        case "small":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.7
            
            aboutMeLabelWidthMultiplier = 0.5
            if profile?.firstLogin == true {
                aboutMeLabelbottomConstant = -5
            } else {
                aboutMeLabelbottomConstant = 0
            }
            progressViewBottomConstant = -8
            progressViewWidthMultiplier = 0.5
            
            informationLabelTopConstant = 22
            informationLabelWidthMultiplier = 0.9
            healthAppConnectLabelTopConstant = 22
            
            nameLabelTopConstant = 44
            genderLabelTopConstant = 22
            ageLabelTopConstant = 22
            weightLabelTopConstant = 22
            
            nextButtonWidthMultiplier = 0.4
            nextButtonHeightConstant = 44
            nextButtonBottomConstant = -44
            preferenceLabelBottomConstant = -22
        case "medium":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            aboutMeLabelWidthMultiplier = 0.5
            if profile?.firstLogin == true {
                aboutMeLabelbottomConstant = -8
            } else {
                aboutMeLabelbottomConstant = 0
            }
            progressViewBottomConstant = -11
            progressViewWidthMultiplier = 0.5
            
            informationLabelTopConstant = 22
            informationLabelWidthMultiplier = 0.9
            healthAppConnectLabelTopConstant = 22
            
            nameLabelTopConstant = 44
            genderLabelTopConstant = 22
            ageLabelTopConstant = 22
            weightLabelTopConstant = 22
            
            nextButtonWidthMultiplier = 0.4
            nextButtonHeightConstant = 44
            nextButtonBottomConstant = -44
            preferenceLabelBottomConstant = -22
        case "large":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            aboutMeLabelWidthMultiplier = 0.5
            if profile?.firstLogin == true {
                aboutMeLabelbottomConstant = -12
            } else {
                aboutMeLabelbottomConstant = 0
            }
            progressViewBottomConstant = -11
            progressViewWidthMultiplier = 0.5
            
            informationLabelTopConstant = 22
            informationLabelWidthMultiplier = 0.9
            healthAppConnectLabelTopConstant = 22
            
            nameLabelTopConstant = 44
            genderLabelTopConstant = 22
            ageLabelTopConstant = 22
            weightLabelTopConstant = 22
            
            nextButtonWidthMultiplier = 0.4
            nextButtonHeightConstant = 44
            nextButtonBottomConstant = -44
            preferenceLabelBottomConstant = -22
        case "x":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            aboutMeLabelWidthMultiplier = 0.5
            if profile?.firstLogin == true {
                aboutMeLabelbottomConstant = -9
            } else {
                aboutMeLabelbottomConstant = 0
            }
            progressViewBottomConstant = -17
            progressViewWidthMultiplier = 0.5
            
            informationLabelTopConstant = 22
            informationLabelWidthMultiplier = 0.9
            healthAppConnectLabelTopConstant = 22
            
            nameLabelTopConstant = 44
            genderLabelTopConstant = 22
            ageLabelTopConstant = 22
            weightLabelTopConstant = 22
            
            nextButtonWidthMultiplier = 0.4
            nextButtonHeightConstant = 44
            nextButtonBottomConstant = -44
            preferenceLabelBottomConstant = -22
        case "r":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            aboutMeLabelWidthMultiplier = 0.5
            if profile?.firstLogin == true {
                aboutMeLabelbottomConstant = -9
            } else {
                aboutMeLabelbottomConstant = 0
            }
            progressViewBottomConstant = -17
            progressViewWidthMultiplier = 0.5
            
            informationLabelTopConstant = 22
            informationLabelWidthMultiplier = 0.9
            healthAppConnectLabelTopConstant = 22
            
            nameLabelTopConstant = 44
            genderLabelTopConstant = 22
            ageLabelTopConstant = 22
            weightLabelTopConstant = 22
            
            nextButtonWidthMultiplier = 0.4
            nextButtonHeightConstant = 44
            nextButtonBottomConstant = -44
            preferenceLabelBottomConstant = -22
        default:
            print(self.view.frame.height)
        }
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.font = aboutMeLabel.font.withSize(titleFontSize)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.textAlignment = .justified
        healthAppConnectLabel.translatesAutoresizingMaskIntoConstraints = false
        healthKitSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderTextField.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        
        preferenceLabel.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: titleHeightMultiplier),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: backButtonLeadingConstant),
            backButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: backButtonBottomConstant),
            backButton.heightAnchor.constraint(equalToConstant: titleView.frame.size.height * backButtonHeightMultiplier),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            aboutMeLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            aboutMeLabel.widthAnchor.constraint(equalTo: titleView.widthAnchor, multiplier: aboutMeLabelWidthMultiplier),
            aboutMeLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: aboutMeLabelbottomConstant),
            
            progressView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            progressView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: progressViewBottomConstant),
            progressView.widthAnchor.constraint(equalTo: titleView.widthAnchor, multiplier: progressViewWidthMultiplier),
            
            informationLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: informationLabelTopConstant),
            informationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            informationLabel.heightAnchor.constraint(equalToConstant: informationLabel.intrinsicContentSize.height * 2),
            informationLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: informationLabelWidthMultiplier),
            
            healthAppConnectLabel.leadingAnchor.constraint(equalTo: informationLabel.leadingAnchor),
            healthAppConnectLabel.widthAnchor.constraint(equalToConstant: healthAppConnectLabel.intrinsicContentSize.width),
            healthAppConnectLabel.heightAnchor.constraint(equalToConstant: healthAppConnectLabel.intrinsicContentSize.height),
            healthAppConnectLabel.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: healthAppConnectLabelTopConstant),
            
            healthKitSwitch.trailingAnchor.constraint(equalTo: informationLabel.trailingAnchor),
            healthKitSwitch.centerYAnchor.constraint(equalTo: healthAppConnectLabel.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: healthAppConnectLabel.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: healthAppConnectLabel.bottomAnchor, constant: nameLabelTopConstant),
            
            nameTextField.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: healthKitSwitch.trailingAnchor),
            
            genderLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            genderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: genderLabelTopConstant),
            
            genderTextField.centerYAnchor.constraint(equalTo: genderLabel.centerYAnchor),
            genderTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            ageLabel.leadingAnchor.constraint(equalTo: genderLabel.leadingAnchor),
            ageLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: ageLabelTopConstant),
            
            ageTextField.centerYAnchor.constraint(equalTo: ageLabel.centerYAnchor),
            ageTextField.trailingAnchor.constraint(equalTo: genderTextField.trailingAnchor),
            
            weightLabel.leadingAnchor.constraint(equalTo: ageLabel.leadingAnchor),
            weightLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: weightLabelTopConstant),
            
            weightTextField.centerYAnchor.constraint(equalTo: weightLabel.centerYAnchor),
            weightTextField.trailingAnchor.constraint(equalTo: ageTextField.trailingAnchor),
            
            nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: nextButtonWidthMultiplier),
            nextButton.heightAnchor.constraint(equalToConstant: nextButtonHeightConstant),
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: nextButtonBottomConstant),
            
            preferenceLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            preferenceLabel.widthAnchor.constraint(equalToConstant: preferenceLabel.intrinsicContentSize.width),
            preferenceLabel.heightAnchor.constraint(equalToConstant: nextButton.intrinsicContentSize.height/2),
            preferenceLabel.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: preferenceLabelBottomConstant)
        ])
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
        default: print(self.view.frame.height)
        }
        return ""
    }
    
    // Updates the user profiles values
    func setProfileValues() {
        // Resigns the first responders for the text field and hides the picker view
        nameTextField.resignFirstResponder()
        genderTextField.endEditing(true)
        ageTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
        guard let profile = profile else {return}
        // Update the name, age and weight of user.
        if let name = nameTextField.text {
            ProfileController.sharedInstance.profile(profile: profile, name: name, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
        } else {
            ProfileController.sharedInstance.profile(profile: profile, name: "", firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
        }
        // Unwraps the age and sets it to an integer value if possible. If this fails, the age is set to 0.
        if let age = ageTextField.text, let ageInt = Int(age) {
            ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: ageInt, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
        } else {
            ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: -1, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
        }
        // Upwraps the age and sets it to a double value if possible. If this fails, the weight is set to 0.0.
        if let weight = weightTextField.text, let weightDouble = Double(weight) {
            ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: weightDouble, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
        } else {
            ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: -1, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
        }
        updateButtons()
    }
    
    // Sets the position and functionality of the switch.
    func setupHealthKitSwitch() {
        guard let profile = profile else {return}
        // Pulls the HealthKit objects for weight, heartRate, and activeEnergyBurned
        guard let weight = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass) else
        {return}
        guard let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate) else {return}
        guard let activeCalorieExpendeture = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {return}
        // Checks the authorization status of the above objects
        let weightAuth = HealthKitController.sharedInstance.healthKitStore.authorizationStatus(for: weight).rawValue
        let heartRateAuth = HealthKitController.sharedInstance.healthKitStore.authorizationStatus(for: heartRate).rawValue
        let ageAuth = HealthKitController.sharedInstance.healthKitStore.authorizationStatus(for: activeCalorieExpendeture).rawValue
        // If the objects are denied access to healthKit (a.k.a. the raw values are equal to 1)
        if weightAuth == 1 || heartRateAuth == 1 || ageAuth == 1 {
            // Turn off the switch, disable the switch, update the profile to be marked as not using healthKit, and show the prompt to maunally allow access in the Health app
            healthKitSwitch.isOn = false
            healthKitSwitch.isEnabled = false
            ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: healthKitSwitch.isOn, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
           
        } else {
            // Hide the prompt to manually allow access in the Health app and re-enable the switch
           
            healthKitSwitch.isEnabled = true
            ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: healthKitSwitch.isEnabled, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
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
    
    // Setup the initial views when loaded
    func setupViews() {
        guard let profile = profile else {return}
        // Set the textField delegates to be self.
        nameTextField.delegate = self
        genderTextField.delegate = self
        ageTextField.delegate = self
        weightTextField.delegate = self
        // Set the switch to the appropriate setting of the profile
        healthKitSwitch.isOn = profile.healthKitIsOn
        // Update the name of the text field to that of the profile
        nameTextField.text = profile.name
        // If the age hasn't been set, keep it blank, otherwise update to the profile age.
        if profile.age == -1 {
            ageTextField.text = ""
        } else {
            ageTextField.text = "\(profile.age)"
        }
        // If the weight hasn't been set, keep it blank, otherwise update to the profile weight.
        if profile.weight == -1 {
            weightTextField.text = ""
        } else if profile.weight == 0 {
            weightTextField.text = "0"
        } else {
            weightTextField.text = "\(profile.weight)"
        }
        // If the gender hasn't been set, keep it blank, otherwise update to the appropriate profile value
        if profile.gender == -1 {
            genderTextField.text = ""
        } else if profile.gender == 0 {
            genderTextField.text = "Male"
        } else {
            genderTextField.text = "Female"
        }
    }
    
    // Setup the pickerView created above.
    func setupPickerView() {
        // Set the pickerView delegate and dataSource to be self
        self.genderPicker.delegate = self as UIPickerViewDelegate
        self.genderPicker.dataSource = self as UIPickerViewDataSource
        // Set the genderTextField to show the pickerView when tapped.
        genderTextField.inputView = genderPicker
    }
    
    func updateButtons() {
        guard let gender = genderTextField.text, let age = ageTextField.text, let weight = weightTextField.text, let name = nameTextField.text else {return}
        if gender.isEmpty ||
            age.isEmpty ||
            weight.isEmpty ||
            name.isEmpty {
            nextButton.isEnabled = false
            nextButton.layer.backgroundColor = UIColor.getHIITGray.cgColor
        } else {
            nextButton.isEnabled = true
            nextButton.layer.backgroundColor = UIColor.getHIITAccentOrange.cgColor
        }
        
    }
}

// Extend the class for the pickerView
extension AboutMeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // Only one component in the pickerView (it will only have one slider up and down).
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // There are three rows in the pickerView.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    // The first row in the pickerView is case 0, second row is case 1, third row is case 2. Default should never be called.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "Select Your Gender"
        case 1:
            return "Male"
        case 2:
            return "Female"
        default:
            return "Error"
        }
    }
    
    // If the row is selected for one of the three cases above
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let profile = profile else {return}
        // Update the genderTextField
        switch row {
        case 0:
            genderTextField.text = genderTextField.text
        case 1:
            genderTextField.text = "Male"
            // Update the profile gender
            ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: 0, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
        case 2:
            genderTextField.text = "Female"
            // Update the profile gender
            ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: 1, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
        // Should never be called.
        default:
            genderTextField.text = "Error"
        }
        updateButtons()
    }
}

// Extend to be a textFieldDelegate in order to set a max character limit
extension AboutMeViewController: UITextFieldDelegate {
    // Call this function to prevent changing if too long.
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Ignore the character limit if the backspace is being called.
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        // Unwrap the current text field
        guard let text = textField.text else {return false}
        // If it's the field for the age or weight
        if textField == ageTextField || textField == weightTextField {
            // Limit to Three characters
            return text.count < 3
        }
        // For the name, limit to nine characters.
        return text.count < 9
    }
}
