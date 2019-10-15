//
//  Workouts.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/28/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import Foundation
import CloudKit

class Workouts: Codable {
    
    // Workouts Variables
    var name: String
    var multiplier: Int
    var workouts: [Workout]
    
    // Workouts Initializer
    init(name: String,
         multiplier: Int,
         workouts: [Workout]) {
        self.name = name
        self.multiplier = multiplier
        self.workouts = workouts
    }
}

extension Workouts: Equatable {
    static func == (lhs: Workouts, rhs: Workouts) -> Bool {
        return lhs.multiplier == rhs.multiplier && lhs.name == rhs.name && lhs.workouts == rhs.workouts
    }
}
