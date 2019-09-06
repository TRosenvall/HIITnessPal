//
//  RemindersViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/21/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit
import EventKit

class RemindersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    fileprivate var reminder: Reminder? {
        didSet {
            loadViewIfNeeded()
        }
    }
    
    var reminderIsOn: Bool = true
    
    @IBOutlet weak var reminderToggle: UISwitch!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var remindMeLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    
    let pickerData = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBAction func reminderToggleTapped(_ sender: UISwitch) {
        if let reminder = reminder {
            ReminderController.reminderSharedInstance.toggleReminder(for: reminder)
            reminderIsOn = reminder.enabled
        } else {
            reminderIsOn = !reminderIsOn
        }
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if let reminder = reminder {
            ReminderController.reminderSharedInstance.updateReminder(reminder: reminder, fireDate: datePicker?.dataSource as! Date, enabled: reminderIsOn)
        } else {
            ReminderController.reminderSharedInstance.createReminder(reminder: reminder!, fireDate: datePicker?.dataSource as! Date, enabled: reminderIsOn)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

