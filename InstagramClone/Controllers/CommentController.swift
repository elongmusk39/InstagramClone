//
//  CommentController.swift
//  InstagramClone
//
//  Created by Long Nguyen on 3/15/21.
//

import UIKit

private let reuseIdentifier = "cell"

class CommentController: UICollectionViewController {

//MARK: - Properties
    
    private let postVar: Post //this gets filled up in "init" of Lifecycle
    private var commentsArray = [Comment]()
    
    //use "lazy var" cuz we need to access the "view.frame.width" and "self"
    private lazy var commentInputView: CommentInputAccessoryView = {
        let layout = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccessoryView(frame: layout)
        cv.delegate = self
        
        return cv
    }()

    
//MARK: - LifeCycle
    
    //gotta have the init for "flowLayout" cuz the FeedController will call out this CommentVC
    init(posts: Post) {
        self.postVar = posts //assign value fetched from FeedController, including documentID (just like an uid for each each post)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        fetchComments()
    }
    
    //add the customized "commentInputView" into this CommentController()
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }

    //handle the keyboard
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
//dealing with hiding and showing tab bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
//MARK: - API
    
    func fetchComments() {
        CommentService.fetchComments(postID: postVar.postID) { (comments) in
            self.commentsArray = comments
            print("DEBUG: we have \(self.commentsArray.count) comments")
            self.collectionView.reloadData()
        }
    }
    
// MARK: - Helpers

    func configureCollectionView() {
        //for decoy cells, use "UICollectionVewCell.self" instead of "CommentCell.self"
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .cyan
        navigationItem.title = "Comments"
        
        //let's make it dragging down to dismiss the keyboard
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
    }

}



//MARK: - Extension Datasource

extension CommentController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.viewModel = CommentViewModel(withComment: commentsArray[indexPath.row]) //assign fetched data to CommentCell to populate its UI
        
        return cell
    }
}


//MARK: - Extension UI layout

extension CommentController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewMD = CommentViewModel(withComment: commentsArray[indexPath.row])
        
        //this heightCell is used for dealing with text UI, it just automatically adjust the size for the cells
        let heightCell = viewMD.dynamicSize(forWidth: view.frame.width).height + 32 //32 is spacing between comments
        
        return CGSize(width: view.frame.width, height: heightCell)
    }
    
    
}


//MARK: - Extension Delegate

extension CommentController {
    //tapping into a commentCell to present a profile page
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let uid = commentsArray[indexPath.row].uid
        print("uid is: \(uid)")
        UserService.fetchUser(withUID: uid) { (userInfo) in
            let vc = ProfileController(userFetched: userInfo)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK: - Protocol conformance
//setting protocol from CommentInputAccessoryView
extension CommentController: CommentInputAccessoryViewDelegate {
    //remember to write ".delegate = self"
    func inputView(_ inputView: CommentInputAccessoryView, uploadComment comment: String) {
        
        print("DEBUG: protocol from CommentVC, comment is \(comment)")
        self.showLoader(true)
        
        guard let tab = tabBarController as? MainTabController else {return}
        guard let currentUser = tab.userMainTab else { return }
        
        //let's upload the comment to associated post
        CommentService.uploadComment(commentText: comment, postID: postVar.postID, user: currentUser) { (error) in
            
            self.showLoader(false)
            inputView.clearCommentTextView()
            print("DEBUG: done uploading comment..")
            
            NotificationService.uploadNotification(toUID: self.postVar.ownerUid, toEmail: self.postVar.ownerEmail, fromUser: currentUser, type: .comment, post: self.postVar)
            
        }
    }
    
    
}
