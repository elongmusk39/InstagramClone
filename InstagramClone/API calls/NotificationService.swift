//
//  NotificationService.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/21/21.
//

import UIKit
import Firebase

struct NotificationService {
    
    static func uploadNotification(toUID uid: String, toEmail email: String, fromUser: User, type: NotificationType, post: Post? = nil) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else {
            print("DEBUG: uid error, you like your own post..")
            return
        }
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        
        //this is how we get "documentID" when using "addDocument" command
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "uidOfSender": fromUser.uid,
                                   "type": type.rawValue,
                                   "IDNotifi": docRef.documentID,
                                   "userProfileImageUrlOfSender": fromUser.profileImageUrl,
                                   "usernameOfsender": fromUser.username,
                                   "emailOfSender": fromUser.email ]
        
        //if the notification involves post, then var "data" will have 2 more values below
        if let postChecked = post {
            data["postID"] = postChecked.postID
            data["postImageUrl"] = postChecked.imageUrl
        }
        
        
        //let's upload all shit to Firestore
        let dataUser = ["uid": uid, "email": email] as [String: Any]
        COLLECTION_NOTIFICATIONS.document(uid).setData(dataUser) { (error) in
            docRef.setData(data)
            print("DEBUG: done uploading notification")
        }
        
    }//end of func
    
    
    
    //the completion will spit out a big array containing info of all notifi
    static func fetchNotification(completion: @escaping([Notification]) -> Void) {
        
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_NOTIFICATIONS.document(currentUID).collection("user-notifications").order(by: "timestamp", descending: true) //you can play around "true" or "false"
        
        query.getDocuments { (snapshot, error) in
            
            guard let documents = snapshot?.documents else { return }
            print("DEBUG: we have \(documents.count) notifications")
            
            let notifications = documents.map({
                Notification(dictionary: $0.data())
            })
            print("DEBUG: big array notifi is: \(notifications)")
            completion(notifications)
        }
        
    }//end of func
    
    
    
}
