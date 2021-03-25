//
//  CustomTextField.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/2/21.
//

import UIKit

class CustomTextField: UITextField {

    
    init(placeHolder: String) {
        super.init(frame: .zero)
        
        autocapitalizationType = .none
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        setHeight(50)
        tintColor = .white //set color for the cursor
        
        //let's set the placeHolder's background color
        attributedPlaceholder = NSAttributedString(string: placeHolder , attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        
        //let created a space so that the text will not slushed into the left corner
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
