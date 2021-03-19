//
//  UserSerview.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/7/21.
//

import UIKit
import Firebase

typealias FirestoreCompletion = (Error?) -> Void //this is just a shortcut whenever we want to implement a completion handler

struct UserService {
    
    //when this func done its thing, it will execute the completionBlock, in this case, it will return user info fetched from Firebase
    static func fetchUser(withUID uid: String, completionBlock: @escaping(User) -> Void) {
        
        print("DEBUG: from UserService, fetching user..")
        
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            
            guard let dataFetchedDictionary = snapshot?.data() else {
                print("DEBUG: error setting snapshot")
                return
            }
            //make it "guard let" so that when printed out, we dont have "optional" stuff
            guard let userMail = dataFetchedDictionary["Email"] else {
                print("DEBUG: error setting userEmail")
                return
            }//gotta match with the key "email" from Firebase, basically from AuthService, var "data". We are searching for the key in the array to find out the value associated with that key
            
            print("DEBUG: getting docs snapshot \(dataFetchedDictionary)")
            print("DEBUG: userMail is \(userMail)")
            
            let userInfo = User(dictionary: dataFetchedDictionary)
            completionBlock(userInfo) //when this func fetchUser gets called, we can access to the var "userInfo"
        }
        
    }//end of func
    
    
    //this func will return an array (of type: User) after it done its thing
    static func fetchUserlist(completionBlock: @escaping([User]) -> Void) {
        
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard let snapshotSleek = snapshot else { return }
                
            //the "map" method below puts all data of all users in an array
            let userlist = snapshotSleek.documents.map({ User(dictionary: $0.data())})
            //print("DEBUG: userlist is \(userlist)")
            completionBlock(userlist)
        }
    }//end of func
    
    
//func below uses "for-loop" to get data of all users, above func uses "map". they kind of do the same shit but the above version is more elegant
//----------------------------------------------------------------------begin
/*
    //this func will return an array (of type: User) after it done its thing
    static func fetchUserlist(completionBlock: @escaping([User]) -> Void) {
        var userArray = [User]()
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            
            guard let snapshotSleek = snapshot else {
                print("DEBUG: cannot get snapshot..")
                return
            }
            
            print("DEBUG: let's run the loop to get list of users..")
            snapshotSleek.documents.forEach { (document) in
                let dataArray = document.data()
                print("DEBUG: from UserService, list is \(dataArray)")
                let users = User(dictionary: dataArray) //create an array that stores info fetched of 1 user from Firebase. Since this is a for-loop, each time it runs it gets back all info of a user and it run through all users
                
                userArray.append(users) //we get all data of all users appended to a single var "userArray"
            }
            completionBlock(userArray)
            
        }
    }//end of func
//----------------------------------------------------------------------end
*/
    
    
//MARK: - Following stuff
    
    //with this func, we have 2 big collections, one is for all the current users and their followers, one is for all current users and their following accounts
    static func follow(uidOtherUser: String, emailOtherUser: String, completionBlock: @escaping(FirestoreCompletion)) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let currentEmail = Auth.auth().currentUser?.email else {
            return
        }
        let dataCurrent: [String:Any] = ["Email": currentEmail,
                            "UserID": currentUid]
        let dataOtherUser: [String:Any] = ["Email": emailOtherUser,
                                           "UserID": uidOtherUser]
        
        //let's deal with the API
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uidOtherUser).setData(dataOtherUser) { (error) in
            
            COLLECTION_FOLLOWERS.document(uidOtherUser).collection("user-followers").document(currentUid).setData(dataCurrent, completion: completionBlock)
        }
    }
    
    
    static func unfollow(uidOtherUser: String, completionBlock: @escaping(FirestoreCompletion)) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        //let's deal with the API
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uidOtherUser).delete { (error) in
            
            COLLECTION_FOLLOWERS.document(uidOtherUser).collection("user-followers").document(currentUid).delete(completion: completionBlock)
        }
        
    }
    
    
    static func checkIfUserIsFollowed(uidOtherUser: String, completionBlock: @escaping(Bool) -> Void) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uidOtherUser).getDocument { (snapshot, error) in
            
            //if snapshot exists, currentUser is following the user, viceVersa
            guard let isFollowed = snapshot?.exists else { return }
            completionBlock(isFollowed) //"isFollowed" is Bool 
        }
        
    }
    
    
//MARK: fetch user stats
    
    static func fetchUserStats(generalUID: String, completionBlock: @escaping(UserStats) -> Void) {
        
        COLLECTION_FOLLOWERS.document(generalUID).collection("user-followers").getDocuments { (snapshot, error) in
            
            let numberOfFollowers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWING.document(generalUID).collection("user-following").getDocuments { (snapshot, error) in
                
                let numberOfFollowing = snapshot?.documents.count ?? 0
                
                //only access posts that relate to owner, not ALL posts
                COLLECTION_POSTS.whereField("ownerUid", isEqualTo: generalUID).getDocuments { (snapshot, error) in
                    
                    let numberOfPosts = snapshot?.documents.count ?? 0
                    
                    completionBlock(UserStats(followers: numberOfFollowers, following: numberOfFollowing, post: numberOfPosts))
                }
                
            }
        }
        
    }//end of func
    

    
}
