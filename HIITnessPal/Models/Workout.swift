//
//  Workout.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/21/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit
import CloudKit



class Workout {
    
    
    var name: String
    var description: String
    var duration: Int
    var rest: Int
    let image: String
    let gif: String
    
    
    init(name: String, description: String, duration: Int = 30, rest: Int = 10, image: String, gif: String) {
        
        self.name = name
        self.description = description
        self.duration = duration
        self.rest = rest
        self.image = image
        self.gif = gif
        
    }
    
}

