//
//  HomeViewController.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 08/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import UIKit
import Alamofire
import Koloda
import SwiftyJSON
import SideMenu
import MaterialComponents

private var numberOfCards: Int = 5

class HomeViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!
    
    @IBOutlet var crossButton: MDCFloatingButton!
    @IBOutlet var heartButton: MDCFloatingButton!
    @IBOutlet var challengeBtn: MDCFloatingButton!
    @IBOutlet var createChallengeBtn: MDCFloatingButton!
    
    var challengeViewModel = ChallengeListViewModel()
    var currentCardIndex = 0
    var nextImage = UIImage()
    
    //fileprivate var dataSource = [[String]]()  // description, image, challengeId, userId
    fileprivate var userId = UserDefaults.standard.string(forKey: "userId")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        challengeViewModel.fetchData {
            self.kolodaView.reloadData()
        }
        
        /*for challenge in challengeViewModel.challenges! {
            dataSource.append(["demo description", challenge.picture!,"","",""])
        }*/
        
        /*Alamofire.request("http://\(UserDefaults.standard.string(forKey: "ipAddress")!):8080/api/users/\(userId)/myChallengeList") .responseJSON { response in
            if let data = response.result.value {
                let json = JSON(data)["content"]
                for challenge in json {
                    let challengeId = challenge.1["id"].string
                    let userId = challenge.1["userId"].string
                    let challengeDescription = challenge.1["challengeDescription"].string
                    let challengeName = challenge.1["challengeName"].string
                    self.dataSource.append([challengeDescription!,challenge.1["ownerChallengeImageLink"].string!,challengeId!,userId!,challengeName!])
                }
            }
        }*/
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
    }
    
    func setupUI() {
        createChallengeBtn.backgroundColor = UIColor(red: 40/255, green: 53/255, blue: 147/255, alpha: 1)
        createChallengeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        crossButton.setImage(UIImage(named:"cross"), for: UIControlState.normal)
        crossButton.setImage(UIImage(named:"cross"), for: UIControlState.highlighted)
        crossButton.imageView?.contentMode = .scaleAspectFit
        heartButton.setImage(UIImage(named:"heart"), for: UIControlState.normal)
        heartButton.setImage(UIImage(named:"heart"), for: UIControlState.highlighted)
        heartButton.imageView?.contentMode = .scaleAspectFit
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
            let currentChallenge = challengeViewModel.challengeList[currentCardIndex]
            destinationVC.hasContent = true
            destinationVC.imageURL = currentChallenge.image!
            destinationVC.text = currentChallenge.description!
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
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print("swiped at index \(index), with direction \(direction)")
        currentCardIndex += 1
        if direction.rawValue == "right" {
            let currentChallenge = challengeViewModel.challengeList[currentCardIndex]
            let challengeId = currentChallenge.id!
            let challengeName = currentChallenge.name!
            let params : Parameters = ["challengeId":challengeId,"challengeName":challengeName]
            Alamofire.request("http://\(UserDefaults.standard.string(forKey: "ipAddress")!):8080/api/users/\(userId)/savedChallengeList",method:.post, parameters: params,encoding:JSONEncoding.default) .responseString { response in // 1
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
        return challengeViewModel.challengeList.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let albumView = Bundle.main.loadNibNamed("AlbumView", owner: self, options: nil)?[0] as? AlbumView
        albumView?.layer.borderColor = UIColor.gray.cgColor
        albumView?.layer.borderWidth = 1
        let url = URL(string: challengeViewModel.challengeList[Int(index)].image!)
        //print(url)
        let data = try? Data(contentsOf: url!)
        albumView?.photoView.image = UIImage(data:data!)
        albumView?.descriptionView.text = challengeViewModel.challengeList[Int(index)].description
        return albumView!
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
