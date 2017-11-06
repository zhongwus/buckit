//
//  RightSideBarViewController.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 31/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RightSideBarViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    fileprivate var savedChallengeList = [String]()
    fileprivate var userId = "59febace4c638932592030ff"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("http://localhost:8080/api/users/\(userId)/savedChallengeList") .responseJSON { response in // 1
            if let data = response.result.value {
                //let json = JSON(data).array
                let json = JSON(data)["content"]
                for savedChallenge in json {
                    self.savedChallengeList.append(savedChallenge.1["challengeId"].string!)
                }
                self.tableView.reloadData()
                
            }
        }
        tableView.backgroundColor = UIColor.black
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.tableFooterView = UIView()
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedChallengeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = self.savedChallengeList[indexPath.row]
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: false, completion: { })
        performSegue(withIdentifier: "challengeDetailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "challengeDetailSegue" {
            let destinationVC = segue.destination as! ChallengeDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.challengeId = self.savedChallengeList[indexPath.row]
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
