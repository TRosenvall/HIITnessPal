//
//  Exercise.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/20/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit
import CloudKit

class Exercise {
    
    // Exercise Variables and Constants
    let name: String
    let description: String
    let image: UIImage
    var rest: Timer
    var duration: Timer

    // Exercise Profile Initializer
    init(name: String,
         description: String,
         image: UIImage,
         rest: Timer,
         duration: Timer) {
        self.name = name
        self.description = description
        self.image = image
        self.rest = rest
        self.duration = duration
    }
}

