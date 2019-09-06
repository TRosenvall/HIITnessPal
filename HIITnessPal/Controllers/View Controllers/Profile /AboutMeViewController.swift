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
    
    
    // Set the user profile and create a Picker View for the gender
    let profile = ProfileController.sharedInstance.profile
    let genderPicker = UIPickerView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradient(view: titleView, chooseTwo: true, primaryBlue: false, accentOrange: true, accentBlue: false)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // Hide the label for if access is denied to HealthKit.
        
        // Call the functions to setup the views, the picker view and set the right value for the switch.
        setupViews()
        setupPickerView()
        setupHealthKitSwitch()
        // Setup an observer to see if the view re-enters the foreground so that it can update the switch settings if the user manually changed the health kit permissions from the health app.
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // The function that is called if the view enters the foreground from the background.
    @objc func willEnterForeground() {
        print("appeared")
        // Update the switch
        setupHealthKitSwitch()
    }
    
    // Tapping the switch to turn on or off HealthKit functionality.
    @IBAction func healthKitSwitchTapped(_ sender: UISwitch) {
        // Reverse the profile setting for whether or not HealthKit should be used.
        profile.healthKitIsOn = !profile.healthKitIsOn
        // Call for authorization if it hasn't already been called. This will open a view to allow access to change the health settings from the Health app in this app.
        HealthKitController.sharedInstance.authorizeHeatlhKitInApp { (success) in
            if success{
                DispatchQueue.main.async {
                    // If access is rejected, called the function to disable the switch and turn it off.
                    self.setupHealthKitSwitch()
                }
            }
        }
    }
    
    // Check if the back button has been tapped.
    @IBAction func backButtonTapped(_ sender: Any) {
        // Update the values for the profile so they stay up to date.
        setProfileValues()
        // Dismiss the view to go back to the profile view.
        self.dismiss(animated: true, completion: nil)
    }
    
    // General Screen Tapped Gesture Recognizer
    @IBAction func screenTapped(_ sender: Any) {
        // Update the values, this is called here to dismiss the first responder as well.
        setProfileValues()
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
        }
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
    }
    
    // Setup the pickerView created above.
    func setupPickerView() {
        // Set the pickerView delegate and dataSource to be self
        self.genderPicker.delegate = self as UIPickerViewDelegate
        self.genderPicker.dataSource = self as UIPickerViewDataSource
        // Set the genderTextField to show the pickerView when tapped.
        genderTextField.inputView = genderPicker
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
