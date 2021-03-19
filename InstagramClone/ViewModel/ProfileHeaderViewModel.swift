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
    

//MARK: - editProfile button
    //let's configure the EditProfile button properties regrading if the user is currentUser, if user is following or not
    var followButtonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        } else {
            return user.isFollowed ? "Following" : "Follow"
        }
    }
    
    var followBtnBackgroundColor: UIColor {
        if user.isCurrentUser {
            return .white
        } else if user.isFollowed {
            return .systemBlue
        } else {
            return .systemGreen
        }
    }
    
    var followBtnTextColor: UIColor {
        return user.isCurrentUser ? .black : .white
    }
    
//MARK: - Stats
    
    var numberOfFollowers: NSAttributedString {
        return attributedStatText(value: user.stats.followers, label: "Followers")
    }
    
    var numberOfFollowing: NSAttributedString {
        return attributedStatText(value: user.stats.following, label: "Following")
    }
    
    var numberOfPosts: NSAttributedString {
        return attributedStatText(value: user.stats.post, label: "Posts")

    }
    
    
//MARK: - init stuff
    
    init(userinfo: User) {
        self.user = userinfo
    }
    
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        //the "\n" means take another line
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .bold)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
}
