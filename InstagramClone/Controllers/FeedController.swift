//
//  FeedController.swift
//  InstagramClone
//
//  Created by Long Nguyen on 2/28/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {

//MARK: - Properties
    
    
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
//MARK: - Actions
    
    //gotta use "do - catch" statement to implement the signOut process to minimize the potential errors
    @objc func handleLogOut() {
        do {
            print("DEBUG: logging user out..")
            try Auth.auth().signOut()
            let vc = LoginController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: fail to sign out..")
        }
        
    }
    
//MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        
        //we can register with CollectionViewCell.self if we dont want the customize cells
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //let's deal with the NavigationItems on NavigationBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.title = "Feeds"
        
    }
    
    
    

}


//MARK: - Extensions Cell Datasource

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //the return statement will return the cells/blocks in horizontal order, not like vertical in tableView. If you set the size of the cells big, then it will be placed in either vertical/horizontal order to fit all the cells
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //the deueue stuff: when user scrolls, the cells will be created and presented on screen. When user scrolls through the cells, then cells are "dequeued" and moved to catch. This avoids loading thousands of cells when the app first loaded
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        //cell.backgroundColor = .red
        
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
