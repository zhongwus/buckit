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

public var userId = UserDefaults.standard.string(forKey: "userId")!

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
    
    var list = [Challenge]()

}

extension ChallengeListViewModel {
    
    func fetchData(handler:@escaping () -> Void) {
        Alamofire.request("http://\(UserDefaults.standard.string(forKey: "ipAddress")!):8080/api/users/\(userId)/myChallengeList") .responseJSON { response in
            if let data = response.result.value {
                let json = JSON(data)["content"]
                for challenge in json {
                    let challengeId = challenge.1["id"].string
                    let challengeDescription = challenge.1["challengeDescription"].string
                    let challengeName = challenge.1["challengeName"].string
                    self.list.append(Challenge(id: challengeId!, name: challengeName!, description: challengeDescription!, image: challenge.1["ownerChallengeImageLink"].string!))
                    
                }
                handler()
            }
        }
    }
    
}

class SavedChallengeListViewModel {
    var list = [Challenge]()
}

extension SavedChallengeListViewModel {
    
    func fetchData(handler:@escaping () -> Void) {
        Alamofire.request("http://\(UserDefaults.standard.string(forKey: "ipAddress")!):8080/api/users/\(userId)/savedChallengeList") .responseJSON { response in
            if let data = response.result.value {
                let json = JSON(data)["content"]
                for challenge in json {
                    let challengeId = challenge.1["id"].string
                    let challengeName = challenge.1["challengeName"].string
                    self.list.append(Challenge(id: challengeId!, name: challengeName!))
                }
                handler()
            }
        }
    }
    
}
