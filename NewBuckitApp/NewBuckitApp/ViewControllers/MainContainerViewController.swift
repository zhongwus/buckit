//
//  MainNavigationViewController.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 29/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import UIKit
import SideMenu

class MainContainerViewController: UIViewController {
    
    @IBOutlet var mainContentView: UIView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        print("called from main container")
        SideMenuManager.default.menuLeftNavigationController = storyboard.instantiateViewController(withIdentifier: "leftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuRightNavigationController = storyboard.instantiateViewController(withIdentifier: "rightMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = 0.5
        //SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        //SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        add(asChildViewController: homeViewController)
        
        defaults.set("home", forKey: "pageName")
        UserDefaults.standard.addObserver(self, forKeyPath: "pageName", options: NSKeyValueObservingOptions.new, context: nil)
        


        // Do any additional setup after loading the view.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let pageName = defaults.string(forKey: "pageName") {
            switch pageName {
            case "home":
                remove(asChildViewController: profileViewController)
                remove(asChildViewController: leaderboardController)
                add(asChildViewController: homeViewController)
            case "profile":
                remove(asChildViewController: homeViewController)
                remove(asChildViewController: leaderboardController)
                add(asChildViewController: profileViewController)
            case "leaderboard":
                remove(asChildViewController: homeViewController)
                remove(asChildViewController: profileViewController)
                add(asChildViewController: leaderboardController)
            default:
                remove(asChildViewController: profileViewController)
                remove(asChildViewController: leaderboardController)
                add(asChildViewController: homeViewController)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private lazy var homeViewController: HomeViewController = {
        
        // Instantiate View Controller
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        var viewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var profileViewController: ProfileViewController = {
        
        // Instantiate View Controller
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        var viewController = storyboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var leaderboardController: LeaderboardViewController = {
        
        // Instantiate View Controller
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        var viewController = storyboard.instantiateViewController(withIdentifier: "leaderboardViewController") as! LeaderboardViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
