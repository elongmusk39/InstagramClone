//
//  SearchController.swift
//  InstagramClone
//
//  Created by Long Nguyen on 2/28/21.
//

import UIKit

private let reuseIdentifier = "UserCell"
private let postCellIdentifier = "PhotoCell"

class SearchController: UIViewController {

//MARK: - Properties
    
    private let tableView = UITableView()
    
    
    private var postArray = [Post]()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: postCellIdentifier)
        
        return cv
    }()
    
    private var userArray = [User]()
    
    //the 3 vars below are for searching function
    private let searchBarController = UISearchController(searchResultsController: nil)
    private var filteredUsers = [User]()
    
    //this var is dynamics, which changes its value all the time depending on the searchBar's behavior
    private var isSearchMode: Bool {
        return searchBarController.isActive && !searchBarController.searchBar.text!.isEmpty
        //returns true only if searchBar is active and searchText is NOT empty
    }
    
//MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchUserList()
        fetchPost()
        configureSearchBarController()
    }
    
    
//MARK: - API
    
    func fetchUserList() {
        UserService.fetchUserlist { (userslist) in
            self.userArray = userslist //fill in the array "userArray" with all info of all users (it's a big array of arrays)
            print("DEBUG: from SearchVC, userArray is \(self.userArray)")
            self.tableView.reloadData() //this func bascially re-call the collection/tableView (re-call all extensions of Datasource Delegate, flowLayout,...)
        }
        
    }
    
    func fetchPost() {
        PostService.fetchPost { (posts) in
            self.postArray = posts
            self.collectionView.reloadData()
        }
    }
    
//MARK: - Helpers
    
    func configureUI() {
        tableView.backgroundColor = .white
        navigationItem.title = "Search"
        
        //make the tableView works since this is a UIViewController
        tableView.delegate = self
        tableView.dataSource = self
        
        //the foundation is the tableView
        view.addSubview(tableView)
        tableView.fillSuperview() //we fill the entire big view with created tableView
        tableView.isHidden = true //we want to hide tableView by default
        
        //then we put a collectionView on top of tableView
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        //for un-modified cell, use "UITableViewCell.self"
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        //let's modify each row
        tableView.rowHeight = 64
        
    }
    
    
    func configureSearchBarController() {
        searchBarController.obscuresBackgroundDuringPresentation = false
        searchBarController.hidesNavigationBarDuringPresentation = true
        searchBarController.searchBar.placeholder = "Search for users.."
        navigationItem.searchController = searchBarController
        definesPresentationContext = false
        
        searchBarController.searchBar.delegate = self
        
        searchBarController.searchResultsUpdater = self
    }

}


//MARK: - Extension datasources
//datasource will take care of the UI of the tableView
extension SearchController: UITableViewDataSource {
    
    //this func determines how many cells will be returned
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return userArray.count //this will return all users in database
        
        return isSearchMode ? filteredUsers.count : userArray.count //if isSearchMode == true, then return filtered users. If it's false, then return all users in database
    }
    
    //this func will take care the UI for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell.backgroundColor = .systemBlue
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        //fill in the viewModel "var userVM" created in the UserCell with info fetched. First launch it is nothing, but then the reloadData() calls back and now we have all data fetched
        let users = isSearchMode ? filteredUsers[indexPath.row] : userArray[indexPath.row] //if isSearchMode == true, then return filtered users. If it's false, then return all users in database
        
        cell.userVM = UserCellViewModel(userInfo: users)
        
        return cell
    }
    
}

//MARK: - Extension Delegate

extension SearchController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("DEBUG: user clicked is \(userArray[indexPath.row].username)")
        let users = isSearchMode ? filteredUsers[indexPath.row] : userArray[indexPath.row] //if isSearchMode == true, then return filtered users. If it's false, then return all users in database
        let vc = ProfileController(userFetched: users)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


//MARK: - SearchBar Result update
//remember to write "searchBarController.searchResultsUpdater = self"
extension SearchController: UISearchResultsUpdating {
    
    //this func gets called whenever we type something in the search textBox
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchBarController.searchBar.text?.lowercased() else { return }
        print("DEBUG: searchText is \(searchText)")
        
        //Set the filteredUsers - the tableView will return associated cells if "username" or "fullname" or "email" contains the searchText
        self.filteredUsers = userArray.filter({
            $0.username.lowercased().contains(searchText) || $0.fullname.lowercased().contains(searchText) || $0.email.lowercased().hasPrefix(searchText) //make this shit prefix since all users have "@gmail.com"
        }) //keep in mind, this shit is CASE SENSITIVE, so we convert both the searchText and ("username" "fullname", "uid") to lowercased
        
        print("DEBUG: filtered users are \(filteredUsers)")
        self.tableView.reloadData()
    } //end of func
    
    
}

//MARK: - SearchBar Delegate
//this extension declares what happen when user clicks on the searchBar or the "cancel" button
//remember to write "searchBarController.searchBar.delegate = self"
extension SearchController: UISearchBarDelegate {
    
    //this is what happens when searchBar is clicked
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        collectionView.isHidden = true
        tableView.isHidden = false
    }
    
    //what happens when cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true) //dismiss the keyboard
        searchBar.showsCancelButton = false
        searchBar.text = ""
        
        collectionView.isHidden = false
        tableView.isHidden = true
    }
}


//MARK: - CollectionView Datasource
//collectionView datasource
extension SearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        postArray.count
    }
    
    //implement the customized ProfileCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellIdentifier, for: indexPath) as! ProfileCell
        
        //let's fill up the viewModel of profileCell with data fetched, this case we utilize the profileVC to show all posts in the database
        cell.viewModel = PostViewModel(posts: postArray[indexPath.row])
        
        return cell
    }
    
    
}


//MARK: - CollectionView delegate
extension SearchController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: post is \(postArray[indexPath.row].caption)")
        
        let vc = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.postSingle = postArray[indexPath.row] //set value to postSingle
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK: - DelegateFlowlayout

extension SearchController: UICollectionViewDelegateFlowLayout {
    
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
