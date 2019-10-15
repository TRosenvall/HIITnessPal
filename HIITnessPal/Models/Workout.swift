//
//  Workout.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/21/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit
import CloudKit

class Workout: Codable {
    
    // Workout Variables and Constants
    let gif: Int
    var name: String
    let image: String
    var description: String
    var rest: Int
    var duration: Int
    
    // Workout Initializer
    init(gif: Int,
         name: String,
         image: String,
         description: String,
         rest: Int = 10,
         duration: Int = 30) {
        self.gif = gif
        self.name = name
        self.image = image
        self.description = description
        self.rest = rest
        self.duration = duration
    }
}

extension Workout: Equatable {
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.description == rhs.description && lhs.duration == rhs.duration && lhs.gif == rhs.gif && lhs.name == rhs.name && lhs.image == rhs.image && lhs.rest == rhs.rest
    }
}

