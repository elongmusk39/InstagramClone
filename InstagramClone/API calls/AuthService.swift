//
//  AuthService.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/5/21.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}



struct AuthSevice {
    /*
    static func registerUser(withCredential credentials: AuthCredentials, completionBlock: @escaping(Error?) -> Void) {
        //print("DEBUG: credentials are \(credentials)")
        
        ImageUploader.uploadImage(image: credentials.profileImage) { (imageUrl) in
            
            //now we create user's info in Firebase
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                
                if let e = error {
                    print("DEBUG: error registering user, \(e.localizedDescription)")
                     return
                }
                
                //let's upload the profileImage first, so when we setup user's info, we have the url for that image
                guard let uid = result?.user.uid else { return }
                let data: [String:Any] = ["Email": credentials.email,
                                    "Fullname": credentials.fullname,
                                    "Password": credentials.password,
                                    "Username": credentials.username,
                                    "profileImageUrl": imageUrl,
                                    "UserID": uid] //the downloaded imageUrl is generated in the completionBlock of ImageUploader
                Firestore.firestore().collection("users").document(uid).setData(data, completion: completionBlock)
                print("DEBUG: just done creating user")
            }
        }
            
    } //end of func
    */
    
//you can use the func below (create user then upload image) to replace the func above (upload image then create user)
//------------------------------------------------------------------begin
    
    //the "static" allows this func to be accessed from any where
     static func registerUser(withCredential credentials: AuthCredentials, completionBlock: @escaping(Error?) -> Void) {
         //print("DEBUG: credentials are \(credentials)")
         
             //now we create user's info in Firebase
             Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                 
                 if let e = error {
                     print("DEBUG: error registering user, \(e.localizedDescription)")
                      return
                 }
                 
                 //let's upload the profileImage first, so when we setup user's info, we have the url for that image
                 ImageUploader.uploadImage(image: credentials.profileImage) { (imageUrl) in
                     guard let uid = result?.user.uid else { return }
                     let data: [String:Any] = ["Email": credentials.email,
                                         "Fullname": credentials.fullname,
                                         "Password": credentials.password,
                                         "Username": credentials.username,
                                         "profileImageUrl": imageUrl,
                                         "UserID": uid] //the downloaded imageUrl is generated in the completionBlock of ImageUploader
                     Firestore.firestore().collection("users").document(uid).setData(data, completion: completionBlock)
                     print("DEBUG: just done creating user")
                 }
                 
             }
     }
     
//------------------------------------------------------------------end
    
    
    static func logUserIn(withEmail emailPassed: String, passwordPassed: String, completionBlock: AuthDataResultCallback?) {
        print("DEBUG: signing user in..")
        Auth.auth().signIn(withEmail: emailPassed, password: passwordPassed, completion: completionBlock)
    }
    
    
    //Firebase can sort out users' email associated with account created in the FireStore. So if user is not in Firesbase, it cannot send reset password link
    static func resetPassword(withEmail email: String, completion: SendPasswordResetCallback?) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
    
    
}
