//
//  InputTextView.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/12/21.
//

import UIKit

class InputTextView: UITextView {
    
//MARK: - Properties
    
    //when this var gets set in UploadPostVC, it calls didSet func
    var placeHolderText: String? {
        didSet { placeHolderLabel.text = placeHolderText}
    }
    
    let placeHolderLabel: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = .lightGray
        
        return lb
    }()
    
    //the textView is laid out differently in UploadPostVC and CommentVC
    var placeHolderShouldCenter = true {
        didSet {
            if placeHolderShouldCenter {
                placeHolderLabel.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 8)
                placeHolderLabel.centerY(inView: self)
            } else {
                placeHolderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 4)
            }
        }
    }
    
//MARK: - LifeCycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.black.cgColor
        
        addSubview(placeHolderLabel)
        
        
        //this is kind of the protocol for handling text change
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Actions
    
    @objc func handleTextDidChange() {
        print("DEBUG: calling from InputTextView, text is changing..")
        placeHolderLabel.isHidden = !text.isEmpty
    }
    
    
    
}
