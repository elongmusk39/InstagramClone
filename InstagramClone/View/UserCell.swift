//
//  UserCell.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/9/21.
//

import Foundation
import UIKit

//private let reuseIdentifierCell = "UserCell"

class UserCell: UITableViewCell {
    
    //the "didSet" is a func that gets called once the var "userVM" gets set
    var userVM: UserCellViewModel? {
        didSet { configure() }
    }
    
    
//MARK: - Properties
    
    private let profileImageView: UIImageView = {
        let iv  = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = #imageLiteral(resourceName: "venom-7")
        
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.text = "venom"
        
        return lb
    }()
    
    private let fullnameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.text = "Eddie Brock"
        
        return lb
    }()
    

//MARK: - Lifecycle
    //gotta override the "init" since we are modifying the original "init" of this UITableViewCell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 12, width: 48, height: 48)
        profileImageView.layer.cornerRadius = 48/2
        profileImageView.centerY(inView: self)
        
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading //anchor to the left
        addSubview(stackView)
        stackView.anchor(left: profileImageView.rightAnchor, paddingLeft: 8)
        stackView.centerY(inView: profileImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Helpers
    
    func configure() {
        guard let viewModel = userVM else { return }
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        usernameLabel.text = viewModel.username
        fullnameLabel.text = viewModel.fullname
    }
    
    
    
}

