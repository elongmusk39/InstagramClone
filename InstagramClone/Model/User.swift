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
    
    init(dictionary: [String : Any]) {
        self.email = dictionary["Email"] as? String ?? "no email"
        self.password = dictionary["Password"] as? String ?? "no pass"
        self.fullname = dictionary["Fullname"] as? String ?? "no fullname"
        self.username = dictionary["Username"] as? String ?? "no username"
        self.uid = dictionary["UserID"] as? String ?? "no uid"
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? "no imageURL"
        //all the shit "" must match the "" in "data" in AuthService
    }
}
