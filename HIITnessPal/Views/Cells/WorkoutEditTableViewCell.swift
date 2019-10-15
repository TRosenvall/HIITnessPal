//
//  WorkoutEditTableViewCell.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class WorkoutEditTableViewCell: UITableViewCell {

    // Set IBOutlets
    @IBOutlet weak var workoutView: UIView!
    @IBOutlet weak var restView: UIView!
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var workoutTitle: UILabel!
    @IBOutlet weak var workoutSubtractionButton: UIButton!
    @IBOutlet weak var workoutTimeLabel: UILabel!
    @IBOutlet weak var workoutAdditionButton: UIButton!
    @IBOutlet weak var restImageView: UIImageView!
    @IBOutlet weak var restTitleLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var restAdditionButton: UIButton!
    @IBOutlet weak var restSubtractionButton: UIButton!
    
    // Set Variables
    var workout: Workout? = nil
    
    // Subtracts one second from the duration of the exercise listed and updates it's time labels.
    @IBAction func workoutTimeSubtractButtonTapped(_ sender: Any) {
        if workout!.duration > 1 {
            workout?.duration -= 1
        }
        
        guard let duration = workout?.duration else {return}
        
        let minutes = duration / 60
        let seconds = duration % 60
        
        workoutTimeLabel.text = "\(minutes):\(seconds)"
    }
    
    // Adds one second from the duration of the exercise listed and updates it's time labels.
    @IBAction func workoutTimeAddButtonTapped(_ sender: Any) {
        workout?.duration += 1
        
        guard let duration = workout?.duration else {return}
        
        let minutes = duration / 60
        let seconds = duration % 60
        
        workoutTimeLabel.text = "\(minutes):\(seconds)"
    }
    
    // Subtracts one second from the duration of the rest listed and updates it's time labels.
    @IBAction func restTimeSubtractButtonTapped(_ sender: Any) {
        if workout!.rest > 1 {
            workout?.rest -= 1
        }
        
        guard let rest = workout?.rest else {return}
        
        let minutes = rest / 60
        let seconds = rest % 60
        
        restTimeLabel.text = "\(minutes):\(seconds)"
    }
    
    // Adds one second from the duration of the rest listed and updates it's time labels.
    @IBAction func restTimeAddButtonTapped(_ sender: Any) {
        workout?.rest += 1
        
        guard let rest = workout?.rest else {return}
        
        let minutes = rest / 60
        let seconds = rest % 60
        
        restTimeLabel.text = "\(minutes):\(seconds)"
    }
}
