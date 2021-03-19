//
//  PostViewModel.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/14/21.
//

import UIKit

struct PostViewModel {
    var post: Post
    
    var imageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    var ownerProfileImageUrl: URL? {
        return URL(string: post.ownerImageUrl)
    }
    
    var ownerUsername: String {
        return post.ownerUsername
    }
    
    var ownerEmail: String {
        return post.ownerEmail
    }
    
    var caption: String {
        return post.caption
    }
    
    var likes: Int {
        return post.likes
    }
    
    var likesLabelText: String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
    }
    
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    
    var likeButtonImage: UIImage? {
        let imageName = post.didLike ? "like_selected" : "like_unselected"
        return UIImage(named: imageName)
    }
    
//MARK: lifecycle
    
    init(posts: Post) {
        self.post = posts
    }
    
    
}
