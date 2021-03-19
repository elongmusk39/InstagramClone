//
//  CommentViewModel.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/16/21.
//

import UIKit

struct CommentViewModel {
    
//MARK: - Properties
    
    let commentInfo: Comment
    
    var profileImageUrl: URL? {
        return URL(string: commentInfo.profileImageUrl)
    }
    
//MARK: - lifeCycle
    
    init(withComment: Comment) {
        self.commentInfo = withComment
    }
    
    
//MARK: - Helpers
    
    func commentLabelText() -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: "\(commentInfo.username)  ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: commentInfo.comment, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        return attributedString
    }
    
    //adjust the size for each cell of comment (long comments have bigger size than short comments)
    func dynamicSize(forWidth widthLB: CGFloat) -> CGSize {
        let lb = UILabel()
        lb.numberOfLines = .zero
        lb.text = commentInfo.comment
        lb.lineBreakMode = .byWordWrapping
        lb.setWidth(widthLB)
        return lb.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    
}
