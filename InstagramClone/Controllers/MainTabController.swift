//
//  MainTabController.swift
//  InstagramClone
//
//  Created by Long Nguyen on 2/28/21.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {

//MARK: - Properties
    
    
//MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        configureViewController()
        checkIfUserLoggedIn()
        //logOut()
    }
    
    
//MARK: - API
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            //gotta put them in the DispatchQueue to make sure no memory leaks or other potential errors
            DispatchQueue.main.async {
                let vc = LoginController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            print("DEBUG: presenting LoginVC..")
        } else {
            guard let userEmail = Auth.auth().currentUser?.email else {
                return
            }
            print("DEBUG: user logged in as \(userEmail)")
        }
        
    }
    
    //gotta use "do - catch" statement to implement the signOut process to minimize the potential errors
    func logOut() {
        do {
            print("DEBUG: logging user out..")
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: fail to sign out..")
        }
        
    }
    
//MARK: Helpers
    
    func configureViewController() {
        
        //the feed page is collection view, so gotta be careful and do more work on that to make it work
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootVC: FeedController(collectionViewLayout: layout))
            
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootVC: SearchController())
        
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: UIImage(systemName: "plus.app.fill")!, rootVC: ImageSelectorController())
        
        let notification = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootVC: NotificationController())
        
        //the profile page is collection view, so gotta be careful and do more work on that to make it work
        let profileLayout = UICollectionViewFlowLayout()
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootVC: ProfileController(collectionViewLayout: profileLayout))
        
        viewControllers = [feed, search, imageSelector, notification, profile]
        tabBar.tintColor = .black
    }
    
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootVC: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootVC)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        
        return nav
    }

}
