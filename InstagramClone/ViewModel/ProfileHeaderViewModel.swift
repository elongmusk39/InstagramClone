//
//  ProfileHeaderViewModel.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/8/21.
//

import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    init(userinfo: User) {
        self.user = userinfo
    }
}
