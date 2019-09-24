//
//  AppDelegate.swift
//  HIITnessPal
//
//  Created by Leah Cluff on 9/5/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Override point for customization after application launch.
        ProfileController.sharedInstance.loadFromPersistentStore { (success) in
            if success {
                guard let profile = ProfileController.sharedInstance.profile else {return}
                ProfileController.sharedInstance.advanceDate(profile: profile)
            }
        }
        
        let yesAction = UNNotificationAction(identifier: "accept_identifier", title: "accept")
        let noAction = UNNotificationAction(identifier: "delcline_identifier", title: "decline")
        
        let customCategory = UNNotificationCategory(identifier: "custom", actions: [yesAction, noAction], intentIdentifiers: [])
        UNUserNotificationCenter.current().setNotificationCategories([customCategory])
        
        let exercises = ExerciseController.sharedInstance.workouts
        let tempWorkouts: [Workout] = [exercises[0], exercises[1], exercises[2], exercises[3]]
        let tempWorkoutMultiplier: Int = 4
        
        WorkoutsController.sharedInstance.createWorkout(name: "Super Sweat", workouts: tempWorkouts, multiplier: tempWorkoutMultiplier)
        
        
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token =  deviceToken.map { String(format:"%02.2hhx",$0) }.joined()
        print(token)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer {
            completionHandler() }
        print("User tapped push notifications")
    }
    
    func prepareForPushNotifications(for application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            guard granted else {
                return
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
}
