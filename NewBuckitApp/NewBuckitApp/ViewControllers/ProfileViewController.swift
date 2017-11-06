//
//  ProfileViewController.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 29/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    
    fileprivate var userId = "59febace4c638932592030ff"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("http://localhost:8080/api/users/\(userId)") .responseJSON { response in // 1
            if let data = response.result.value {
                let json = JSON(data)["content"]
                self.nameLabel.text = json["firstName"].string! + " " + json["lastName"].string!
                Alamofire.request(json["profilePictureLink"].string!).response { response in
                    self.profileImage.image = UIImage(data: response.data!, scale:1)
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func editClicked(_ sender: Any) {
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
