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
        gradient.frame = view.bounds
        
        view.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView {

    func addGradient(colors: [UIColor], locations: [NSNumber]) {
        addSubview(ViewWithGradient(addTo: self, colors: colors, locations: locations))
    }
}

class ViewWithGradient: UIView {

    private var gradient = CAGradientLayer()

    init(addTo parentView: UIView, colors: [UIColor], locations: [NSNumber]){

        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 2))
        restorationIdentifier = "__ViewWithGradient"

        for subView in parentView.subviews {
            if let subView = subView as? ViewWithGradient {
                if subView.restorationIdentifier == restorationIdentifier {
                    subView.removeFromSuperview()
                    break
                }
            }
        }

        let cgColors = colors.map { (color) -> CGColor in
            return color.cgColor
        }

        gradient.frame = parentView.frame
        gradient.colors = cgColors
        gradient.locations = locations
        backgroundColor = .clear

        parentView.addSubview(self)
        parentView.layer.insertSublayer(gradient, at: 0)
        parentView.backgroundColor = .clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        clipsToBounds = true
        parentView.layer.masksToBounds = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let parentView = superview {
            gradient.frame = parentView.bounds
        }
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        gradient.removeFromSuperlayer()
    }
}
