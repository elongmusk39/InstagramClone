//
//  FeedController.swift
//  InstagramClone
//
//  Created by Long Nguyen on 2/28/21.
//

import UIKit
import Firebase

//the reuseIdentifier: when a cell is scrolled through (we scroll down), it moves to memory catch. When we scroll up to re-see the cell, the app will look for the reuseIdentifier in the memory catch, if we have scroll through before, then it just pulls that cell out of memroy catch associated with that reuseIdentifier without creating a new cell
private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {

//MARK: - Properties
    
    //whenever var "posts" got modified, it will execute the "didSet"
    private var posts = [Post]() {
        //reload all extensions with new assigned data
        didSet { collectionView.reloadData() }
    }
    
    var postSingle: Post?
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchPosts()
    }
    
    
//MARK: _ API
    
    func fetchPosts() {
        guard postSingle == nil else {
            print("DEBUG: a single post")
            return
        } //if postSingle has a value, then we wont fetch all the posts
        
        //the completionBlock grabs data fetched from PostService.fetchPost() and assign it into "postsInfo"
        PostService.fetchPost(completionBlock: { (postsInfo) in
            self.posts = postsInfo //assign data fetched to self.posts
            
            print("DEBUG: just fetch posts")
            self.checkIfUserLikedPost()
            self.collectionView.refreshControl?.endRefreshing()
            //self.collectionView.reloadData() //either called here or "didSet"
        })
    }
    
    
    func checkIfUserLikedPost() {
        //we use forLoop to loop through all the fetched post for like-checking
        self.posts.forEach { (eachPost) in
            
            PostService.checkIfUserLikedPost(postInfo: eachPost) { (likeOrNot) in
                
                //print("DEBUG: post \(postStuff.ownerEmail) is \(didLike)")
                
                //just set "$0.postID == eachPost.postID"
                if let index = self.posts.firstIndex(where: { $0.postID == eachPost.postID }) {
                    self.posts[index].didLike = likeOrNot
                }
            }
        }
        
        
    }
    
//MARK: - Actions
    
    //gotta use "do - catch" statement to implement the signOut process to minimize the potential errors
    @objc func handleLogOut() {
        do {
            print("DEBUG: logging user out..")
            try Auth.auth().signOut()
            let vc = LoginController()
            vc.delegate = self.tabBarController as? MainTabController
            
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: fail to sign out..")
        }
        
    }
    
    //remove all cells then re-fetch posts
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    
//MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        
        //we can register with CollectionViewCell.self if we dont want the customize cells
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //configure back button based on status of postSingle
        if postSingle == nil {
            
            //let's deal with the NavigationItems on NavigationBar
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogOut))
        }
        navigationItem.title = "Feeds"
        
        //let's add the pulldown refresh
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
        
    }
    
    

}


//MARK: - Extensions Cell Datasource

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //the return statement will return the cells/blocks in horizontal order, not like vertical in tableView. If you set the size of the cells big, then it will be placed in either vertical/horizontal order to fit all the cells
        return postSingle == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //the deueue stuff: when user scrolls, the cells will be created and presented on screen. When user scrolls through the cells, then cells are "dequeued" and moved to memory catch. This avoids loading thousands of cells when the app first loaded
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self //to make protocol works
        //cell.backgroundColor = .red
        
        //if postSingle is nil (we dont assign value), then postAlone is error
        if let postAlone = postSingle {
            cell.viewModel = PostViewModel(posts: postAlone)
        } else {
            cell.viewModel = PostViewModel(posts: posts[indexPath.row]) //let's set post's info fetched to match with cells' info
        }
        
        
        
        return cell
    }
}


//MARK: - Extensions Cell layout

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthCell = view.frame.width
        var heightCell = widthCell + 8 + 40 + 8 //the postImage will be a square, 8 are the distance between small views, 40 is height of profileImage
        heightCell += 50 //heightCell = heightCell + 50
        heightCell = heightCell + 60 //so 50 and 60 are height of likeButton and like Label
        
        return CGSize(width: widthCell, height: heightCell)
    }
    
    
}

//MARK: - Protocol conformance
//protocol created in FeedCell to call out the CommantController
extension FeedController: FeedCellDelegate {
    //remember to write ".delegate = self" above
    func cell(_ cell: FeedCell, commentFor post: Post) {
        let vc = CommentController(posts: post) //cuz it is collectionView, so it needs FlowLayout (init in CommentVC)
        //print("DEBUG: postID is \(post.postID)")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func cellLike(_ cell: FeedCell, didLike post: Post) {
        print("DEBUG: like tapped, protocol conformed in FeedVC")
        cell.viewModel?.post.didLike.toggle() //the "toggle" property will change the value between true and false
        
        if post.didLike {
            print("DEBUG: just unlike post..")
            
            PostService.unlikePost(postInfo: post) { (error) in
                if let e = error?.localizedDescription {
                    print("DEBUG: error unliking post \(e)")
                    return
                }
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
                print("DEBUG: successfully upload unlike to DB")
            }
            
        } else {
            print("DEBUG: just like post..")
            
            PostService.likePost(postInfo: post) { (error) in
                
                if let e = error?.localizedDescription {
                    print("DEBUG: error liking Post \(e)")
                    return
                }
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                print("DEBUG: successfully upload like to DB")
            }
        }
        
    }//end of func
    
    
}
