//
//  WorkoutsController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/28/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import Foundation

class WorkoutsController {
    
    // Singleton to access the number of workouts.
    static let sharedInstance = WorkoutsController()
    
    // List of all the workouts.
    var totalWorkouts: [Workouts] = []
    
    // Function to create a new workout.
    func createWorkout (name: String, workouts: [Workout], multiplier: Int) {
        let workouts = Workouts(name: name, multiplier: multiplier, workouts: workouts)
        totalWorkouts.append(workouts)
    }
    
    // Function to update any given workout.
    func updateWorkout (workout: Workouts, name: String, workouts: [Workout], multiplier: Int) {
        workout.name = name
        workout.workouts = workouts
        workout.multiplier = multiplier
    }
}
