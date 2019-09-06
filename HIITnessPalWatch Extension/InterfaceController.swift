//
//  InterfaceController.swift
//  HIITnessPalWatch Extension
//
//  Created by Timothy Rosenvall on 9/6/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        heartRateLabel.setText("Detecting...")
        print("----")
        print("Setup sendHeartRateObserver")
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel), name: NSNotification.Name("sendHeartRate"), object: nil)
        print("----")
    }
    
    @objc func updateLabel(notification: NSNotification) {
        print("Updating heart rate on watch")
        let heartRate = notification.object
        if let heartRate = heartRate {
            heartRateLabel.setText("\(heartRate) bpm")
        } else {
            heartRateLabel.setText("Detecting...")
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
