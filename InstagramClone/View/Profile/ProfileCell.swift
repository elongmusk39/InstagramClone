//
//  ProfileCell.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/7/21.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    //this var gets filled up with data in the ProfileController
    var viewModel: PostViewModel? {
        didSet { configure() }
    }
    
//MARK: - Properties
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
//MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        addSubview(postImageView)
        postImageView.fillSuperview() //fill the imageView over an item (a ProfileCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: - Helperes
    
    func configure() {
        guard let viewMD = viewModel else { return }
        postImageView.sd_setImage(with: viewMD.imageUrl)
    }
    
}
