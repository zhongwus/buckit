//
//  UserModel.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 12/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import Foundation

struct User {
    var first_name: String?
    var last_name: String?
    var avatarURL: String?
    
}

struct Challenge {
    var id: String?
    var name: String?
    var description: String?
    var image: String?
    
    init(id:String, name:String,description:String,image:String) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
    }
}


