//
//  NotificationViewModel.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/21/21.
//

import UIKit

//we need "ViewModel" stuff to fetch data and populate them on the UI with the help of the "Model" structure

struct NotificationViewModel {
    
    var notifications: Notification //"var" cuz we access it from NotificationCell and NotificationController
    
    init(withNotification: Notification) {
        self.notifications = withNotification
    }
    
//MARK: some vars
    
    var postImageUrl: URL? {
        return URL(string: notifications.postImageIrl ?? "no url")
    }
    
    var profileImageUrl: URL? {
        return URL(string: notifications.userProfileImageUrl)
    }
    
    //this is how we have the "2m" or "2d" or "2w" that indicates sometimes ago
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1 //only 1/5 units in the array above is allowed
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notifications.timestamp.dateValue(), to: Date())
    }
    
    var notificationMessage: NSAttributedString {
        let usernameSender = notifications.username
        let message = notifications.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: usernameSender, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        let attributeMessage = NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)])
        let attributeTime = NSAttributedString(string: " \(timestampString ?? "2m")", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray])
        
        attributedText.append(attributeMessage)
        attributedText.append(attributeTime)
        
        return attributedText
    }
    
//MARK: - 2-return vars
    
    var shouldHidePostImage: Bool {
        return self.notifications.type == .follow
    } //if user follows another, it should present the "followButton" instead of a postImage
    
    
    var followButtonText: String {
        return notifications.userIsFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackground: UIColor {
        return notifications.userIsFollowed ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.245424269, green: 0.4042920151, blue: 1, alpha: 1)
    }
    
    var followButtonTextColor: UIColor {
        return notifications.userIsFollowed ? .black : .white
    }
    
    
}

