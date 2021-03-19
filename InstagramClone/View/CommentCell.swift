//
//  CommentCell.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/15/21.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var viewModel: CommentViewModel? {
        didSet { configure() }
    }
    
//MARK: - Properties
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    
    private let commentLabel = UILabel()
    
//MARK: -Lifecycle
    
    //gotta use "override" cuz UICollectionViewCell already has its "init", we are trying to modify it
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 8, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(commentLabel)
        commentLabel.numberOfLines = .zero //infinite lines
        commentLabel.centerY(inView: profileImageView)
        commentLabel.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 8)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: - Helpers
    
    func configure() {
        guard let viewMod = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewMod.profileImageUrl)
        commentLabel.attributedText = viewMod.commentLabelText()
    }
    
    
}

