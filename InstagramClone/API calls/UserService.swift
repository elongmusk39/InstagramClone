//
//  UserSerview.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/7/21.
//

import UIKit
import Firebase

struct UserService {
    
    //when this func done its thing, it will execute the completionBlock, in this case, it will return user info fetched from Firebase
    static func fetchUser(completionBlock: @escaping(User) -> Void) {
        
        print("DEBUG: from UserService, fetching user..")
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: connot find uid")
            return
        }
        
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            
            guard let dataFetchedDictionary = snapshot?.data() else {
                print("DEBUG: error setting snapshot")
                return
            }
            guard let userMail = dataFetchedDictionary["Email"] else {
                print("DEBUG: error setting userEmail")
                return
            }//gotta match with the key "email" from Firebase, basically from AuthService, var "data"
            
            print("DEBUG: getting docs snapshot \(dataFetchedDictionary)")
            print("DEBUG: userMail is \(userMail)")
            
            let userInfo = User(dictionary: dataFetchedDictionary)
            completionBlock(userInfo) //when this func fetchUser gets called, we can access to the var "userInfo"
            
        }
        
        
    }//end of func
    
    
}
