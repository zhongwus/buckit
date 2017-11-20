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
import MaterialComponents

class LoginViewController: UIViewController {

    @IBOutlet var fbLoginBtn: MDCRaisedButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .yellow
        view.backgroundColor = UIColor(patternImage: UIImage(named:"loginImage")!)
        fbLoginBtn.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @objc func loginButtonClicked() {
        
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
                        let params: Parameters = ["firstName":json["first_name"].string,"lastName":json["last_name"].string,"emailAddress":json["email"].string,"score":0,"profilePictureLink":json["picture"]["data"]["url"].string]

                        Alamofire.request("http://\(UserDefaults.standard.string(forKey: "ipAddress")!):8080/api/users/",method: .post, parameters: params,encoding: JSONEncoding.default) .responseString { response in // 1
                            if (response.result.isSuccess) {
                                if let id = response.result.value {
                                    let defaults = UserDefaults.standard
                                    defaults.set(id, forKey: "userId")
                                    defaults.set(json["first_name"].string,forKey:"first_name")
                                    defaults.set(json["last_name"].string,forKey:"last_name")
                                    defaults.set(json["email"].string,forKey:"email")
                                    defaults.set(json["picture"]["data"]["url"].string,forKey:"profilePictureLink")
                                     /*let storyboard = UIStoryboard(name:"Main",bundle:nil)
                                     let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "mainNavigationController")
                                     mainNavigationController.modalTransitionStyle = .flipHorizontal
                                     let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                     appDelegate.window?.rootViewController = mainNavigationController*/
                                    self.performSegue(withIdentifier: "gotoMainPageSegue", sender: self)
                                }
                            } else {
                             print("Login Failed")
                            }
                        }
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
