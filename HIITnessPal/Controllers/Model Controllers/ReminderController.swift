
//
//  ReminderController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 9/2/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//
import Foundation
import UserNotifications

// Protocol functions for the reminder scheduler.
protocol ReminderScheduler: class {
    // Function to schedule the reminder notification.
    func scheduleUserNotification(for reminder: Reminder)
    // Function to cancel the reminder notification.
    func cancelUserNotification(for reminder: Reminder)
}

class ReminderController: ReminderScheduler {
    
    // Singleton to access reminder variables and functions.
    static let sharedInstance = ReminderController()
    
    // ReminderController variables
    var reminders = [Reminder]()
    
    // Function used to create a reminder.
    func createReminder(reminder: Reminder, fireDate: Date, enabled: Bool) {
        // Set a reminder
        let reminder = Reminder(enabled: enabled, fireDate: fireDate)
        // Add the reminder to the given list.
    ReminderController.sharedInstance.reminders.append(reminder)
    }
    
    // Function used to update a given reminder.
    func updateReminder(reminder: Reminder, fireDate: Date, enabled: Bool) {
        // Update the reminder date
        reminder.fireDate = fireDate
        reminder.enabled = enabled
        // Schedule the updated reminder.
        scheduleUserNotification(for: reminder)
    }
    
    // Toggle the reminders button
    func toggleReminder(for reminder: Reminder){
        // Reset the status of the reminder.
        reminder.enabled = !reminder.enabled
        // If reminders are enabled, schedule the reminder, if it's disabled, cancel the reminder.
        if reminder.enabled {
            scheduleUserNotification(for: reminder)
        } else {
            cancelUserNotification(for: reminder)
        }
    }
}

extension ReminderScheduler {
    // Protocol function to schedule the reminders.
    func scheduleUserNotification(for reminder: Reminder) {
        
        // Setup the content of the notification.
        let content = UNMutableNotificationContent()
        content.title = "Woo! You made it through the week!"
        content.body = "Oh h*ck you made it! You are amazing!"
        content.sound = UNNotificationSound.default
        
        // Set the date for the reminder from the given firedate.
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: reminder.fireDate)
        
        // Set the trigger and request from the trigger for the reminder.
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: reminder.uuid, content:content , trigger: trigger)
        // Setup the reminder from the request.
        UNUserNotificationCenter.current().add(request) { (error) in
            // Unwrap and handle the errors.
            if let error = error {
                print("Error scheduling local user notifications, \(error.localizedDescription), \(error)")
            }
        }
    }
    
    // Protocol function to remove cancel the reminders.
    func cancelUserNotification(for reminder: Reminder) {
        // Remove the reminder notification.
        UNUserNotificationCenter.current()
            .removeAllPendingNotificationRequests()
    }
}
