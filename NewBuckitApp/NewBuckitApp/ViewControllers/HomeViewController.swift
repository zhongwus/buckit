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
    
    @IBOutlet var TestButton: UIButton!
    @IBOutlet var crossButton: UIButton!
    @IBOutlet var heartButton: UIButton!
    
    var challengeViewModel = ChallengeViewModel()
    
    fileprivate var dataSource: [UIImage] = []
    
    //private var challengeViewModel = ChallengeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "leftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        //SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        //SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        
        for challenge in challengeViewModel.challenges! {
            let url = URL(string:challenge.picture!)
            let data = try? Data(contentsOf: url!)
            dataSource.append(UIImage(data:data!)!)
        }
        Alamofire.request("http://172.29.92.108:8080/api/challenges") .responseJSON { response in // 1
            //debugPrint("All Response Info: \(response)")
            
            if let data = response.result.value {
                let json = JSON(data).array
                print(json?.count)
                for challenge in json! {
                    let url = URL(string:challenge["challengeImageLink"].string!)
                    print(url)
                    let data = try? Data(contentsOf: url!)
                    self.dataSource.append(UIImage(data:data!)!)
                }
            }
        }

        // Do any additional setup after loading the view.
        crossButton.setImage(UIImage(named:"cross"), for: UIControlState.normal)
        heartButton.setImage(UIImage(named:"heart"), for: UIControlState.normal)
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        /*let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: "last_name") {
            print(stringOne) // Some String Value
        }
        
        Alamofire.request("https://api.gfycat.com/v1/reactions/populated?tagName=trending") .responseJSON { response in // 1
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }*/
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "segue1", sender: nil)
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
        albumView?.photoView.image = dataSource[Int(index)] 
        albumView?.descriptionView.text = "Hello"
        //customView.center = self.view.center
        //customView.addSubview(UIImageView(image:dataSource[Int(index)]))
        //return UIImageView(image: dataSource[Int(index)])
        return albumView!
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
