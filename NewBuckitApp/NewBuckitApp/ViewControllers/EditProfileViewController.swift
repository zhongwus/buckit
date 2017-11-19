//
//  EditProfileViewController.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 05/11/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditProfileViewController: UIViewController {
    
    fileprivate var userId = UserDefaults.standard.string(forKey: "userId")!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Alamofire.request("http://\(UserDefaults.standard.string(forKey: "ipAddress")!):8080/api/users/\(userId)") .responseJSON { response in // 1
            if let data = response.result.value {
                let json = JSON(data)["content"]
                self.firstNameTextField.text = json["firstName"].string!
                self.lastNameTextField.text = json["lastName"].string!
                self.emailTextField.text = json["emailAddress"].string!
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveClicked(_ sender: Any) {
        
        let params: Parameters = [
            "firstName":firstNameTextField.text ?? "",
            "lastName":lastNameTextField.text ?? "",
            "emailAddress":emailTextField.text ?? ""
        ]
        Alamofire.request("http://\(UserDefaults.standard.string(forKey: "ipAddress")!):8080/api/users/\(userId)",method:.patch,parameters:params,encoding: JSONEncoding.default) .responseJSON { response in // 1
            if response.result.isSuccess {
                self.dismiss(animated: true, completion: nil)
                UserDefaults.standard.set(params["firstName"], forKey: "first_name")
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
