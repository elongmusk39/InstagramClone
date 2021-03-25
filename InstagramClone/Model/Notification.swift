//
//  Notification.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/21/21.
//

import UIKit
import Firebase

//"enum" is just like a dictionary. We use "Int", not "String", cuz it's cleaner
enum NotificationType: Int {
    case like //key is 0
    case follow //key is 1
    case comment //key is 2
    
    var notificationMessage: String {
        switch self {
        case .like:
            return " likes your post."
        case .follow:
            return " started following you."
        case .comment:
            return " comments on your post."
        }
    }
    
}


struct Notification {
    let uid: String
    let email: String
    let username: String
    let postImageIrl: String? //it can be nil
    let postID: String?
    let timestamp: Timestamp
    let type: NotificationType
    let IDNotifi: String
    let userProfileImageUrl: String
    
    var userIsFollowed = false
    
    init(dictionary: [String:Any]) {
        self.IDNotifi = dictionary["IDNotifi"] as? String ?? "no id"
        self.postID = dictionary["postID"] as? String ?? "no postID"
        self.postImageIrl = dictionary["postImageUrl"] as? String ?? "no url"
        self.uid = dictionary["uidOfSender"] as? String ?? "no uid"
        self.email = dictionary["emailOfSender"] as? String ?? "no email"
        self.username = dictionary["usernameOfsender"] as? String ?? "no username"
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.userProfileImageUrl = dictionary["userProfileImageUrlOfSender"] as? String ?? "No ProfileUrl"
    }
    
}
