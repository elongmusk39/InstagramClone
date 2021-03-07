//
//  SignUpController.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/2/21.
//

import UIKit

class RegistrationController: UIViewController {

//MARK: - Properties
    
    private let plusPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        
        return btn
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeHolder: "Email:")
        tf.keyboardType = .emailAddress
        
        return tf
    }()
    
    private let fullnameTextField = CustomTextField(placeHolder: "Fullname")
    private let usernameTextField = CustomTextField(placeHolder: "Username")
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeHolder: "Password:")
        //tf.isSecureTextEntry = true
        
        return tf
    }()
    
    
    private let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.7)
        btn.isEnabled = false
        btn.layer.cornerRadius = 5
        btn.setHeight(50)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return btn
    }()
    
    private let alreadyhaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedTitle(firstPart: "Already have an account? ", secondPart: "Sign In")
        btn.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        
        return btn
    }()
    
    
    private var profileImage: UIImageView = {
        let pi = UIImageView()
        pi.image = #imageLiteral(resourceName: "plus_unselected") //let's set a default profileImage in case user dont want to set the profileImage when registering
        return pi
    }()
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        addTargetTextField()
    }
    

    
// MARK: - Helpers

    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.setDimensions(height: 140, width: 140)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, fullnameTextField, usernameTextField, passwordTextField, signUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyhaveAccountButton)
        alreadyhaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 4)
        alreadyhaveAccountButton.centerX(inView: view)
    }
    
    
    func addTargetTextField() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    
//MARK: - Actions
    
    @objc func handleShowLogIn() {
        print("DEBUG: present login VC..")
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func handleSignUp() {
        print("DEBUG: signUpButton tapped..")
        
        guard let emailTyped = emailTextField.text else { return }
        guard let passwordTyped = passwordTextField.text else { return }
        guard let usernameTyped = usernameTextField.text else { return }
        guard let fullnameTyped = fullnameTextField.text else { return }
        guard let profilePict = self.profileImage.image else { return }
        
        let credentials = AuthCredentials(email: emailTyped, password: passwordTyped, fullname: fullnameTyped, username: usernameTyped, profileImage: profilePict)
        
        AuthSevice.registerUser(withCredential: credentials) { (error) in
            if let e = error {
                print("DEBUG: error registering user..\(e.localizedDescription)")
                return
            }
            
            print("DEBUG: successfully register new user \(emailTyped)")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //using this shortcut way, the isSecureTextEntry will not work well
    @objc func textDidChange() {
        if emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false && fullnameTextField.text?.isEmpty == false && usernameTextField.text?.isEmpty == false {
            
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            signUpButton.setTitleColor(.white, for: .normal)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.7)
            signUpButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.67), for: .normal)
        }
    }
    
    //this func will present the library, allowing user to pick an image
    @objc func handleProfilePhotoSelect() {
        print("DEBUG: plusPhotoBtn tapped..")
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
}


//MARK: - Extension for ImagePicker

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //this func gets called once user has just chose a pict
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("DEBUG: just finished picking a photo")
        
        guard let selectedImage = info[.editedImage] as? UIImage else {
            print("DEBUG: error setting selectedImage")
            return
        }
        //let's set the picked image to the profileImage
        profileImage.image = selectedImage
        
        //let's set the button image to the selected image
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
