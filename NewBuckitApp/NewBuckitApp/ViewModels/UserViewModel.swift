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

var userId = UserDefaults.standard.string(forKey: "userId")!

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

class ChallengeListViewModel {
    
    var challengeList = [Challenge]()
}

extension ChallengeListViewModel {
    
    /*func fetchChallenges() {
        let challenge1 = Challenge(name: "challenge1", picture: "https://c1.staticflickr.com/3/2912/13981352255_fc59cfdba2_b.jpg")
        let challenge2 = Challenge(name: "challenge2", picture: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrTFkZy0h_581tHDZ7Yhb2CeUNtfxOlxjvwAi0HtB_sWe_KLpGrg")
        
        self.challenges = [challenge1, challenge2]
    }*/
    
    func fetchData(handler:@escaping () -> Void) {
        Alamofire.request("http://\(UserDefaults.standard.string(forKey: "ipAddress")!):8080/api/users/\(userId)/myChallengeList") .responseJSON { response in
            if let data = response.result.value {
                let json = JSON(data)["content"]
                for challenge in json {
                    let challengeId = challenge.1["id"].string
                    let challengeDescription = challenge.1["challengeDescription"].string
                    let challengeName = challenge.1["challengeName"].string
                    self.challengeList.append(Challenge(id: challengeId!, name: challengeName!, description: challengeDescription!, image: challenge.1["ownerChallengeImageLink"].string!))
                }
                handler()
            }
        }
    }
    
}
