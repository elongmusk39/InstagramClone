//
//  ProfileController.swift
//  InstagramClone
//
//  Created by Long Nguyen on 2/28/21.
//

import UIKit

private let cellIdentifier = "profileCell"
private let headerIdentifier = "profileHeader"


class ProfileController: UICollectionViewController {

//MARK: - Properties

    /*
    //if you dont like the didSet, then put it in func fetchUsers() in the API section
    private var userProfile: User? {
        didSet {
            print("DEBUG: let's set the title..")
            navigationItem.title = userProfile?.username
            collectionView.reloadData() //this func bascially re-call the collectionView (re-call all extensions of Datasource and Delegate)
        }
    } //when this var is called, it immediately set the navigationItem.title
    */
    
    private var userProfile: User
    private var postProfile = [Post]()
    
//MARK: - Lifecycle
    
    init(userFetched: User) {
        self.userProfile = userFetched //let's fill in "userProfile" with data fetched from SearchController()
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPosts()
    }
    
    
    
//MARK: - API
    
    func checkIfUserIsFollowed() {
        print("DEBUG: checking if this user is followed..")
        UserService.checkIfUserIsFollowed(uidOtherUser: userProfile.uid) { (isFollowed) in
            self.userProfile.isFollowed = isFollowed //update the new info and assign it to "self.userProfile"
            self.collectionView.reloadData() //let's recall all extensions of this ProfileController with updated info
        }
    }

    
    func fetchUserStats() {
        print("DEBUG: fetching user stats..")
        UserService.fetchUserStats(generalUID: userProfile.uid) { (stats) in
            self.userProfile.stats = stats //update the stats
            self.collectionView.reloadData()
        }
    }
    
    
    func fetchPosts() {
        PostService.fetchPostProfile(forUser: userProfile.uid) { (post) in
            self.postProfile = post //fill up this var with post's data
            self.collectionView.reloadData()
        }
    }
    
//MARK: - Helpers
    
    func configureCollectionView() {
        navigationItem.title = userProfile.username
        collectionView.backgroundColor = .white
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    

}


//MARK: - Extension Datasource
//the ProfileController is already UICollectionViewController, so no need to conform the protocol UICollectionViewDatasource
extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postProfile.count //this is the item, nothing to do with the header
    }
    
    //implement the customized ProfileCell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        
        //let's fill up the viewModel of profileCell with data fetched
        cell.viewModel = PostViewModel(posts: postProfile[indexPath.row])
        
        return cell
    }
    
    //this func will implement the headercell (ProfileHeader)
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("DEBUG: returning ProfileHeader")
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.delegate = self //conform to protocol from ProfileHeader
        
        //let's fill in the "var viewModel" with info fetched from Firebase. We also trigger the "var viewModel" of ProfileHeader file to call its didSet function
        header.viewModel = ProfileHeaderViewModel(userinfo: userProfile)
        
        
        return header
    }
    
}


//MARK: - Extension Delegate
//this gets called whenever we click on a cell (in this case, an image)
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: post is \(postProfile[indexPath.row].caption)")
        
        let vc = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.postSingle = postProfile[indexPath.row] //set value to postSingle
        navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - Extension DelegateFlowlayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    //let's set the size for the header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
    
    
    //spacing for row (horizontally) between items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //spacing for collumn (vertically) between items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //set size for each item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width) //it's a square
    }
    
    
}

//MARK: - Protocols
//execute the protocol from ProfileHeader, remember to write ".delegate = self"
extension ProfileController: ProfileHeaderDelegate {
    
    func header(_ header: ProfileHeader, didTapActionBtnFor otherUser: User) {
        print("DEBUG: protocol from ProfileHeader and executed in ProfileController")
        
        guard let tab = tabBarController as? MainTabController else {return}
        guard let currentUser = tab.userMainTab else { return }
        
        if otherUser.isCurrentUser {
            print("DEBUG: show edit profile..")
            
        } else if otherUser.isFollowed {
            print("DEBUG: let's unfollow user..") //when currentUser is following another, clicking the button would execute "unfollow" action of that user
            UserService.unfollow(uidOtherUser: otherUser.uid) { (error) in
                print("DEBUG: done API, just unfollow a user..")
                self.userProfile.isFollowed = false //change this property to change the UI
                self.collectionView.reloadData()
                
                PostService.updateUserFeedAfterFollowing(user: otherUser, didFollow: false)
            }
            
        } else {
            print("DEBUG: let's follow user..")
            UserService.follow(uidOtherUser: otherUser.uid, emailOtherUser: otherUser.email) { (error) in
                print("DEBUG: done API, just follow a new user..")
                self.userProfile.isFollowed = true //change this property to change the UI
                self.collectionView.reloadData() //reload the collectionVIew means reload all extensions in this file means reload the ProfileHeader wit new info update, so UI updates too
                
                //let's upload a notification to the database
                NotificationService.uploadNotification(toUID: otherUser.uid, toEmail: otherUser.email, fromUser: currentUser, type: .follow)
                
                //populate feeds associated with new followed user (if you want to populate all post from database, just erase this line)
                PostService.updateUserFeedAfterFollowing(user: otherUser, didFollow: true)
            }
        }
        
    } //end of func
    
    
}
