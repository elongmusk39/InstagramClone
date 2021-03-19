//
//  Post.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/14/21.
//

import UIKit
import Firebase

struct Post {
    let caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let ownerImageUrl: String
    let ownerUsername: String
    let ownerEmail: String
    let timestamp: Timestamp //this is from Firebase
    let postID: String
    var didLike = false
    
    init(postID: String, dictionary: [String : Any]) {
        self.caption = dictionary["caption"] as? String ?? "no email"
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? "no fullname"
        self.ownerUid = dictionary["ownerUid"] as? String ?? "no username"
        self.ownerEmail = dictionary["ownerEmail"] as? String ?? "no"
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? "no"
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? "no"
        self.timestamp = dictionary["time"] as? Timestamp ?? Timestamp(date: Date())
        self.postID = postID
        //all the shit "" must match the key in Firestore
        
    }
    
}
