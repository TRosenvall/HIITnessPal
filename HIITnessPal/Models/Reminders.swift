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
    
    var enabled: Bool
    var uuid: String
    var fireDate: Date
    
    var fireTimeAsString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: fireDate)
    }
    
    init(fireDate: Date, enabled: Bool, uuid: String = UUID().uuidString) {
        self.fireDate = fireDate
        self.enabled = enabled
        self.uuid = uuid
    }
    
    static func ==(lhs: Reminder, rhs: Reminder) -> Bool {
        return lhs.uuid == rhs.uuid
        
    }
}
