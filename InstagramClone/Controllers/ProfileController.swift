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

    //if you dont like the didSet, then put it in func fetchUsers() in the API section
    var userProfile: User? {
        didSet { navigationItem.title = userProfile?.username }
    } //when this var is called, it immediately set the navigationItem.title
    
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        fetchUsers()
    }
    
    
    
//MARK: - API
    
    func fetchUsers() {
        print("DEBUG: Calling API to fetch userInfo")
        UserService.fetchUser { (userInfoFetched) in
            print("DEBUG: filling userInfo with data fetched from Firebase")
            //let's fill up the var "userProfile" with data fetched from Firebase
            self.userProfile = userInfoFetched //"userInfoFetched" is var "userInfo" in file "UserService"
        }
    }

//MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    

}


//MARK: - Extension Datasource
//the ProfileController is already UICollectionViewController, so no need to conform the protocol UICollectionViewDatasource
extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9 //this is the item, nothing to do with the header
    }
    
    //implement the customized ProfileCell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        
        return cell
    }
    
    //this func will implement the headercell (ProfileHeader)
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        return header
    }
    
}


//MARK: - Extension Delegate
//same like the Datasource
extension ProfileController {
    
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
