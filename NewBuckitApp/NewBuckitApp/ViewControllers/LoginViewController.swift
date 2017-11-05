//
//  LoginViewController.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 08/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FacebookCore
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .yellow
        view.backgroundColor = UIColor(patternImage: UIImage(named:"background1")!)
        let myLoginButton = UIButton(type: .custom)
        myLoginButton.backgroundColor = UIColor(red:0.05, green:0.20, blue:0.37, alpha:1.0)
        myLoginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
        myLoginButton.center = view.center
        myLoginButton.setTitle("Facebook Login", for: .normal)
        myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        view.addSubview(myLoginButton)
        
        // Do any additional setup after loading the view.
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loginButtonClicked() {
        print("starting...")
        let loginManager = LoginManager()

        loginManager.logIn(readPermissions: [ .email, .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email, first_name,last_name, picture.type(large)"])
                graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                    
                    if ((error) != nil)
                    {
                        // Process error
                        print("fail")
                        print("Error: \(error)")
                    }
                    else
                    {
                        let json = JSON(result)
                        print(json)
                        let defaults = UserDefaults.standard
                        defaults.set(json["first_name"].string, forKey: "first_name")
                        defaults.set(json["last_name"].string, forKey: "last_name")
                        defaults.set(json["email"].string, forKey: "email")
                        defaults.set(json["picture"]["data"]["url"].string, forKey: "avatarURL")
                        let params: Parameters = ["firstName":json["first_name"].string,"lastName":json["first_name"].string,"emailAddress":json["email"].string,"score":0,"profilePictureLink":json["picture"]["data"]["url"].string]

                        /*Alamofire.request("http://10.0.0.105:8080/api/users/",method: .post, parameters: params,encoding: JSONEncoding.default) .responseString { response in // 1
                            if (response.result.isSuccess) {
                                let storyboard = UIStoryboard(name:"Main",bundle:nil)
                                let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "mainNavigationController")
                                mainNavigationController.modalTransitionStyle = .flipHorizontal
                                self.present(mainNavigationController, animated: true, completion: nil)
                            } else {
                             print("Login Failed")
                            }
                        }*/
                        let storyboard = UIStoryboard(name:"Main",bundle:nil)
                        let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "mainNavigationController")
                        mainNavigationController.modalTransitionStyle = .flipHorizontal
                        self.present(mainNavigationController, animated: true, completion: nil)
                        
                        
                    }
                })
            }
            
        }
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
