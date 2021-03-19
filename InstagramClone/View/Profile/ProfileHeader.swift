//
//  ProfileHeader.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/7/21.
//

import UIKit
import SDWebImage

//this protocol will delegate action to ProfileController
protocol ProfileHeaderDelegate: class {
    func header(_ header: ProfileHeader, didTapActionBtnFor otherUser: User)
    
}

class ProfileHeader: UICollectionReusableView {
    
    //this viewModel will get set from ProfileController, thus triggers the "didSet" func
    var viewModel: ProfileHeaderViewModel? {
        didSet {
            print("DEBUG: configuring from ProfileHeader..")
            configure()
        }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
//MARK: - Properties
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "profile_unselected")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Fullname.."
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        return lb
    }()
    
    //gotta make this a "lazy var" in order to addTarget. If you make it "let", the cell initially has not added the button so it has no place to addTarget. The "lazy var" will load the button once the func init in lifecycle gets called, which we now have a button to addTarget
    private lazy var editProfileFollowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Loading..", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(handleEditProfileFollowTap), for: .touchUpInside)
        
        return btn
    }()
    
    //make it a lazy var since we are using a func in the Helpers section
    private lazy var postLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = .zero
        lb.textAlignment = .center
        //lb.attributedText = attributedStatText(value: 5, label: "Posts")
        
        return lb
    }()
    
    private lazy var followerLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = .zero
        lb.textAlignment = .center
        //lb.attributedText = attributedStatText(value: 2, label: "Follower")
        
        return lb
    }()
    
    private lazy var followingLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = .zero
        lb.textAlignment = .center
        //lb.attributedText = attributedStatText(value: 1, label: "Following")
        
        return lb
    }()
    
    
    //make it a lazy var since we are using a func in the Helpers section
    private lazy var gridbutton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        
        return btn
    }()
    
    private lazy var listButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        
        return btn
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        
        return btn
    }()
    
    
    
//MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 80/2
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 24, paddingRight: 24)
        
        let stackLabel = UIStackView(arrangedSubviews: [postLabel, followerLabel, followingLabel])
        stackLabel.axis = .horizontal
        stackLabel.distribution = .fillEqually
        addSubview(stackLabel)
        stackLabel.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12, height: 50)
        stackLabel.centerY(inView: profileImageView)
        
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        
        let stackButton = UIStackView(arrangedSubviews: [gridbutton, listButton, bookmarkButton])
        stackButton.axis = .horizontal
        stackButton.distribution = .fillEqually
        
        addSubview(stackButton)
        addSubview(topDivider)
        addSubview(bottomDivider)
        
        stackButton.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        topDivider.anchor(top: stackButton.topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        bottomDivider.anchor(top: stackButton.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: - Actions
    
    @objc func handleEditProfileFollowTap() {
        print("DEBUG: editProfileButton tapped...")
        guard let viewMod = viewModel else { return }
        delegate?.header(self, didTapActionBtnFor: viewMod.user)
    }
    
    
//MARK: - Helpers
    
    func configure() {
        print("DEBUG: configure ProfileHeader..")
        
        guard let viewMod = viewModel else { return }
        nameLabel.text = viewMod.fullname
        profileImageView.sd_setImage(with: viewMod.profileImageUrl)
        
        //set configure the editProfile button based on currentUser's status of follow/unfollow
        editProfileFollowButton.setTitle(viewMod.followButtonText, for: .normal)
        editProfileFollowButton.setTitleColor(viewMod.followBtnTextColor, for: .normal)
        editProfileFollowButton.backgroundColor = viewMod.followBtnBackgroundColor
        
        //configure the stats labels
        postLabel.attributedText = viewMod.numberOfPosts
        followerLabel.attributedText = viewMod.numberOfFollowers
        followingLabel.attributedText = viewMod.numberOfFollowing
    }
    
    
    /* the func below is just good practice for attributeText
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        //the "\n" means take another line
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .bold)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }*/
    
    
}
