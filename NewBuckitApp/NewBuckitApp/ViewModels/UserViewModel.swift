//
//  UserViewModel.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 12/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UsersViewModel {
    private var user = User()
    
    var first_name: String? {
        return user.first_name
    }
    
    var last_name: String? {
        return user.last_name
    }
    
    var avatarURL: String? {
        guard let avatarURL = user.avatarURL else {
            return nil
        }
        return avatarURL
    }
    
    init(first_name: String,last_name: String, avatarURL: String) {
        user.first_name = first_name
        user.last_name = last_name
        user.avatarURL = avatarURL
    }
    
}

class ChallengeViewModel {
    var challenges: [Challenge]?
    
    var firstChallenge: Challenge {
        return challenges![1]
    }
    
    init() {
        self.fetchChallenges()
    }
}

extension ChallengeViewModel {
    func fetchChallenges() {
        let challenge1 = Challenge(name: "challenge1", picture: "https://c1.staticflickr.com/3/2912/13981352255_fc59cfdba2_b.jpg")
        let challenge2 = Challenge(name: "challenge2", picture: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrTFkZy0h_581tHDZ7Yhb2CeUNtfxOlxjvwAi0HtB_sWe_KLpGrg")
        
        self.challenges = [challenge1, challenge2]
        /*Alamofire.request("http://172.29.92.108:8080/api/challenges") .responseJSON { response in // 1
            //debugPrint("All Response Info: \(response)")
            
            if let data = response.result.value {
                let json = JSON(data).array
                print("started")
                for challenge in json! {
                    let name = challenge["challenegName"].string
                    let link = challenge["challengeImageLink"].string
                    let sample = Challenge(name: name!, picture: link!)
                    self.challenges?.append(sample)
                }
                print(self.challenges?.count)
            }
        }*/
    }
    
}
