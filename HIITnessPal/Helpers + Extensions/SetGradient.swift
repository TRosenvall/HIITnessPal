//
//  SetGradient.swift
//  HIITnessPal
//
//  Created by Leah Cluff on 9/5/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import UIKit

class SetGradient {
    
    static func setGradient(view: UIView, mainColor: UIColor, secondColor: UIColor) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [mainColor.cgColor, secondColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        
        view.layer.insertSublayer(gradient, at: 0)
    }
}
