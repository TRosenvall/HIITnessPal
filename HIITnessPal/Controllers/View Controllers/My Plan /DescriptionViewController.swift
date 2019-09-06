//
//  DescriptionViewController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/29/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var HeaderTitleLabel: UILabel!
    @IBOutlet weak var workoutInfoLabel: UILabel!
    @IBOutlet weak var exerciseImageView: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var exerciseLandingPad: Workout?{
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          SetGradient.setGradient(view: titleView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func updateViews() {
        guard let exercise = exerciseLandingPad else {return}
        loadViewIfNeeded()
        HeaderTitleLabel.text = exercise.name
        workoutInfoLabel.text = exercise.description
        exerciseImageView.image = UIImage(named: exercise.image)
    }
    

    @IBAction func saveButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
