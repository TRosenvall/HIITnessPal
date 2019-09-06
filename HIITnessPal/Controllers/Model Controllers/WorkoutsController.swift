//
//  WorkoutsController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/28/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import Foundation

class WorkoutsController {
    
    static let sharedInstance = WorkoutsController()
    
    var totalWorkouts: [Workouts] = []
    
    func createWorkout (name: String, workouts: [Workout], multiplier: Int) {
        let workouts = Workouts(name: name, workouts: workouts, multiplier: multiplier)
        totalWorkouts.append(workouts)
    }
    
    func updateWorkout (workout: Workouts, name: String, workouts: [Workout], multiplier: Int) {
        workout.name = name
        workout.workouts = workouts
        workout.multiplier = multiplier
    }
    
    
    
}
