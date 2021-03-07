//
//  FeedCell.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/1/21.
//

import UIKit

//When register this cell to the feedController, first register it at "collectionView.register()" and then in the Datasource extension, import it in the "Dequeue" stuff
class FeedCell: UICollectionViewCell {
   
//MARK: - Properties
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        //iv.backgroundColor = .systemPurple
        iv.image = #imageLiteral(resourceName: "venom-7")
        
        return iv
    }()
    
    //gotta make this a "lazy var" in order to addTarget. If you make it "let", the cell initially has not added the button so it has no place to addTarget. The "lazy var" will load the button once the func init in lifecycle gets called, which we now have a button to addTarget
    private lazy var usernameButton: UIButton = {
        let btn  = UIButton(type: .system)
        btn.setTitle("venom", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        btn.addTarget(self, action: #selector(didtapUsername), for: .touchUpInside)
        
        return btn
    }()

    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        
        return iv
    }()
    
    private lazy var likeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        btn.tintColor = .black
        
        return btn
    }()
    
    private lazy var commentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        btn.tintColor = .black
        
        return btn
    }()
    
    private lazy var shareButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        btn.tintColor = .black
        
        return btn
    }()
    
    private let likeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "1 like"
        lb.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        
        return lb
    }()
    
    private let captionLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Some test captions for now"
        lb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        return lb
    }()
    
    private let postTimeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "2 days ago"
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textColor = .lightGray
        
        return lb
    }()
    
    
//MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .cyan
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 20
        
        addSubview(usernameButton)
        usernameButton.anchor()
        usernameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true //set height equal to the width of the FeedCell
        
        configureActionButton()
        
        addSubview(likeLabel)
        likeLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, paddingTop: -4, paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likeLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
//MARK: - Actions
    
    @objc func didtapUsername() {
        print("DEBUG: did tap usernameButton..")
        
    }
    
    
//MARK: - Helpers
    
    func configureActionButton() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, width: 120, height: 50)
    }
    
    
    
}
