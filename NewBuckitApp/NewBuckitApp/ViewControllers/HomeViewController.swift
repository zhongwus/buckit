//
//  HomeViewController.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 08/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import UIKit
import MaterialComponents
import Alamofire
import Koloda
import SwiftyJSON
import SideMenu

private var numberOfCards: Int = 5

class HomeViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!
    
    @IBOutlet var crossButton: UIButton!
    @IBOutlet var heartButton: UIButton!
    
    var challengeViewModel = ChallengeViewModel()
    var currentCardIndex = 0
    
    fileprivate var dataSource: [(String,UIImage,String,String)] = []  // description, image, challengeId, userId
    fileprivate var savedChallengeList = [String]() // savedChallengeListId, originalchallengeId
    fileprivate var userId = "59febace4c638932592030ff"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("homeviewloaded")
        for challenge in challengeViewModel.challenges! {
            let url = URL(string:challenge.picture!)
            let data = try? Data(contentsOf: url!)
            //dataSource.append(UIImage(data:data!)!)
            dataSource.append(("demo description", UIImage(data:data!)!,"",""))
        }
        
        Alamofire.request("http://localhost:8080/api/users/\(userId)/savedChallengeList") .responseJSON { response in // 1
            if let data = response.result.value {
                //let json = JSON(data).array
                let json = JSON(data)["content"]
                for savedChallenge in json {
                    self.savedChallengeList.append(savedChallenge.1["challengeId"].string!)
                }
                
                
            }
            
            Alamofire.request("http://localhost:8080/api/challenges") .responseJSON { response in // 1
                if let data = response.result.value {
                    //let json = JSON(data).array
                    let json = JSON(data)["content"]
                    
                    for challenge in json {
                        let challengeId = challenge.1["id"].string
                        let userId = challenge.1["userId"].string
                        if self.savedChallengeList.contains(challengeId!) || self.userId == userId {
                            continue
                        }
                        let url = URL(string: challenge.1["ownerChallengeImageLink"].string!)
                        let data = try? Data(contentsOf: url!)
                        let challengeDescription = challenge.1["challengeDescription"].string
                        self.dataSource.append((challengeDescription!,UIImage(data:data!)!,challengeId!,userId!))
                        
                    }
                }
            }
        }
        
        
        
        // Do any additional setup after loading the view.
        crossButton.setImage(UIImage(named:"cross"), for: UIControlState.normal)
        heartButton.setImage(UIImage(named:"heart"), for: UIControlState.normal)
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CreateChallengeViewController
        if segue.identifier == "challengeSegue" {
            destinationVC.hasContent = true
            destinationVC.image = dataSource[currentCardIndex].1
            destinationVC.text = dataSource[currentCardIndex].0
        }
    }
    
    
    @IBAction func dislikeClicked(_ sender: Any) {
        kolodaView?.swipe(.left)
    }
    @IBAction func likeClicked(_ sender: Any) {
        kolodaView?.swipe(.right)
    }
    
    
    @IBAction func unwindToHomeViewController(segue:UIStoryboardSegue) {}
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: KolodaViewDelegate

extension HomeViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        /*let position = kolodaView.currentCardIndex
        for i in 1...4 {
            dataSource.append(UIImage(named: "Card_like_\(i)")!)
        }
        kolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)*/
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print("swiped at index \(index), with direction \(direction)")
        currentCardIndex += 1
        //self.dataSource[index].0
        if direction.rawValue == "right" {
            let challengeId = dataSource[index].2
            let params : Parameters = ["challengeId":challengeId]
            Alamofire.request("http://localhost:8080/api/users/\(userId)/savedChallengeList",method:.post, parameters: params,encoding:JSONEncoding.default) .responseString { response in // 1
                if (response.result.isSuccess) {
                    print("success")
                } else {
                    print("failed")
                }
            }
        }

    }
    
}

// MARK: KolodaViewDataSource

extension HomeViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let albumView = Bundle.main.loadNibNamed("AlbumView", owner: self, options: nil)?[0] as? AlbumView
        albumView?.layer.borderColor = UIColor.gray.cgColor
        albumView?.layer.borderWidth = 1
        albumView?.photoView.image = dataSource[Int(index)].1
        albumView?.descriptionView.text = dataSource[Int(index)].0
        return albumView!
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
