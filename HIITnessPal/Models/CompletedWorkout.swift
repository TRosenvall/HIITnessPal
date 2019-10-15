//
//  CompletedWorkout.swift
//  HIITnessPal
//
//  Created by Timothy Rosenvall on 10/9/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation

class CompletedWorkout: Codable {
    
    let name: String
    let calories: String
    let time: String
    let heartRate: String
    
    init(name: String, calories: String, time: String, heartRate: String) {
        self.name = name
        self.calories = calories
        self.time = time
        self.heartRate = heartRate
    }
}

extension CompletedWorkout: Equatable {
    static func == (lhs: CompletedWorkout, rhs: CompletedWorkout) -> Bool {
        return lhs.name == rhs.name && lhs.calories == rhs.calories && lhs.time == rhs.time && lhs.heartRate == rhs.heartRate
    }
}
