//
//  WorkoutCompleteViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 9/2/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class WorkoutCompleteViewController: UIViewController {

    // Set IBOutlets
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var calorieCount: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var averageHeartRate: UILabel!
    
    // Variable - Time placeholder.
    var time: Double = 0
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the title view's gradient and shadows.
        SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // Set the total time from the WorkoutTimerViewController
        time = WorkoutTimerViewController.totalTime
        // Set the minutes and seconds strings for the total time.
        let minutesString = "\( Int(time / 60) )"
        let secondsString = "\(Int(time.truncatingRemainder(dividingBy: 60.0)))"
        totalTime.text = minutesString + ":" + secondsString
        // Reset the totalTime for the next workout.
        WorkoutTimerViewController.totalTime = 0
    }
    
    // Dismiss the current view controller and it's parent view controller.
    @IBAction func backButtonTapped(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // Dismiss the current view controller and it's parent view controller.
    // TODO: - Make saving do something.
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
