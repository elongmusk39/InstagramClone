//
//  NotificationCell.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/21/21.
//

import UIKit

//this protocol is conformed in NotificationController
protocol NotificationCellDelegate: class {
    func cellFollow(_ cell: NotificationCell, wantsToFollow uid: String)
    func cellUnFollow(_ cell: NotificationCell, wantsToUnFollow uid: String)
    func cellPost(_ cell: NotificationCell, wantsToViewPost postID: String)
}

class NotificationCell: UITableViewCell {
    
    //whenever the viewModel gets modified, the "didSet" gets executed
    var viewModel: NotificationViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
//MARK: - Properties
    
    private lazy var profileImageView: UIImageView = {
        let iv  = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = #imageLiteral(resourceName: "venom-7")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleShowProfile))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    private let infoLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.text = "Loading.."
        lb.numberOfLines = .zero
        
        return lb
    }()
    
    //"lazy var" cuz we want to add the tap gesture
    private lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    //"lazy var" cuz we want to add a target
    private lazy var followButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Loading..", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        
        return btn
    }()
    
    
//MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none //unhightlight the cell when tapped
        
        //this is a cell, so we use "contentView" to access small components inside the cell
        contentView.addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 12, width: 48, height: 48)
        profileImageView.layer.cornerRadius = 48/2
        profileImageView.centerY(inView: self)
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 12, width: 88, height: 32)
        
        
        contentView.addSubview(postImageView)
        postImageView.anchor(right: rightAnchor, paddingRight: 12, width: 46, height: 46)
        postImageView.centerY(inView: self)
        
        contentView.addSubview(infoLabel)
        infoLabel.centerY(inView: profileImageView)
        infoLabel.anchor(left: profileImageView.rightAnchor, right: followButton.leftAnchor, paddingLeft: 8, paddingRight: 4)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: - Helpers
    
    func configure() {
        guard let viewMod = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewMod.profileImageUrl)
        postImageView.sd_setImage(with: viewMod.postImageUrl)
        
        infoLabel.attributedText = viewMod.notificationMessage
        followButton.isHidden = !viewMod.shouldHidePostImage
        postImageView.isHidden = viewMod.shouldHidePostImage
        
        followButton.setTitle(viewMod.followButtonText, for: .normal)
        followButton.setTitleColor(viewMod.followButtonTextColor, for: .normal)
        followButton.backgroundColor = viewMod.followButtonBackground
    }
    
//MARK: - Actions
    
    @objc func handleShowProfile() {
        print("DEBUG: ProfileImage tapped..")
        
    }
    
    @objc func handleFollowTapped() {
        print("DEBUG: followButton tapped..")
        guard let viewMod = viewModel else { return }
        
        if viewMod.notifications.userIsFollowed {
            delegate?.cellUnFollow(self, wantsToUnFollow: viewMod.notifications.uid)
        } else {
            delegate?.cellFollow(self, wantsToFollow: viewMod.notifications.uid)
        }
        
        
    }
    
    
    @objc func handlePostTapped() {
        print("DEBUG: postImageView tapped..")
        guard let postId = viewModel?.notifications.postID else { return }
        delegate?.cellPost(self, wantsToViewPost: postId)
    }
    
    
}
