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

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    
    fileprivate var userId = UserDefaults.standard.string(forKey: "userId")!
    var tableContent = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("http://\(UserDefaults.standard.string(forKey: "ipAddress")!):8080/api/users/\(userId)") .responseJSON { response in // 1
            if let data = response.result.value {
                let json = JSON(data)["content"]
                self.nameLabel.text = json["firstName"].string! + " " + json["lastName"].string!
                Alamofire.request(json["profilePictureLink"].string!).response { response in
                    self.profileImage.image = UIImage(data: response.data!, scale:1)
                }
            }
        }
        
        Alamofire.request("http://\(UserDefaults.standard.string(forKey: "ipAddress")!):8080/api/users/\(userId)/challenges") .responseJSON { response in // 1
            if let data = response.result.value {
                let json = JSON(data)["content"]
                for challenge in json {
                    let challengeName = challenge.1["challengeName"].string!
                    self.tableContent.append([challengeName,"Owner"])
                }
                self.tableView.reloadData()
            }
            
        }
        
        Alamofire.request("http://\(UserDefaults.standard.string(forKey: "ipAddress")!):8080/api/users/\(userId)/completedChallengeList") .responseJSON { response in // 1
            if let data = response.result.value {
                let json = JSON(data)["content"]
                for challenge in json {
                    let challengeName = challenge.1["challengeName"].string!
                    self.tableContent.append([challengeName,"Completed"])
                }
                self.tableView.reloadData()
            }
            
        }
        
        Alamofire.request("http://\(UserDefaults.standard.string(forKey: "ipAddress")!):8080/api/users/\(userId)/savedChallengeList") .responseJSON { response in // 1
            if let data = response.result.value {
                let json = JSON(data)["content"]
                for challenge in json {
                    let challengeName = challenge.1["challengeName"].string!
                    self.tableContent.append([challengeName,"Saved"])
                }
                self.tableView.reloadData()
            }
            
        }
        
        UserDefaults.standard.addObserver(self, forKeyPath: "first_name", options: NSKeyValueObservingOptions.new, context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: "last_name", options: NSKeyValueObservingOptions.new, context: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        nameLabel.text = "\(UserDefaults.standard.string(forKey: "first_name")!) \(UserDefaults.standard.string(forKey: "last_name")!)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "challengeCell")
        cell?.textLabel?.text = tableContent[indexPath.row][0]
        cell?.detailTextLabel?.text = tableContent[indexPath.row][1]
        switch tableContent[indexPath.row][1] {
            case "Owner":
                cell?.detailTextLabel?.textColor = UIColor.gray
            case "Completed":
                cell?.detailTextLabel?.textColor = UIColor.green
            case "Saved":
                cell?.detailTextLabel?.textColor = UIColor.orange
            default:
                cell?.detailTextLabel?.textColor = UIColor.black
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
