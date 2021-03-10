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
    
//MARK: - Lifecycle
    
    init(userFetched: User) {
        self.userProfile = userFetched
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        
    }
    
    
    
//MARK: - API
    
    

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
        return 9 //this is the item, nothing to do with the header
    }
    
    //implement the customized ProfileCell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        
        return cell
    }
    
    //this func will implement the headercell (ProfileHeader)
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("DEBUG: returning ProfileHeader")
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        //let's fill in the "var viewModel" with info fetched from Firebase. We also trigger the "var viewModel" of ProfileHeader file to call its didSet function
        header.viewModel = ProfileHeaderViewModel(userinfo: userProfile)
        
        
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
