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



class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate{
    
    
    
    @IBOutlet weak var friendsTableView: UITableView!
    
//    var friendsData = [FriendsData]()
    var friends = [Friend]()
    var filteredFriends = [Friend]()
    let searchController = UISearchController(searchResultsController: nil)
    var ref: DatabaseReference!
    let impact = UIImpactFeedbackGenerator()
    var fourcedTouchFriend: Friend!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
   
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: friendsTableView)
        }
        else {
            print("Peak and pop isn't compatible")
        }
        
        let rightBarButtonImg = UIImage(named: "search_icon")
        let rightNavBarButton = UIBarButtonItem(image: rightBarButtonImg, style: .done, target: self, action: #selector(showSearchBar))
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        self.navigationItem.title = "Friends"
        friendsTableView.dataSource = self
        friendsTableView.delegate   = self
        friendsTableView.backgroundColor = AppColor.backgroundColor.rawValue
        view.backgroundColor = AppColor.backgroundColor.rawValue
        // Do any additional setup after loading the view.
        setupSearchController()
        definesPresentationContext = true
        
        checkForFriends()
        
    }
    
    @objc func setupSearchController(){
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Friends"
        navigationItem.searchController = searchController
        
    }
    
    @objc func showSearchBar(){
        present(searchController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredFriends.count
        }
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Preparing for peak and pop preview friends
        
       
        
        var cellTitle: String!
        let userID: String!
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
        if isFiltering(){
         cellTitle = filteredFriends[indexPath.row].getName()
         userID = filteredFriends[indexPath.row].getUserID()
        }
        else {
         cellTitle = friends[indexPath.row].getName()
            userID = friends[indexPath.row].getUserID()
        }
        
       
        
        let cellImage = UIImage()
        
        var buttonText:String!
        var buttonColor: AppColor!
        
        if friends.contains(where: { (friend) -> Bool in
            return friend.getName().elementsEqual(cellTitle)
        }) {
            print("searched user is friend")
            buttonText = "Remove"
            buttonColor = AppColor.red
        }
        else {
            print("searched user is not friend")
            buttonText = "Add"
            buttonColor = AppColor.green
        }
        cell.addRemoveDelegate = self
        cell.setFriendsCell(cellImage: cellImage, title: cellTitle, buttonText: buttonText, buttonColor: buttonColor, userID: userID)
        
        return cell
    }
    
    //peek and pop methods
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        
        guard let forcePressedIndexPath = friendsTableView.indexPathForRow(at: location) else {return nil}
        guard let cell = friendsTableView.cellForRow(at: forcePressedIndexPath) as? FriendsCell else {return nil}
        let tappedFriend = friends[forcePressedIndexPath.row]
        fourcedTouchFriend = tappedFriend
        print("force pressed cell : \(cell.cellLabel.text)")
        print("friend for cell : \(tappedFriend.getName())")
        
        guard let previewView = storyboard?.instantiateViewController(withIdentifier: "PreviewFriendVC") as? PreviewFriendVC else {return nil}
        previewView.tappedFriend = tappedFriend
        return previewView
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        

        guard let finalView = storyboard?.instantiateViewController(withIdentifier: "ShowFriendVC") as? ShowFriendVC else {return}
        if let friend = fourcedTouchFriend {
          finalView.showingFriend = friend
            finalView.isFriend = true
            finalView.navigationController?.navigationBar.prefersLargeTitles = false
        }
        show(finalView, sender: self)
    }
    
    func checkForFriends(){
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
            
            
            ref.child("users").child(currentUserID).child("friends").observe(.value) { (snapshot) in
                
                var retrievedFriends = [Friend]()
                let value = snapshot.value as? NSDictionary ?? [:]
                print("requests value: \(value)")
                for ids in value {
                    let id = ids.key as? String ?? ""
                    print("id: \(id)")
                    
                            if let friendIDString = ids.key as? String {
                                print("friendIDString: \(friendIDString)")
                                // find the info for the founded users
                                self.ref.child("users").child(friendIDString).observeSingleEvent(of: .value, with: { (snapshot) in
                                    
                                    let value = snapshot.value as? NSDictionary ?? [:]
                                    let name = value["name"] as? String ?? ""
                                    let email = value["email"] as? String ?? ""
                                    let username = value["username"] as? String ?? ""
                                    
                                    let foundFriend = Friend(userID: friendIDString, name: name, username: username, email: email, image: UIImage())
                                    retrievedFriends.append(foundFriend)
                                    self.friends = retrievedFriends
                                    self.friendsTableView.reloadData()
                                    print("friends count: \(self.friends.count)")
                                    
                                })
                                
                            }
                }
       }
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

extension FriendsVC : AddRemoveFriendDelegate {
    
    func addFriend(withID id: String) {
        print("friendsVC add friend withID: \(id)")
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let requestsID = id
        self.ref.child("requests").child(id).updateChildValues([currentUserID : currentUserID])
        impact.impactOccurred()
        //ref.child("users").child(id).updateChildValues(["requests" : currentUserID])
        
    }
    
    func removeFriend(withID id: String) {
        print("friendsVC remove friend withID: \(id)")
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        impact.impactOccurred()
        //Removing friend from current's friend list
        self.ref.child("users").child(currentUserID).child("friends").child(id).removeValue { (error, databaseRef) in
            
            if let err = error {
                print("error while removing friend from current user's friend list")
                print(err.localizedDescription)
            }
            else {
                self.checkForFriends()
            }
        }
        
        //Removing currendUser from the oposite's friend list
        self.ref.child("users").child(id).child("friends").child(currentUserID).removeValue()
        
        
    }
}
