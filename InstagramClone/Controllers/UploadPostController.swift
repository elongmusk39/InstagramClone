//
//  UploadPostController.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/12/21.
//

import UIKit

//conform the protocol in MainTabController
protocol UploadPostControllerDelegate: class {
    func controllerDidFinishUploading(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet { photoImageView.image = selectedImage }
    }
    
    var currentUser: User? //this one got filled up in MainTabController
    
    
    weak var delegate: UploadPostControllerDelegate?
    
//MARK: - Properties
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        //iv.image = #imageLiteral(resourceName: "venom-7")
        
        return iv
    }()
    
    //for textView,we can set the height and can skip a line to text. For textField, there's only 1 line (need more? gotta specify it)
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeHolderText = "Enter Caption"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.delegate = self
        tv.placeHolderShouldCenter = false
        
        return tv
    }()
    
    
    private let characterCountLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.text = "1/100"
        
        return lb
    }()
    
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
//MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Upload post"
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapShare))
        
        //let's set up the UI components
        view.addSubview(photoImageView)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8, width: 180, height: 180)
        photoImageView.centerX(inView: view)
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(top: captionTextView.bottomAnchor, right: view.rightAnchor, paddingTop: 2, paddingRight: 12)
    }
    
    
    //gotta write ".delegate = self" in the Properties section
    func checkMaxLength(_ textV: UITextView, maxLength: Int) {
        if textV.text.count > maxLength {
            textV.deleteBackward() //user cannot type more
        }
        
    }
        
//MARK: - Actions
        
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func didTapShare() {
        print("DEBUG: sharing post..")
        showLoader(true)
        
        guard let image = selectedImage else { return }
        guard let captions = captionTextView.text else { return }
        guard let userUpdated = self.currentUser else { return }
        
        PostService.uploadPost(caption: captions, imagePost: image, userInfo: userUpdated) { (error) in
            
            self.showLoader(false)
            if let e = error?.localizedDescription {
                print("DEBUG: Error uploading post, \(e)")
                return
            }
            print("DEBUG: successfully upload a post...")
            
            //conform the protocol in MainTabController
            self.delegate?.controllerDidFinishUploading(self)
        }
    }
    
    
}

//MARK: - TextView delegate
//this func gets called when the textView is active (when you are typing)
extension UploadPostController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView, maxLength: 100)
        let count = textView.text.count //this will change as we type
        characterCountLabel.text = "\(count)/100"
        
        //captionTextView.placeHolderLabel.isHidden = !captionTextView.text.isEmpty //in case the placeHolder dont disappear, then use this line
        
    }
}
