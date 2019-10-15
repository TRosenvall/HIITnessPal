//
//  CompletedWorkoutsController.swift
//  HIITnessPal
//
//  Created by Timothy Rosenvall on 10/9/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation

class CompletedWorkoutsController {
    
    static let sharedInstance = CompletedWorkoutsController()
    
    var completedWorkouts: [CompletedWorkout] = []
    
    func createCompletedWorkout (name: String, calories: String, time: String, heartRate: String) {
        let completedWorkout = CompletedWorkout(name: name, calories: calories, time: time, heartRate: heartRate)
        completedWorkouts.append(completedWorkout)
        saveToPersistentStore()
    }
    
    func deleteCompletedWorkout (workout: CompletedWorkout) {
        guard let index = completedWorkouts.firstIndex(of: workout) else { return }
        completedWorkouts.remove(at: index)
        saveToPersistentStore()
    }
    
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "completedWorkouts.json"
        let url = documentDirectory.appendingPathComponent(fileName)
        return url
    }
    
    func saveToPersistentStore() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let data = try jsonEncoder.encode(completedWorkouts)
            try data.write(to: fileURL())
        } catch let error {
            print("Error saving to persistent store: \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore(completion: @escaping (Bool) -> Void) {
        let jsonDecoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL())
            let decodedProfile = try jsonDecoder.decode([CompletedWorkout].self, from: data)
            CompletedWorkoutsController.sharedInstance.completedWorkouts = decodedProfile
            completion(true)
        } catch let error {
            print("Error loading from persistent store: \(error.localizedDescription)")
            completion(false)
        }
    }
}
