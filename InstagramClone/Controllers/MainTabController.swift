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
    
    private var user: User? {
        didSet {
            guard let userFetched = user else { return }
            configureViewController(withUser: userFetched)
        }
    }
    
    
//MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        
        checkIfUserLoggedIn()
        fetchUsers()
        //logOut()
    }
    
    
//MARK: - API
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            //gotta put them in the DispatchQueue to make sure no memory leaks or other potential errors
            DispatchQueue.main.async {
                let vc = LoginController()
                vc.delegate = self //set this to make protocol works
                
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
    
    
    func fetchUsers() {
        print("DEBUG: Calling API to fetch userInfo..")
        UserService.fetchUser { (userInfoFetched) in
            print("DEBUG: filling userInfo with data fetched from Firebase")
            //let's fill (or refill with new info) up the var "userProfile" with data fetched from Firebase
            self.user = userInfoFetched //"userInfoFetched" is var "userInfo" in file "UserService"
            guard let userNameFetch = self.user?.username else { return }
            print("DEBUG: username is \(userNameFetch)")
        }
    }
    
    
//MARK: Helpers
    
    func configureViewController(withUser userStuff: User) {
        
        //the feed page is collection view, so gotta be careful and do more work on that to make it work
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootVC: FeedController(collectionViewLayout: layout))
            
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootVC: SearchController())
        
        
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: UIImage(systemName: "plus.app.fill")!, rootVC: ImageSelectorController())
        
        let notification = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootVC: NotificationController())
        
        
        let profileVC = ProfileController(userFetched: userStuff)
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootVC: profileVC)
        
        viewControllers = [feed, search, imageSelector, notification, profile]
        tabBar.tintColor = .black //make it black for selectedImage
    }
    
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootVC: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootVC)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        
        return nav
    }

}


//MARK: - Protocol from VCs of Authentication
//remember to write "vc.delegate = self" in the func checkIfUserLoggedIn()
extension MainTabController: AuthenticationDelegate {
    
    func authenticationDidComplete() {
        print("DEBUG: protocol called from LoginVC to MainTabVC..")
        fetchUsers()
    }
    
    
}
