//
//  NotificationController.swift
//  InstagramClone
//
//  Created by Long Nguyen on 2/28/21.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController: UITableViewController {

//MARK: - Properties
    
    //with "didSet", whenever the array got modified, we reload the tableView
    private var notificationsArray = [Notification]() {
        didSet { tableView.reloadData() }
    }
    
    private let refresher = UIRefreshControl()
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureTableView()
        fetchNotifications()
    }
    
    
//MARK: - APIs
    
    func fetchNotifications() {
        NotificationService.fetchNotification { (notifications) in
            self.notificationsArray = notifications
            self.checkIfUserIsFollowed()
        }
    }

    //let's loop through all notification cells
    func checkIfUserIsFollowed() {
        //"notificationInfo" is each index of "notificationArray"
        notificationsArray.forEach { (notificationInfo) in
            guard notificationInfo.type == .follow else { return } //only check (doing API) if the type is follow so that we dont have to check all notifications
            
            UserService.checkIfUserIsFollowed(uidOtherUser: notificationInfo.uid) { (isFollowed) in
                
                if let index = self.notificationsArray.firstIndex(where: { $0.IDNotifi == notificationInfo.IDNotifi }) {
                    
                    self.notificationsArray[index].userIsFollowed = isFollowed
                }
            }
        }
        
    }
    
// MARK: - Helpers

    func configureTableView() {
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .singleLine
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    
    @objc func handleRefresh() {
        notificationsArray.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }

}


//MARK: - Extension Datasource

extension NotificationController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        //cell.backgroundColor = .systemRed
        cell.viewModel = NotificationViewModel(withNotification: notificationsArray[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
}

//MARK: - Extension Delegate

extension NotificationController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("DEBUG: notification cell tapped..")
        showLoader(true)
        
        let uid = notificationsArray[indexPath.row].uid
        UserService.fetchUser(withUID: uid) { (user) in
            self.showLoader(false)
            let vc = ProfileController(userFetched: user)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


//MARK: Protocols conformance
//remember to write "cell.delegate = self"
extension NotificationController: NotificationCellDelegate {
    func cellFollow(_ cell: NotificationCell, wantsToFollow uid: String) {
        print("DEBUG: let's follow a user")
        showLoader(true)
        
        UserService.follow(uidOtherUser: uid, emailOtherUser: "none") { (error) in
            self.showLoader(false)
            cell.viewModel?.notifications.userIsFollowed.toggle()
        }
        
    }
    
    func cellUnFollow(_ cell: NotificationCell, wantsToUnFollow uid: String) {
        print("DEBUG: unfollow this guy..")
        showLoader(true)
        
        UserService.unfollow(uidOtherUser: uid) { (error) in
            self.showLoader(false)
            cell.viewModel?.notifications.userIsFollowed.toggle()
        }
        
    }
    
    func cellPost(_ cell: NotificationCell, wantsToViewPost postID: String) {
        print("DEBUG: show post..")
        showLoader(true)
        
        PostService.fetchPostWithPostID(postId: postID) { postFetched in
            self.showLoader(false)
            let vc = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            vc.postSingle = postFetched
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
