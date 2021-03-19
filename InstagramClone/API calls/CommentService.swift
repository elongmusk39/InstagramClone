//
//  CommentService.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/16/21.
//

import UIKit
import Firebase

struct CommentService {
    
    static func uploadComment(commentText: String, postID: String, user: User, completionBlock: @escaping(FirestoreCompletion)) {
        
        let data: [String:Any] = ["uid": user.uid,
                                  "comment": commentText,
                                  "timestamp": Timestamp(date: Date()),
                                  "username": user.username,
                                  "profileImageUrl": user.profileImageUrl,
                                  "ownerEmail": user.email]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data, completion: completionBlock)
        
    }
    
    
    static func fetchComments(postID: String, completionBlock: @escaping([Comment]) -> Void) {
        
        var commentArray = [Comment]()
        let query = COLLECTION_POSTS.document(postID).collection("comments")
            .order(by: "timestamp", descending: true) //remember that all the "" has to match with "" in Database
        
        //the "addSnapshotListener" is use for live data updating of the UI as soon as a data is added to database (UI updates fast). U dont have to manually perform an action (pull down refresh) to update the UI, which is slow
        query.addSnapshotListener { (snapshot, error) in
            
            //use "loop" command to append to the array
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    commentArray.append(comment)
                }
            })
            
            completionBlock(commentArray) //after being appended many times through the loop, now the commentArray is big, with each index represent 1 comment which has all variables of struct "Comment"
        }
        
    }//end of func
    
    
    
    
    
}
