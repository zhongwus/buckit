//
//  sideBarViewController.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 19/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class sideBarViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    let hamburgerMenuTitle: [String] = ["Home", "Leaderboard", "Log out"]
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImage.layer.borderWidth = 1
        avatarImage.layer.masksToBounds = false
        avatarImage.layer.borderColor = UIColor.black.cgColor
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
        avatarImage.clipsToBounds = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.tableFooterView = UIView()
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hamburgerMenuTitle.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if (cell?.textLabel?.text == "Log out") {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            let storyboard = UIStoryboard(name:"Main",bundle:nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "loginViewController")

            /*self.dismiss(animated: false, completion: {
                self.view.window?.rootViewController?.dismiss(animated: false, completion: {})
            })*/
            self.view.window?.rootViewController?.dismiss(animated: false, completion: {})
            self.view.window?.rootViewController = loginController
        } else if (cell?.textLabel?.text == "Home") {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = self.hamburgerMenuTitle[indexPath.row]
        /*switch self.hamburgerMenuTitle[indexPath.row] {
        case "Home":
            cell.imageView?.image = UIImage(named:"hamburger")
        default:
            cell.imageView?.image = UIImage(named:"heart")
        }*/
        return cell
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
