
//
//  ReminderController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 9/2/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//
import Foundation
import UserNotifications

class ReminderController: ReminderScheduler {
    

    static let reminderSharedInstance = ReminderController()
    
    var reminders = [Reminder]()
    
    
    func createReminder(reminder: Reminder, fireDate: Date, enabled: Bool) {
        let reminder = Reminder(fireDate: fireDate, enabled: enabled)
        ReminderController.reminderSharedInstance.reminders.append(reminder)
    }
    
    func updateReminder(reminder: Reminder, fireDate: Date, enabled: Bool) {
        reminder.fireDate = fireDate
        reminder.enabled = enabled
        scheduleUserNotification(for: reminder)
    }
    
    func toggleReminder(for reminder: Reminder){
        reminder.enabled = !reminder.enabled
        
        if reminder.enabled {
            scheduleUserNotification(for: reminder)
        } else {
            cancelUserNotification(for: reminder)
        }
    }
}

protocol ReminderScheduler: class {
    
    func scheduleUserNotification(for reminder: Reminder)
    func cancelUserNotification(for reminder: Reminder)
}

extension ReminderScheduler {
    func scheduleUserNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Woo you made it through the week!"
        content.body = "oh h*ck you made it! You are amazing!"
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: reminder.fireDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: reminder.uuid, content:content , trigger: trigger)
        UNUserNotificationCenter.current()
            .add(request) { (error) in
                if let error = error {
                    print("error scheduling local user notifications \(error.localizedDescription), \(error)")
                }
        }
    }
    
    func cancelUserNotification(for reminder: Reminder) {
        
        UNUserNotificationCenter.current()
            .removeAllPendingNotificationRequests()
    }
}
