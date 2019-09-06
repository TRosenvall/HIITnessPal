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
    @IBOutlet weak var reminderToggle: UISwitch!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var remindMeLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    
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
        // Set the title views gradient and shadow.
        SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // Set picker and reminder
        reminderToggle.isOn = ProfileController.sharedInstance.profile.remindersEnabled
        setReminderToggle()
        ProfileController.sharedInstance.saveToPersistentStore()
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
        ProfileController.sharedInstance.saveToPersistentStore()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if ProfileController.sharedInstance.profile.remindersEnabled {
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
            ProfileController.sharedInstance.profile.remindersEnabled = !ProfileController.sharedInstance.profile.remindersEnabled
        }
        ProfileController.sharedInstance.profile.reminderDate = reminderInt
        reminderWasToggled = false
        // Dismiss the view controller.
        self.dismiss(animated: true, completion: nil)
        ProfileController.sharedInstance.saveToPersistentStore()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        // Dismiss the view controller when the back button is tapped.
        self.dismiss(animated: true, completion: nil)
    }
    
    func setReminderToggle() {
        if reminderToggle.isOn {
            datePicker.isHidden = false
            datePicker.selectRow(ProfileController.sharedInstance.profile.reminderDate - 1, inComponent: 0, animated: false)
        } else {
            datePicker.isHidden = true
            datePicker.selectRow(0, inComponent: 0, animated: false)
        }
        ProfileController.sharedInstance.saveToPersistentStore()
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
