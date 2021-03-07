//
//  User.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/7/21.
//

import UIKit

struct User {
    var email: String
    var password: String
    var fullname: String
    var username: String
    var uid: String
    var profileImageUrl: String
    
    init(dictionary: [String:Any]) {
        self.email = dictionary["Email"] as? String ?? ""
        self.password = dictionary["Password"] as? String ?? ""
        self.fullname = dictionary["Fullname"] as? String ?? ""
        self.username = dictionary["Username"] as? String ?? ""
        self.uid = dictionary["UserID"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        //all the shit "" must match the "" in "data" in AuthService
    }
}
