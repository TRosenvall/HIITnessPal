//
//  WorkoutTableViewCell.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/19/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exerciseView: UIView!
    @IBOutlet weak var restView: UIView!
    @IBOutlet weak var dotView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var exerciseTimeLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    
    @IBOutlet weak var exerciseImageView: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }    
}
