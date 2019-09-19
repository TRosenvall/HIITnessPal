//
//  Profile.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/20/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import Foundation
import CloudKit

struct Exercises: Codable {
    var exercise: Int
    var daysElapsed: Int
}

struct Weights: Codable {
    var weight: Double
    var daysElapsed: Int
}

struct Calories: Codable {
    var calorieCount: Double
    var daysElapsed: Int
}

class Profile: Codable {
    // Profile Variables
    var name: String
    var firstLogin: Bool
    var healthKitIsOn: Bool
    var remindersEnabled: Bool
    var notificationsEnabled: Bool
    var age: Int
    var goal: Int
    var gender: Int
    var idealPlan: Int
    var reminderDate: Int
    var exercisesThisWeek: [Exercises]
    var completedExercises: Int
    var totalTimeExercising: Int
    var weight: Double
    var caloriesBurnedToday: Double
    var totalCaloriesBurned: Double
    var averageHeartRate: [Double]
    var weightsForWeeklyPlot: [Weights]
    var caloriesBurnedThisWeek: [Calories]
    var lastDate: Date
    
    // Profile Initializer
    init(name: String = "",
         firstLogin: Bool = true,
         healthKitIsOn: Bool = false,
         remindersEnabled: Bool = false,
         notificationsEnabled: Bool = false,
         age: Int = -1,
         goal: Int = 0,
         gender: Int = -1,
         idealPlan: Int = 3,
         reminderDate: Int = 0,
         exercisesThisWeek: [Exercises] = [],
         completedExercises: Int = 0,
         totalTimeExericising: Int = 0,
         weight: Double = -1,
         caloriesBurnedToday: Double = 0.0,
         totalCaloriesBurned: Double = 0.0,
         averageHeartRate: [Double] = [],
         weightsForWeeklyPlot: [Weights] = [],
         caloriesBurnedThisWeek: [Calories] = [],
         lastDate: Date = Date()) {
        self.name = name
        self.firstLogin = firstLogin
        self.healthKitIsOn = healthKitIsOn
        self.remindersEnabled = remindersEnabled
        self.notificationsEnabled = notificationsEnabled
        self.age = age
        self.goal = goal
        self.gender = gender
        self.idealPlan = idealPlan
        self.reminderDate = reminderDate
        self.exercisesThisWeek = exercisesThisWeek
        self.completedExercises = completedExercises
        self.totalTimeExercising = totalTimeExericising
        self.weight = weight
        self.averageHeartRate = averageHeartRate
        self.caloriesBurnedToday = caloriesBurnedToday
        self.totalCaloriesBurned = totalCaloriesBurned
        self.weightsForWeeklyPlot = weightsForWeeklyPlot
        self.caloriesBurnedThisWeek = caloriesBurnedThisWeek
        self.lastDate = lastDate
    }
}
