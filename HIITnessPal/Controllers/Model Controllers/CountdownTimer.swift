//
//  CountdownTimer.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/21/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

protocol CountdownTimerDelegate: class {
    func countdownTime(time: (minutes: String, seconds: String))
    func updateTimerImage(percentage: Double)
    func killTimer()
}

class CountdownTimer {
    
    
    static let sharedInstance = CountdownTimer()
    
    var duration: Double = 0
    lazy var currentTime: Double = duration
    var timeInterval: Double = 0.01
    var minutes: String = "00"
    var seconds: String = "00"
    var percentageComplete: Double = 0
    var newTimer: Bool = true
    
    weak var delegate: CountdownTimerDelegate?
    
    lazy var timer: Timer = {
        let timer = Timer()
        return timer
    }()
    
    func startTimer() {
        newTimer = CountdownTimer.sharedInstance.newTimer
        if newTimer {
            duration = CountdownTimer.sharedInstance.duration
            currentTime = duration
            percentageComplete = 0
            CountdownTimer.sharedInstance.newTimer = false
        }
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (timer) in
            let minutesInt = Int( self.currentTime ) / 60
            let secondsInt = Int( self.currentTime   ) % 60
            if ceil(self.currentTime) == self.currentTime {
                self.minutes = "\(minutesInt)"
                self.seconds = "\(secondsInt)"
            }
            self.delegate?.countdownTime(time: (minutes: self.minutes, seconds: self.seconds))
            self.delegate?.updateTimerImage(percentage: self.percentageComplete)
            
            self.currentTime -= self.timeInterval
            self.currentTime = floor( self.currentTime / self.timeInterval) * self.timeInterval
            
            self.percentageComplete = (1 - self.currentTime/self.duration)
            
            if self.currentTime < 0.0 {
                self.delegate?.killTimer()
            }
        })
    }
    
    func pause() {
        timer.invalidate()
    }
    
    func stop() {
        timer.invalidate()
    }
}
