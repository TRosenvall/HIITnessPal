//
//  MainTabBarViewController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/23/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    // Outlet for the TabBar
    @IBOutlet weak var mainTabBar: UITabBar!
    
    // Static Variable used to set the TabBarController back to the dashboard after finishing a workout.
    static var finishedExercise = 0
    static var fromPast: Bool = false
    
    var tabBarItemOne: UITabBarItem = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Call the function to set the fonts for the tab bar titles.
        
        if ProfileController.sharedInstance.profile == nil {
            let profile = Profile()
            ProfileController.sharedInstance.profile = profile
        }
    }
    
    override func viewWillLayoutSubviews() {
        // Set the height variable for the tab bar, here it's defined as 110 points above it's normal.
        let height: CGFloat = 110
        var tabFrame: CGRect = self.tabBar.frame
        // Change the height of the tabBar, then move it up by that amount from the bottom.
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        // Set the new frame size here.
        self.tabBar.frame = tabFrame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTabBarItems()
        // If an exercise has been finished change the tab bar to the dashboard index, then reset the finishedExercise variable.
        if MainTabBarViewController.finishedExercise == 1 {
            self.selectedIndex = 0
            MainTabBarViewController.finishedExercise = 0
        }
        self.tabBar.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // If it's the first login, open up the AboutMeViewController to gather information.
        guard let profile = ProfileController.sharedInstance.profile else {return}
        if profile.firstLogin {
            let storyboard = UIStoryboard(name: "HiitnessProfile", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "AboutMeStoryboard")
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: false, completion: nil)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title!)
        let tabBarControllerItems = self.tabBar.items

        if let arrayOfTabBarItems = tabBarControllerItems as AnyObject as? NSArray{
            tabBarItemOne = arrayOfTabBarItems[1] as! UITabBarItem
            if item == tabBarItemOne {
                tabBarItemOne.image = #imageLiteral(resourceName: "MyPlanSelectedIcon")
                tabBarItemOne.title = "My Plan"
            } else {
                tabBarItemOne.image = #imageLiteral(resourceName: "MyPlanUnselectedIcon")
                tabBarItemOne.title = "My Plan"
            }
        }
    }
    
    // Function used to set the appropriate fonts and sizes for the tab bar item titles.
    func setTabBarItems(){
        // Remove the shadows from the tab bar, change the tab bar background to white.
        mainTabBar.shadowImage = UIImage()
        mainTabBar.backgroundImage = UIImage()
        mainTabBar.layer.backgroundColor = UIColor.getHIITWhite.cgColor
        // Set the new font and size for the unselected and selected properties of the tab bar items.
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.getHIITPrimaryOrange], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.getHIITGray], for: .normal)
    }
}

