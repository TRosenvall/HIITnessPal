//
//  MainTabBarViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/23/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    static var finishedExercise = 0
    
    @IBOutlet weak var mainTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTabBar.shadowImage = UIImage()
        mainTabBar.backgroundImage = UIImage()
        mainTabBar.layer.backgroundColor = UIColor.getHIITWhite.cgColor
        setTabBarItems()
    }
    
    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 110
        tabFrame.origin.y = self.view.frame.size.height - 110
        self.tabBar.frame = tabFrame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if MainTabBarViewController.finishedExercise == 1 {
            self.selectedIndex = 0
            MainTabBarViewController.finishedExercise = 0
        }
    }
    
    func setTabBarItems(){
        guard let font: UIFont = UIFont(name: "Nunito-Light", size: 14) else {return}
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .selected)
    }
}

