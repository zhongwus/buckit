//
//  ChallengeDetailViewController.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 31/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChallengeDetailViewController: UIViewController {
    
    var challengeId = ""
    var challenge = Dictionary<String, Any>()
    @IBOutlet var challengeAlbumView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("http://\(UserDefaults.standard.string(forKey: "ipAddress")!):8080/api/challenges/\(challengeId)").responseJSON { response in
            if let data = response.result.value {
                self.challenge = JSON(data)["content"].dictionaryObject!
                Alamofire.request(self.challenge["ownerChallengeImageLink"] as! String).responseJSON { response in
                     //self.avatarImage.setImage(UIImage(data: response.data!, scale:1), for: .normal)
                    let albumView = Bundle.main.loadNibNamed("AlbumView", owner: self, options: nil)?[0] as? AlbumView
                    albumView?.layer.borderColor = UIColor.gray.cgColor
                    albumView?.layer.borderWidth = 1
                    albumView?.photoView.image = UIImage(data: response.data!, scale:1)
                    albumView?.descriptionView.text = self.challenge["challengeDescription"] as? String
                    albumView?.frame = self.challengeAlbumView.bounds
                    albumView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    self.challengeAlbumView.addSubview(albumView!)
                }
            }
        }
        
        /*albumView?.photoView.image = dataSource[Int(index)].1
        albumView?.descriptionView.text = dataSource[Int(index)].0*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CreateChallengeViewController
        if segue.identifier == "challengeSegue1" {
            destinationVC.hasContent = true
            destinationVC.imageURL = self.challenge["ownerChallengeImageLink"] as! String
            destinationVC.text = self.challenge["challengeDescription"] as! String
            destinationVC.challengeId = self.challenge["id"] as! String
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
