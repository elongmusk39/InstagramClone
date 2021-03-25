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
    
    
    //this is how we have the "2m" or "2d" or "2w" that indicates sometimes ago
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1 //only 1/5 units in the array above is allowed
        formatter.unitsStyle = .full
        return formatter.string(from: post.timestamp.dateValue(), to: Date())
    }
    
    
//MARK: lifecycle
    
    init(posts: Post) {
        self.post = posts
    }
    
    
}
