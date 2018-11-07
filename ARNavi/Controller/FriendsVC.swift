//
//  FriendsVC.swift
//  ARNavi
//
//  Created by Martin on 10/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct FriendsData {
    let image : UIImage?
    let title : String?
}

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
//    var friendsData = [FriendsData]()
    var friends = [Friend]()
    var filteredFriends = [Friend]()
    let searchController = UISearchController(searchResultsController: nil)
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        self.navigationItem.title = "Friends"
        friendsTableView.dataSource = self
        friendsTableView.delegate   = self
        friendsTableView.backgroundColor = AppColor.backgroundColor.rawValue
        view.backgroundColor = AppColor.backgroundColor.rawValue
        // Do any additional setup after loading the view.
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
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellTitle: String!
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
        if isFiltering(){
         cellTitle = filteredFriends[indexPath.row].getName()
        }
        else {
         cellTitle = friends[indexPath.row].getName()
        }
        let cellImage = UIImage()
        
        
        cell.setFriendsCell(cellImage: cellImage, title: cellTitle)
        
        return cell
    }
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
        var retrievedFriends = self.ref.child("users").observe(.value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary ?? [:]
            for friend in value {
                let friendID = friend.key as? String ?? ""
                //print("friendID: \(friendID)")
                
                if friendID != currentUserID {
                    
                let friend = friend.value as? NSDictionary ?? [:]
                guard let name = friend["name"] as? String else {return}
                
                if name.lowercased() == searchText.lowercased() {
                    let email = friend["email"] as? String ?? ""
                    let username = friend["username"] as? String ?? ""
                    
                    let foundFriend = Friend(userID: friendID, name: name, username: username, email: email, image: UIImage())
                    self.filteredFriends = []
                    self.filteredFriends = [foundFriend]
                    self.friendsTableView.reloadData()
                }
                
               }
            }
        }
        
        //print("retrievedFriends: \(retrievedFriends)")
        
        
//        filteredFriends = friends.filter({( friend : Friend) -> Bool in
//            return friend.getName().lowercased().contains(searchText.lowercased())
//        })
        
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
