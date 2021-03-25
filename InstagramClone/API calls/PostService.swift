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

//MARK: Upload post
    
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
            let docRef = COLLECTION_POSTS.addDocument(data: data, completion: completionBlock)
            
            self.updateUserFeedAfterPost(postID: docRef.documentID)
        }
        
    }//end of func
    
    
//MARK: fetch post
    
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
    
    
    //this func is called when we check out a user's profile and see all posts associated with that user
    static func fetchPostProfile(forUser uidPostOwner: String, completionBlock: @escaping([Post]) -> Void) {
        
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uidPostOwner) //only return the posts belong to real owner in order of timestamp
        
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            //let's use the map func (used in func fetchUserList)
            var posts = documents.map({
                Post(postID: $0.documentID, dictionary: $0.data())
            }) //the documentID is for "addDocument" command, just like uid
            
        //-------------------------------------------------------------begin
            //let's manually return the post based on chronological order
            posts.sort { (post1, post2) -> Bool in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            
            //either use the block above or this line below to
            /*
             posts.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds })
            */
        //-------------------------------------------------------------end
            
            //print("DEBUG: big array of all posts and info - \(posts)")
            completionBlock(posts)
        }
    }
    
    
    static func fetchPostWithPostID(postId: String, completion: @escaping(Post) -> Void) {
        COLLECTION_POSTS.document(postId).getDocument { (stuff, _) in
            guard let snapshot = stuff else { return }
            guard let data = snapshot.data() else { return }
            let post = Post(postID: snapshot.documentID, dictionary: data)
            completion(post)
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
    
    
//MARK: - fetch followed posts
    
    static func updateUserFeedAfterFollowing(user: User, didFollow: Bool) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: user.uid)
        
        query.getDocuments { (snapshot, error) in
            guard let docs = snapshot?.documents else { return }
            let docIDs = docs.map({ $0.documentID })
            
            print("DEBUG: all docIDs are \(docIDs)")
            
            //gotta loop through all postIds, if user is followed, then append the postId; if not, then delete the postIds
            docIDs.forEach { (postIds) in
                if didFollow {
                    COLLECTION_USERS.document(currentUID).collection("user-feed").document(postIds).setData([:])
                } else {
                    COLLECTION_USERS.document(currentUID).collection("user-feed").document(postIds).delete()
                }
            }
            
        }//end query
        
    }//end of func
    
    
    static func fetchFeedPosts(completion: @escaping([Post]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        var postArray = [Post]()
        
        COLLECTION_USERS.document(currentUid).collection("user-feed").getDocuments { (snapshot, _) in
            
            snapshot?.documents.forEach({ (docs) in
                
                fetchPostWithPostID(postId: docs.documentID) { (post) in
                    postArray.append(post)
                    
            //let's manually return the post based on chronological order
        //----------------------------------------------------------begin
                    /*postArray.sort { (post1, post2) -> Bool in
                        return post1.timestamp.seconds > post2.timestamp.seconds
                    }*/
                    
                    //either use the block above or this line below
                    postArray.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds })
        //-----------------------------------------------------------end
                    completion(postArray)
                }
            })
        }
        
    }//end of func
    
    
    private static func updateUserFeedAfterPost(postID: String) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWERS.document(currentUid).collection("user-followers").getDocuments { (snapshot, error) in
            guard let docs = snapshot?.documents else { return }
            
            //let's upload new post to all followers
            docs.forEach { (document) in
                print("DEBUG: follower is \(document.documentID)")
                COLLECTION_USERS.document(document.documentID).collection("user-feed").document(postID).setData([:])
            }
            
            COLLECTION_USERS.document(currentUid).collection("user-feed").document(postID).setData([:])
        }
        
    } //end of func
    
    
    
}
