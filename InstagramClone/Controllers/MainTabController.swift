//
//  MainTabController.swift
//  InstagramClone
//
//  Created by Long Nguyen on 2/28/21.
//

import UIKit
import Firebase
import YPImagePicker //this is for uploading posts

class MainTabController: UITabBarController {

//MARK: - Properties
    
    var userMainTab: User? {
        didSet {
            guard let userFetched = userMainTab else { return }
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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        UserService.fetchUser(withUID: uid) { (userInfoFetched) in
            print("DEBUG: filling userInfo with data fetched from Firebase")
            //let's fill (or refill with new info) up the var "userProfile" with data fetched from Firebase
            self.userMainTab = userInfoFetched //"userInfoFetched" is var "userInfo" in file "UserService"
            guard let userNameFetch = self.userMainTab?.username else { return }
            print("DEBUG: username is \(userNameFetch)")
        }
    }
    
    
//MARK: Helpers
    
    func configureViewController(withUser userStuff: User) {
        self.delegate = self
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
    
    //this func implements the "next" in the YPImagePicker
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { (items, _) in
            picker.dismiss(animated: true) {
                guard let selectedImage = items.singlePhoto?.image else {
                    print("DEBUG: error setting post")
                    return
                }
                print("DEBUG: selected image is \(selectedImage)")
                let vc = UploadPostController()
                vc.selectedImage = selectedImage
                vc.delegate = self
                vc.currentUser = self.userMainTab //assign userInfo to UploadPostVC
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    

}


//MARK: - Extensions Delegate
//remember to write "self.delegate = self"
extension MainTabController: UITabBarControllerDelegate {
    
    //this func gets called when we hit on a tab item on the tab bar
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController) ?? 2
        print("DEBUG: index of tab items is \(index)") //5 screens -> [0..4]
        
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = true
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesBottomBar = false
            config.hidesStatusBar = false
            config.library.maxNumberOfItems = 1 //only choose 1 pict per post
            
            //for this shit to get going, go to info.plist and add "Privacy - Photo library usage description" or "Privacy - Camaera usage description" (if you want to access the camera)
            let picker = YPImagePicker(configuration: config)
            picker.modalTransitionStyle = .coverVertical
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMedia(picker) //implement func for "next" btn
        }
        
        return true
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


//MARK: - Protocol from UploadPostVC
//remember to write ".delegate = self"
extension MainTabController: UploadPostControllerDelegate {
    
    func controllerDidFinishUploading(_ controller: UploadPostController) {
        selectedIndex = 0 //go back to FeedController
        controller.dismiss(animated: true, completion: nil)
        
        //refresh the FeedVC to show the latest post
        guard let FeedNav = viewControllers?.first as? UINavigationController else { return }
        guard let feed = FeedNav.viewControllers.first as? FeedController else { return }
        feed.handleRefresh()
    }
    
    
}


