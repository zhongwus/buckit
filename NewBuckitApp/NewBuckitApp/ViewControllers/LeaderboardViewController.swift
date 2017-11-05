//
//  LeaderBoardViewController.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 31/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var score: UILabel!
    @IBOutlet var rank: UILabel!
    @IBOutlet var friendsLabel: UIButton!
    
    var users: [(String,Int)] = []
    var userInfo = Dictionary<String, Any>()
    fileprivate var userId = "59fe787ad5620f18b97c5a6e"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfo["numOfFriends"] = ""
        Alamofire.request("http://10.0.0.192:8080/api/users") .responseJSON { response in // 1
            if let data = response.result.value {
                //let json = JSON(data).array
                let json = JSON(data)["content"]
                for user in json {
                    let name = user.1["firstName"].string! + " " + user.1["lastName"].string!
                    let score = user.1["score"].int
                    self.users.append((name,score!))
                    
                    if user.1["id"].string == self.userId {
                        //self.name.text = name
                        //self.score.text = String(describing: score) + " Pts."
                        
                        self.userInfo["name"] = name
                        self.userInfo["score"] = score
                        self.userInfo["profileImageLink"] = user.1["profilePictureLink"].string!
                    }
                    
                }
                self.users.sort(by: {$0.1 > $1.1})
                let index = self.users.index(where: {user -> Bool in
                    user.0 == self.userInfo["name"] as! String
                })
                self.userInfo["rank"] = index! + 1
                self.userInfo["totalNumOfUser"] = self.users.count
                
                self.tableView.reloadData()
                
                Alamofire.request("http://10.0.0.192:8080/api/users/\(self.userId)/friends") .responseJSON { response in // 1
                    if let data = response.result.value {
                        let json = JSON(data)["content"]
                        self.userInfo["numOfFriends"] = json.count
                        self.updateProfileView()
                    }
                }
            }
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateProfileView() {
        name.text = userInfo["name"] as! String
        //profileImage: UIImageView!
        Alamofire.request(userInfo["profileImageLink"] as! String).response { response in
            self.profileImage.image = UIImage(data: response.data!, scale:1)
        }
        
        score.text = String(describing: userInfo["score"]!) + " Pts."
        rank.text = "Rank: " + String(describing: userInfo["rank"]!) + "/" + String(describing: userInfo["totalNumOfUser"]!)
        friendsLabel.setTitle(String(describing: userInfo["numOfFriends"]!) + " Friends", for: .normal)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "userCell") as! LeaderboardTableViewCell
        let right = String(users[indexPath.row].1) + "Pts."
        let left = "\(indexPath.row + 1). " + users[indexPath.row].0
        cell.userName.text = left
        cell.score.text = right

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
