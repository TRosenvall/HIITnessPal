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
    @IBOutlet weak var healthKitSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: PasteDisabledTextField!
    @IBOutlet weak var weightTextField: PasteDisabledTextField!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var backButton: UIButton!
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
        // Set the title views gradient and shadow.
        SetGradient.setGradient(view: titleView, mainColor: .getHIITPrimaryOrange, secondColor: .getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // Set the progressView, backButton, nextButton, and preferenceLabel for first time users
        if ProfileController.sharedInstance.profile.firstLogin {
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
        ProfileController.sharedInstance.saveToPersistentStore()
    }
    
    // The function that is called if the view enters the foreground from the background.
    @objc func willEnterForeground() {
        print("appeared")
        // Update the switch
        setupHealthKitSwitch()
        ProfileController.sharedInstance.saveToPersistentStore()
    }
    
    // Tapping the switch to turn on or off HealthKit functionality.
    @IBAction func healthKitSwitchTapped(_ sender: UISwitch) {
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
        profile.healthKitIsOn = healthKitSwitch.isOn
        ProfileController.sharedInstance.saveToPersistentStore()
    }
    
    // Check if the back button has been tapped.
    @IBAction func backButtonTapped(_ sender: Any) {
        // Dismiss the view to go back to the profile view.
        self.dismiss(animated: true, completion: nil)
    }
    
    // General Screen Tapped Gesture Recognizer
    @IBAction func screenTapped(_ sender: Any) {
        // Update the values, this is called here to dismiss the first responder as well.
        setProfileValues()
        ProfileController.sharedInstance.saveToPersistentStore()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        // Update the values for the profile so they stay up to date.
        setProfileValues()
        if ProfileController.sharedInstance.profile.firstLogin {
            // If it's the first login present MyPlanStoryboard.
            let storyboard = UIStoryboard(name: "HiitnessProfile", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MyPlanStoryboard")
            self.present(viewController, animated: true, completion: nil)
        } else {
            // Dismiss the storyboard.
            self.dismiss(animated: true, completion: nil)
        }
        ProfileController.sharedInstance.saveToPersistentStore()
    }
    
    // Updates the user profiles values
    func setProfileValues() {
        // Resigns the first responders for the text field and hides the picker view
        nameTextField.resignFirstResponder()
        genderTextField.endEditing(true)
        ageTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
        // Update the name, age and weight of user.
        if let name = nameTextField.text {
            profile.name = name
        } else {
            profile.name = ""
        }
        // Unwraps the age and sets it to an integer value if possible. If this fails, the age is set to 0.
        if let age = ageTextField.text, let ageInt = Int(age) {
            profile.age = ageInt
        } else {
            profile.age = -1
        }
        // Upwraps the age and sets it to a double value if possible. If this fails, the weight is set to 0.0.
        if let weight = weightTextField.text, let weightDouble = Double(weight) {
            profile.weight = weightDouble
        } else {
            profile.weight = -1
        }
        updateButtons()
        ProfileController.sharedInstance.saveToPersistentStore()
    }
    
    // Sets the position and functionality of the switch.
    func setupHealthKitSwitch() {
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
            profile.healthKitIsOn = false
           
        } else {
            // Hide the prompt to manually allow access in the Health app and re-enable the switch
           
            healthKitSwitch.isEnabled = true
            profile.healthKitIsOn = true
        }
        ProfileController.sharedInstance.saveToPersistentStore()
    }
    
    // Setup the initial views when loaded
    func setupViews() {
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
        ProfileController.sharedInstance.saveToPersistentStore()
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
        // Update the genderTextField
        switch row {
        case 0:
            genderTextField.text = genderTextField.text
        case 1:
            genderTextField.text = "Male"
            // Update the profile gender
            profile.gender = 0
        case 2:
            genderTextField.text = "Female"
            // Update the profile gender
            profile.gender = 1
        // Should never be called.
        default:
            genderTextField.text = "Error"
        }
        updateButtons()
        ProfileController.sharedInstance.saveToPersistentStore()
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
            // Limit to five characters
            return text.count < 3
        }
        // For the name, limit to nine characters.
        return text.count < 9
    }
}
