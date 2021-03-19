//
//  PostService.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/13/21.
//

import UIKit
import Firebase

struct PostService {
    
    var userStuff: User
    
    static func uploadPost(caption: String, imagePost: UIImage, userInfo: User, completionBlock: @escaping(FirestoreCompletion)) {
        print("DEBUG: API - uploading post...")
        
        guard let uidCurrent = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: imagePost) { (imageURL) in
            let data = ["caption": caption,
                        "time": Timestamp(date: Date()),
                        "likes": 0,
                        "imageUrl": imageURL,
                        "ownerUid": uidCurrent,
                        "ownerEmail": userInfo.email,
                        "ownerImageUrl": userInfo.profileImageUrl,
                        "ownerUsername": userInfo.username] as [String : Any]
            COLLECTION_POSTS.addDocument(data: data, completion: completionBlock)
        }
        
    }//end of func
    
    //with the completionBlock, we gonna get back an array of "Post"
    static func fetchPost(completionBlock: @escaping([Post]) -> Void) {
        
        //let's fetch post based on time posted (newest on top)
        COLLECTION_POSTS.order(by: "time", descending: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            //let's use the map func (used in func fetchUserList)
            let posts = documents.map({
                Post(postID: $0.documentID, dictionary: $0.data())
            }) //the documentID is for "addDocument" command, just like uid
            
            //print("DEBUG: big array of all posts and info - \(posts)")
            completionBlock(posts)
        }
    }//end of func
    
    
    
    static func fetchPostProfile(forUser uidPostOwner: String, completionBlock: @escaping([Post]) -> Void) {
        
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uidPostOwner) //only return the posts belong to real owner in order of timestamp
        
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            //let's use the map func (used in func fetchUserList)
            var posts = documents.map({
                Post(postID: $0.documentID, dictionary: $0.data())
            }) //the documentID is for "addDocument" command, just like uid
            
            //let's return the post based on chronological order
            posts.sort { (post1, post2) -> Bool in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            
            //print("DEBUG: big array of all posts and info - \(posts)")
            completionBlock(posts)
        }
    }
    
//MARK: - Like and unlike
    
    static func likePost(postInfo: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let email = Auth.auth().currentUser?.email else { return }
        
        COLLECTION_POSTS.document(postInfo.postID).updateData(["likes": postInfo.likes + 1])
        
        let data1 = ["uid": uid, "emailLiker": email]
        let data2 = ["postID": postInfo.postID, "postEmail": postInfo.ownerEmail]
        //blank data is [:]
        
        COLLECTION_POSTS.document(postInfo.postID).collection("post-likes").document(uid).setData(data1) { (error) in
            
            COLLECTION_USERS.document(uid).collection("user-likes").document(postInfo.postID).setData(data2, completion: completion)
        }
    }
    
    
    static func unlikePost(postInfo: Post, completion: @escaping(FirestoreCompletion)) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard postInfo.likes > 0 else {
            print("DEBUG: from PostService, likes < 0")
            return
        }
        
        COLLECTION_POSTS.document(postInfo.postID).updateData(["likes": postInfo.likes - 1])
        
        COLLECTION_POSTS.document(postInfo.postID).collection("post-likes").document(uid).delete { (error) in
            COLLECTION_USERS.document(uid).collection("user-likes").document(postInfo.postID).delete(completion: completion)
        }
    }
    
    
//MARK: - check like
        
    static func checkIfUserLikedPost(postInfo: Post, completion: @escaping(Bool) -> Void) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(currentUid).collection("user-likes").document(postInfo.postID).getDocument { (snapshot, _) in
            
            guard let didLike = snapshot?.exists else { return }
            completion(didLike)
        }
    }
    
    
}
