//
//  SelectWorkoutTableViewCell.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class SelectWorkoutTableViewCell: UITableViewCell {

    // Set IBOutlets
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var borderView: UIView!
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            // Pull the Appropriate storyboard with the needed view controller.
            let storyboard = UIStoryboard(name: "MyHiitnessPlan", bundle: nil)
            // Set our viewController as the CreateWorkoutViewController.
            let viewController = storyboard.instantiateViewController(withIdentifier: "workoutDescription")
            
            viewController.modalPresentationStyle = .fullScreen
            
            // Present the viewController outside of the navigation controller so as not to carry on the tab bar controller.
            SelectWorkoutViewController.fadeOutForCell { (success) in
                if success {
                    SelectWorkoutViewController.thisViewController.present(viewController, animated: false, completion: nil)
                }
            }
        }
    }
}
