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
        saveToPersistentStore()
    }
    
    // Function to update any given workout.
    func updateWorkout (workout: Workouts, name: String, workouts: [Workout], multiplier: Int) {
        workout.name = name
        workout.workouts = workouts
        workout.multiplier = multiplier
        saveToPersistentStore()
    }
    
    func deleteWorkout(workout: Workouts) {
        guard let indexPath = totalWorkouts.firstIndex(of: workout) else {return}
        totalWorkouts.remove(at: indexPath)
        saveToPersistentStore()
    }
    
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "workouts.json"
        let url = documentDirectory.appendingPathComponent(fileName)
        return url
    }
    
    func saveToPersistentStore() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let data = try jsonEncoder.encode(totalWorkouts)
            try data.write(to: fileURL())
        } catch let error {
            print("Error saving to persistent store: \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore(completion: @escaping (Bool) -> Void) {
        let jsonDecoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL())
            let decodedProfile = try jsonDecoder.decode([Workouts].self, from: data)
            WorkoutsController.sharedInstance.totalWorkouts = decodedProfile
            completion(true)
        } catch let error {
            print("Error loading from persistent store: \(error.localizedDescription)")
            completion(false)
        }
    }
}
