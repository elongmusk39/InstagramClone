//
//  AuthenticationViewModel.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/4/21.
//

import Foundation

struct LoginViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        //the form is only valid (formIsValid == true) if the return statement below is true
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
}


struct RegistrationViewModel {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        //the form is only valid (formIsValid == true) if the return statement below is true
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
}


struct ResetPasswordViewModel {
    var email: String?
    
    var formIsValid: Bool {
        //the form is only valid (formIsValid == true) if the return statement below is true
        return email?.isEmpty == false
    }
}
