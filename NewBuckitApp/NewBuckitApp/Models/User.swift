//
//  UserModel.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 12/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import Foundation

class User {
    var first_name: String?
    var last_name: String?
    var avatarURL: String?
    
}

class Challenge {
    var name: String?
    var picture: String?
    
    init(name:String,picture:String) {
        self.name = name
        self.picture = picture
    }
}
