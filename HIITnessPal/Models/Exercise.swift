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
    let name: String
    let description: String
    var duration: Timer
    let image: UIImage
    var rest: Timer
    
    
    init(name: String, description: String, duration: Timer, image: UIImage, rest: Timer) {
        self.name = name
        self.description = description
        self.duration = duration
        self.image = image
        self.rest = rest
    }
}

