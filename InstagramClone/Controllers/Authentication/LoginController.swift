//
//  LoginController.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/2/21.
//

import UIKit

class LoginController: UIViewController {

//MARK: - Properties
    
    private var viewModel = LoginViewModel()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeHolder: "Email:")
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeHolder: "Password:")
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        return tf
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Log in", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.67), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.7)
        btn.isEnabled = false
        btn.layer.cornerRadius = 5
        btn.setHeight(50)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        
        return btn
    }()
    
    private let forgotPasswordButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedTitle(firstPart: "Forgot password? ", secondPart: "Get help signing in")
        
        return btn
    }()
    
    
    private let donthaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedTitle(firstPart: "Don't have an account? ", secondPart: "Sign Up")
        btn.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        return btn
    }()
    
    
//MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
    }
    
    
//MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        //let's add gradient
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
        
        //let's layout the subviews
        view.addSubview(iconImage)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 180)
        
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(donthaveAccountButton)
        donthaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 4)
        donthaveAccountButton.centerX(inView: view)
    }
    
    
    
//MARK: - Actions
    
    @objc func handleShowSignUp() {
        print("DEBUG: present registration page..")
        let vc = RegistrationController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func handleLogIn() {
        print("DEBUG: login button tapped..")
        guard let emailTyped = emailTextField.text else { return }
        guard let passwordTyped = passwordTextField.text else { return }
        
        AuthSevice.logUserIn(withEmail: emailTyped, passwordPassed: passwordTyped) { (result, error) in
            
            if let e = error {
                print("DEBUG: error logging user in..\(e.localizedDescription)")
                return
            }
            
            print("DEBUG: successfully log user \(emailTyped) in!")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: - Validate the form
    
    @objc func textDidChange(sender: UITextField) {
        print("DEBUG: textField changing...")
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        print("DEBUG: formIsValid is \(viewModel.formIsValid)")
        formValidation()
    }
    
    func formValidation() {
        if viewModel.formIsValid == true {
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            loginButton.setTitleColor(.white, for: .normal)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.7)
            loginButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.67), for: .normal)
        }
    }
    
    
//If you find the way above too long, then replace it with the block below, but then the isSecureTextEntry will not function well
//---------------------------------------------------------------------begin
    //use the "sender" to make this func useable for many "addTarget"
    /*
     @objc func textDidChange() {
         if emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false {
             
             loginButton.isEnabled = true
             loginButton.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
             loginButton.setTitleColor(.white, for: .normal)
         } else {
             loginButton.isEnabled = false
             loginButton.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.7)
             loginButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.67), for: .normal)
         }
     }
     */
//---------------------------------------------------------------------end
    
    
    

    

}
