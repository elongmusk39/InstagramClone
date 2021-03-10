//
//  UserCellViewModel.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/9/21.
//

import UIKit

//this struct is for the cells of users in the SearchVC 
struct UserCellViewModel {
    
    private let userStuff: User
    
    var profileImageUrl: URL? {
        return URL(string: userStuff.profileImageUrl)
    }
    
    //gotta use this "return" style like creating UI components since we CANT do "var username = userStuff.username"
    var username: String {
        return userStuff.username
    }
    
    var fullname: String {
        return userStuff.fullname
    }
    
    
    init(userInfo: User) {
        self.userStuff = userInfo
        
    }
}
