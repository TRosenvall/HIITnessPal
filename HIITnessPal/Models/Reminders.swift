//
//  Reminder.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 9/1/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import Foundation
import CloudKit

class Reminder: Equatable, Codable {
    
    // Reminder Variables
    var uuid: String
    var enabled: Bool
    var fireDate: Date
    
    // Reminder Date
    var fireTimeAsString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: fireDate)
    }
    
    // Reminder Initializer
    init(uuid: String = UUID().uuidString,
         enabled: Bool,
         fireDate: Date) {
        self.uuid = uuid
        self.enabled = enabled
        self.fireDate = fireDate
    }
    
    // Reminder Equatablility
    static func ==(lhs: Reminder, rhs: Reminder) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
