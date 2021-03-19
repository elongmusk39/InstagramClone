//
//  Comment.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/16/21.
//

import UIKit
import Firebase

struct Comment {
    let uid: String
    let username: String
    let profileImageUrl: String
    let timestamp: Timestamp
    let comment: String
    let email: String
    
    init(dictionary: [String : Any]) {
        self.email = dictionary["ownerEmail"] as? String ?? "no email"
        self.username = dictionary["username"] as? String ?? "no username"
        self.uid = dictionary["uid"] as? String ?? "no uid"
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? "no imageURL"
        self.comment = dictionary["comment"] as? String ?? "no comment"
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        //all the shit "" must match the "" in "data" in AuthService
        
    }
}
