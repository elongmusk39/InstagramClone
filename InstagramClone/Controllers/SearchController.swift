//
//  SearchController.swift
//  InstagramClone
//
//  Created by Long Nguyen on 2/28/21.
//

import UIKit

private let reuseIdentifier = "UserCell"

class SearchController: UITableViewController {

//MARK: - Properties
    
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

        configureTableView()
        fetchUserList()
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
    
//MARK: - Helpers
    
    func configureTableView() {
        tableView.backgroundColor = .white
        navigationItem.title = "Search"
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
        
        searchBarController.searchResultsUpdater = self
    }

}


//MARK: - Extension datasources
//datasource will take care of the UI of the tableView
extension SearchController {
    
    //this func determines how many cells will be returned
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return userArray.count //this will return all users in database
        
        return isSearchMode ? filteredUsers.count : userArray.count //if isSearchMode == true, then return filtered users. If it's false, then return all users in database
    }
    
    //this func will take care the UI for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell.backgroundColor = .systemBlue
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        //fill in the viewModel "var userVM" created in the UserCell with info fetched. First launch it is nothing, but then the reloadData() calls back and now we have all data fetched
        let users = isSearchMode ? filteredUsers[indexPath.row] : userArray[indexPath.row] //if isSearchMode == true, then return filtered users. If it's false, then return all users in database
        
        cell.userVM = UserCellViewModel(userInfo: users)
        
        return cell
    }
    
}

//MARK: - Extension Delegate

extension SearchController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("DEBUG: user clicked is \(userArray[indexPath.row].username)")
        let users = isSearchMode ? filteredUsers[indexPath.row] : userArray[indexPath.row] //if isSearchMode == true, then return filtered users. If it's false, then return all users in database
        let vc = ProfileController(userFetched: users)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


//MARK: - Extension SearchBar
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
