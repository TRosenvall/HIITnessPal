//
//  RemindersViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/21/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit
import EventKit

class RemindersViewController: UIViewController {
    
    // Setup IBOutlets
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var remindersLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var remindersView: UIView!
    @IBOutlet weak var enableRemindersLabel: UILabel!
    @IBOutlet weak var reminderToggle: UISwitch!
    @IBOutlet weak var explainationLabel: UILabel!
    @IBOutlet weak var remindMeLabel: UILabel!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    let profile = ProfileController.sharedInstance.profile
    
    // Set a reminder landing pad.
    fileprivate var reminder: Reminder? {
        didSet {
            // Load the views if a reminder is passed in from a segue.
            loadViewIfNeeded()
        }
    }
    
    // Variable
    var reminderIsOn: Bool = true
    var reminderDate: Date = Date()
    var reminderInt: Int = 0
    var reminderWasToggled: Bool = false
    
    // Let the picker have values of the days of the week.
    let pickerData = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
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
        
        // Set picker and reminder
        guard let profile = ProfileController.sharedInstance.profile else {return}
        reminderToggle.isOn = profile.remindersEnabled
        setReminderToggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialFade()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fadeIn()
    }
    
    @IBAction func reminderToggleTapped(_ sender: UISwitch) {
        reminderWasToggled = !reminderWasToggled
        // Unwrap the reminder landing pad.
        if let reminder = reminder {
            // Call the toggleReminder function from the model controller.
            ReminderController.sharedInstance.toggleReminder(for: reminder)
            // Check whether or not the reminder is on.
            reminderIsOn = reminder.enabled
        } else {
            // If reminder is nil, turn off the reminder variable.
            reminderIsOn = !reminderIsOn
        }
        setReminderToggle()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let profile = profile else {return}
        if profile.remindersEnabled {
            // Unwrap the reminder landing pad and reminderDate.
            let date = reminderDate
            if let reminder = reminder {
                // Call the updateReminder function from the model controller.
                ReminderController.sharedInstance.updateReminder(reminder: reminder, fireDate: date, enabled: reminderIsOn)
            } else {
                // If the landing pad is nil, create a reminder.
                ReminderController.sharedInstance.createReminder(fireDate: date, enabled: reminderIsOn)
            }
        }
        if reminderWasToggled {
            ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: !profile.remindersEnabled, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: nil, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
        }
        ProfileController.sharedInstance.profile(profile: profile, name: nil, firstLogin: nil, healthKitIsOn: nil, remindersEnabled: nil, notificationsEnabled: nil, age: nil, goal: nil, gender: nil, idealPlan: nil, reminderDate: reminderInt, exercisesThisWeek: nil, completedExercises: nil, totalTimeExercising: nil, weight: nil, caloriesBurnedToday: nil, totalCaloriesBurned: nil, averageHeartRate: nil, caloriesBurnedThisWeek: nil)
        reminderWasToggled = false
        // Dismiss the view controller.
        fadeOut { (success) in
            if success {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        // Dismiss the view controller when the back button is tapped.
        fadeOut { (success) in
            if success {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func setReminderToggle() {
        guard let profile = profile else {return}
        if reminderToggle.isOn {
            datePicker.isHidden = false
            datePicker.selectRow(profile.reminderDate - 1, inComponent: 0, animated: false)
        } else {
            datePicker.isHidden = true
            datePicker.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    func getDayOfWeek() -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: Date())
        return weekDay
    }
    
    func getDateForDesiredWeekDay(differenceBetweenDesiredDayAndNow: Int) -> Date? {
        let difference = differenceBetweenDesiredDayAndNow
        guard let finishedDate = Calendar.current.date(byAdding: .day, value: difference, to: Date()) else {return nil}
        return finishedDate
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
    
    func setupConstraints() {
        
        var titleFontSize: CGFloat = 0
        var titleHeightMultiplier: CGFloat = 0
        var backButtonLeadingConstant: CGFloat = 0
        var backButtonBottomConstant: CGFloat = 0
        var backButtonHeightMultiplier: CGFloat = 0
        var remindersLabelWidthMultiplier: CGFloat = 0
        var remindersLabelbottomConstant: CGFloat = 0
        var remindersViewTopConstant: CGFloat = 0
        var remindersViewHeightConstant: CGFloat = 0
        var enableRemindersLabelWidthMultiplier: CGFloat = 0
        var explainationLabelTopConstant: CGFloat = 0
        var explainationLabelHeightMultiplier: CGFloat = 0
        var remindMeLabelTopConstant: CGFloat = 0
        var remindMeHeightMultiplier: CGFloat = 0
        var datePickerTopConstant: CGFloat = 0
        var saveButtonBottomAnchor: CGFloat = 0
        var saveButtonWidthMultiplier: CGFloat = 0
        var saveButtonHeightConstant: CGFloat = 0
        
        switch( getiPhoneSize()) {
        case "small":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.7
            
            remindersLabelWidthMultiplier = 0.5
            remindersLabelbottomConstant = 0
            
            remindersViewTopConstant = 22
            remindersViewHeightConstant = 44
            enableRemindersLabelWidthMultiplier = 0.9
            
            explainationLabelTopConstant = 0
            explainationLabelHeightMultiplier = 0.2
            remindMeLabelTopConstant = 0
            remindMeHeightMultiplier = 0.4
            
            datePickerTopConstant = 0
            
            saveButtonBottomAnchor = -44
            saveButtonWidthMultiplier = 0.4
            saveButtonHeightConstant = 44
        case "medium":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -4
            backButtonHeightMultiplier = 0.75
            remindersLabelWidthMultiplier = 0.5
            remindersLabelbottomConstant = 0
            
            remindersViewTopConstant = 22
            remindersViewHeightConstant = 44
            enableRemindersLabelWidthMultiplier = 0.9
            
            explainationLabelTopConstant = 6
            explainationLabelHeightMultiplier = 0.2
            remindMeLabelTopConstant = 6
            remindMeHeightMultiplier = 0.4
            
            datePickerTopConstant = 6
            
            saveButtonBottomAnchor = -44
            saveButtonWidthMultiplier = 0.4
            saveButtonHeightConstant = 44
        case "large":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            remindersLabelWidthMultiplier = 0.5
            remindersLabelbottomConstant = 0
            
            remindersViewTopConstant = 22
            remindersViewHeightConstant = 44
            enableRemindersLabelWidthMultiplier = 0.9
            
            explainationLabelTopConstant = 6
            explainationLabelHeightMultiplier = 0.2
            remindMeLabelTopConstant = 6
            remindMeHeightMultiplier = 0.4
            
            datePickerTopConstant = 6
            
            saveButtonBottomAnchor = -44
            saveButtonWidthMultiplier = 0.4
            saveButtonHeightConstant = 44
        case "x":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            remindersLabelWidthMultiplier = 0.5
            remindersLabelbottomConstant = 0
            
            remindersViewTopConstant = 22
            remindersViewHeightConstant = 44
            enableRemindersLabelWidthMultiplier = 0.9
            
            explainationLabelTopConstant = 6
            explainationLabelHeightMultiplier = 0.2
            remindMeLabelTopConstant = 6
            remindMeHeightMultiplier = 0.4
            
            datePickerTopConstant = 6
            
            saveButtonBottomAnchor = -44
            saveButtonWidthMultiplier = 0.4
            saveButtonHeightConstant = 44
        case "r":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            backButtonLeadingConstant = 24
            backButtonBottomConstant = -9
            backButtonHeightMultiplier = 0.75
            remindersLabelWidthMultiplier = 0.5
            remindersLabelbottomConstant = 0
            
            remindersViewTopConstant = 22
            remindersViewHeightConstant = 44
            enableRemindersLabelWidthMultiplier = 0.9
            
            explainationLabelTopConstant = 6
            explainationLabelHeightMultiplier = 0.2
            remindMeLabelTopConstant = 6
            remindMeHeightMultiplier = 0.4
            
            datePickerTopConstant = 6
            
            saveButtonBottomAnchor = -44
            saveButtonWidthMultiplier = 0.4
            saveButtonHeightConstant = 44
            
        default:
            print("Something went wrong getting the correct iPhone size.")
        }
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        remindersLabel.translatesAutoresizingMaskIntoConstraints = false
        remindersLabel.font = remindersLabel.font.withSize(titleFontSize)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        remindersView.translatesAutoresizingMaskIntoConstraints = false
        enableRemindersLabel.translatesAutoresizingMaskIntoConstraints = false
        reminderToggle.translatesAutoresizingMaskIntoConstraints = false
        
        explainationLabel.translatesAutoresizingMaskIntoConstraints = false
        remindMeLabel.translatesAutoresizingMaskIntoConstraints = false
        remindMeLabel.numberOfLines = 0
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: self.view.topAnchor),
            titleView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: titleHeightMultiplier),
            titleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: backButtonLeadingConstant),
            backButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: backButtonBottomConstant),
            backButton.heightAnchor.constraint(equalToConstant: titleView.frame.size.height * backButtonHeightMultiplier),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            remindersLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            remindersLabel.widthAnchor.constraint(equalTo: titleView.widthAnchor, multiplier: remindersLabelWidthMultiplier),
            remindersLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: remindersLabelbottomConstant),
        
            remindersView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: remindersViewTopConstant),
            remindersView.heightAnchor.constraint(equalToConstant: remindersViewHeightConstant),
            remindersView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            remindersView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
        
            enableRemindersLabel.centerYAnchor.constraint(equalTo: remindersView.centerYAnchor),
            enableRemindersLabel.widthAnchor.constraint(equalTo: remindersView.widthAnchor, multiplier: enableRemindersLabelWidthMultiplier),
            enableRemindersLabel.centerXAnchor.constraint(equalTo: remindersView.centerXAnchor),
            
            reminderToggle.trailingAnchor.constraint(equalTo: enableRemindersLabel.trailingAnchor),
            reminderToggle.centerYAnchor.constraint(equalTo: remindersView.centerYAnchor),
            
            explainationLabel.topAnchor.constraint(equalTo: remindersView.bottomAnchor, constant: explainationLabelTopConstant),
            explainationLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: explainationLabelHeightMultiplier),
            explainationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            explainationLabel.leadingAnchor.constraint(equalTo: enableRemindersLabel.leadingAnchor),
            
            remindMeLabel.topAnchor.constraint(equalTo: explainationLabel.bottomAnchor, constant: remindMeLabelTopConstant),
            remindMeLabel.leadingAnchor.constraint(equalTo: explainationLabel.leadingAnchor),
            remindMeLabel.centerXAnchor.constraint(equalTo: explainationLabel.centerXAnchor),
            remindMeLabel.heightAnchor.constraint(equalTo: explainationLabel.heightAnchor, multiplier: remindMeHeightMultiplier),
            
            saveButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: saveButtonBottomAnchor),
            saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: saveButtonWidthMultiplier),
            saveButton.heightAnchor.constraint(equalToConstant: saveButtonHeightConstant),
            
            datePicker.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: datePickerTopConstant),
            datePicker.topAnchor.constraint(equalTo: remindMeLabel.bottomAnchor, constant: datePickerTopConstant),
            datePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}

extension RemindersViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // The picker for defining the date to recieve a reminder has only one section, the day of the week from above.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows in the picker is 7, based on the number of days in the week from the above pickerData variable.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // Set the title for each row from the pickerData for pickerData's index position.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        reminderInt = row + 1
        guard let dayOfWeek = getDayOfWeek() else {return}
        let differenceBetweenDays = dayOfWeek - (row + 1)
        let differenceBetweenDesiredDay = 7 - differenceBetweenDays
        if let date = getDateForDesiredWeekDay(differenceBetweenDesiredDayAndNow: differenceBetweenDesiredDay) {
            reminderDate = date
        }
    }
}
