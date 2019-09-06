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
            // Load the views if a riminder is passed in from a segue.
            loadViewIfNeeded()
        }
    }
    
    // Variable
    var reminderIsOn: Bool = true
    
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
    }
    
    @IBAction func reminderToggleTapped(_ sender: UISwitch) {
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
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Unwrap the reminder landing pad.
        if let reminder = reminder {
            // Call the updateReminder function from the model controller.
            ReminderController.sharedInstance.updateReminder(reminder: reminder, fireDate: datePicker?.dataSource as! Date, enabled: reminderIsOn)
        } else {
            // If the landing pad is nil, create a reminder.
            ReminderController.sharedInstance.createReminder(reminder: reminder!, fireDate: datePicker?.dataSource as! Date, enabled: reminderIsOn)
        }
        // Dismiss the view controller.
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        // Dismiss the view controller when the back button is tapped.
        self.dismiss(animated: true, completion: nil)
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
}
