//
//  Workouts.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/28/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import Foundation
import CloudKit



class Workouts {
    
    var name: String
    var workouts: [Workout]
    var multiplier: Int
    
    init(name: String, workouts: [Workout], multiplier: Int) {
        self.name = name
        self.workouts = workouts
        self.multiplier = multiplier
    }
}
