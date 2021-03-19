//
//  CommentInputAccessoryView.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/15/21.
//

import UIKit

protocol CommentInputAccessoryViewDelegate: class {
    func inputView(_ inputView: CommentInputAccessoryView, uploadComment comment: String)
}

class CommentInputAccessoryView: UIView {
//MARK: - Properties
    
    weak var delegate: CommentInputAccessoryViewDelegate?
    
    //this textView is inherited from "InputTextView" class
    private let commentTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeHolderText = "Enter comments.."
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        tv.placeHolderShouldCenter = true
        
        return tv
    }()
    
    private let postButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Post", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(handleCommentUpload), for: .touchUpInside)
        
        return btn
    }()
    
//MARK: - Lifecycle
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight //adjust the height of this CommentInputAccessoryView to fit with different screensizes
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8, width: 50, height: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor,bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //this func will figure out the right size
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
//MARK: - Actions
    
    @objc func handleCommentUpload() {
        delegate?.inputView(self, uploadComment: commentTextView.text)
    }
   
//MARK: - Helpers
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeHolderLabel.isHidden = false
    }

}
