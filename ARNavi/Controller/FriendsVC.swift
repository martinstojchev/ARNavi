//
//  FriendsVC.swift
//  ARNavi
//
//  Created by Martin on 10/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

struct FriendsData {
    let image : UIImage?
    let title : String?
}

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    var friendsData = [FriendsData]()
    var friends = ["Mirko","Petar","Slave","Letka","Stojce","Leon","Boris"]
    var filteredFriends = [FriendsData]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Friends"
        friendsTableView.dataSource = self
        friendsTableView.delegate   = self
        friendsTableView.backgroundColor = AppColor.backgroundColor.rawValue
        view.backgroundColor = AppColor.backgroundColor.rawValue
        // Do any additional setup after loading the view.
        friendsData.append(FriendsData(image: UIImage(named: "profile_pic"), title: "Petar"))
        friendsData.append(FriendsData(image: UIImage(named: "profile_pic"), title: "Leon"))
        friendsData.append(FriendsData(image: UIImage(named: "profile_pic"), title: "Mirko"))
        friendsData.append(FriendsData(image: UIImage(named: "profile_pic"), title: "Boris"))
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Friends"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredFriends.count
        }
        return friendsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellTitle: String!
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
        if isFiltering(){
         cellTitle = filteredFriends[indexPath.row].title!
        }
        else {
         cellTitle = friendsData[indexPath.row].title!
        }
        let cellImage = friendsData[indexPath.row].image!
        
        
        cell.setFriendsCell(cellImage: cellImage, title: cellTitle)
        
        return cell
    }
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredFriends = friendsData.filter({( friend : FriendsData) -> Bool in
            return friend.title!.lowercased().contains(searchText.lowercased())
        })
        
        friendsTableView.reloadData()
    }
    

}


extension FriendsVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
   
}
