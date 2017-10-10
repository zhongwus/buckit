//
//  MainNavigationController.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 08/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import UIKit
import FacebookCore

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if isLoggedIn() {
            let storyboard = UIStoryboard(name:"Main",bundle:nil)
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController")
            viewControllers = [homeViewController]
        } else {
            perform(#selector(showLoginViewController), with: nil, afterDelay: 0.01)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func isLoggedIn() -> Bool {
        print(AccessToken.current)
        if let accessToken = AccessToken.current {
            print(accessToken)
            print("logged innnnn")
            return true
        } else {
            print("not logged innnn")
            return false
        }
    }
    
    @objc func showLoginViewController() {
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true, completion: {
            
        })
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
