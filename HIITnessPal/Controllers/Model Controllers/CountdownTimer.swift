//
//  CountdownTimer.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/21/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

// Protocol for tracking timer functions.
protocol CountdownTimerDelegate: class {
    // Function used to update timer labels.
    func countdownTime(time: (minutes: String, seconds: String))
    // Function used to update the given timer image.
    func updateTimerImage(percentage: Double)
    // Function used to move from one exercise to the next.
    func killTimer()
}

class CountdownTimer {
    
    // Singleton to access the timer specific variable and functions.
    static let sharedInstance = CountdownTimer()
    
    // Timer delegate to access the protocol functions.
    weak var delegate: CountdownTimerDelegate?
    
    // Countdown timer variables.
    var minutes: String = "00"
    var seconds: String = "00"
    var newTimer: Bool = true
    var duration: Double = 0
    var timeInterval: Double = 0.01
    lazy var currentTime: Double = duration
    var percentageComplete: Double = 0
    
    // Set timer variable.
    lazy var timer: Timer = {
        let timer = Timer()
        return timer
    }()
    
    // Function to start the timer and run the delegate functions.
    func startTimer() {
        // Set the bool from the controller to check whether a new timer is needed or not.
        newTimer = CountdownTimer.sharedInstance.newTimer
        // If a new timer is needed, reset the timer variables.
        if newTimer {
            duration = CountdownTimer.sharedInstance.duration
            currentTime = duration
            percentageComplete = 0
            CountdownTimer.sharedInstance.newTimer = false
        }
        // Start the timer
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (timer) in
            // Set the minutes and the seconds from the total run time.
            let minutesInt = Int( self.currentTime ) / 60
            let secondsInt = Int( self.currentTime ) % 60
            // Update the given minutes and seconds labels from the above set values at each whole number.
            if ceil(self.currentTime) == self.currentTime {
                self.minutes = "\(minutesInt)"
                self.seconds = "\(secondsInt)"
            }
            // Run the protocol function to update the minutes and seconds labels.
            self.delegate?.countdownTime(time: (minutes: self.minutes, seconds: self.seconds))
            // Run the protocol function to update the timer image as it winds down.
            self.delegate?.updateTimerImage(percentage: self.percentageComplete)
            
            // Reduce the total time remaining by the given time interval.
            self.currentTime -= self.timeInterval
            // Round off the above interval to avoid decimal errors.
            self.currentTime = floor( self.currentTime / self.timeInterval) * self.timeInterval
            // Define a variable for the remaining percentage of time.
            self.percentageComplete = (1 - self.currentTime/self.duration)
            // Run the protocol function to kill the timer and move on to the next exercise after the current timer ends.
            if self.currentTime < 0.0 {
                self.delegate?.killTimer()
            }
        })
    }
    
    // Function used to stop the timer.
    func stop() {
        timer.invalidate()
    }
}
