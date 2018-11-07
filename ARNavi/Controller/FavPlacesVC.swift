//
//  FavPlacesVC.swift
//  ARNavi
//
//  Created by Martin on 10/22/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import FirebaseDatabase



class FavPlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfilePictureDelegate {
    
    @IBOutlet weak var favPlacesTableView: UITableView!
    let favPlaces: [String] = ["Home", "Work", "City Mall"]
    var selectedCustomImage: UIImage!
    var checkChangesForProfilePic: Bool!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPlaces = [String]()
    var userFriends:[Friend] = [Friend]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        favPlacesTableView.dataSource = self
        favPlacesTableView.delegate   = self
        navigationItem.title = "Favourite places"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationItem.title = "Favourite places"
        navigationController?.navigationBar.tintColor = UIColor.red
        //navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sheets_icon"), style: .plain, target: self, action: #selector(showLeftMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "placemark_icon"), style: .plain, target: self, action: #selector(addNewLocation))
        
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        getUsersFriends()
        //insertNewRequests()
        
    }
   
    
    @objc func showLeftMenu(){
        
        performSegue(withIdentifier: "showSideMenu", sender: nil)
        print("performSegue")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showSideMenu"){
         
            print("prepareForSegue")
            // using segue.destination.children.first because the destination is SideMenu navigation controller
            if let sideMenuVC =  segue.destination.children.first as? SideMenuVC {
                //set the user's name
                sideMenuVC.pictureDelegate = self
                let name = Auth.auth().currentUser?.displayName
                sideMenuVC.currentUserName = name
                
                if let customImg = selectedCustomImage {
                sideMenuVC.currentProfilePicture = customImg
                    print("customImg for side menu")
                    
                }
                
                sideMenuVC.userFriends = userFriends
                
                if let checkProfilePic = checkChangesForProfilePic {
                    print("checkProfilePic: \(checkProfilePic)")
                    if (checkProfilePic){
                        //call check for profile pic changes
                        sideMenuVC.checkImageChanges = true
                        print("checking for profileImage changed")
                    }
                }
                
            }
        }
        
        
    }
    
    @objc func addNewLocation(){
        
        print("add new place tapped")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering(){
            return filteredPlaces.count
        }
        return favPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if isFiltering(){
            cell.textLabel?.text = filteredPlaces[indexPath.row]
        }else {
            cell.textLabel?.text = favPlaces[indexPath.row]
        }
        
        
        return cell 
    }
    
    func changePickedProfilePicture(image: UIImage?) {
        if let uploadedImage = image {
            selectedCustomImage = uploadedImage
            print("favplaceVC selectedCustom image set")
        }
    }
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredPlaces = favPlaces.filter({( place : String) -> Bool in
            return place.lowercased().contains(searchText.lowercased())
        })
        
        favPlacesTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

extension FavPlacesVC: UISideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
        
    }
    
    
    func getUsersFriends(){
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        var userFriends:[Friend] = [Friend]()
        
        self.ref.child("users").child(currentUserID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let friends = value?["friends"] as? NSDictionary ?? [:]
            let ids  = friends["id"] as? NSArray ?? []
            
            for id in ids{
                guard let friendsId = id as? String else {return }
                print("frineds id: \(friendsId)")
                
                 // get the info for every user id
                
                self.ref.child("users").child(friendsId).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    let name = value?["name"] as? String ?? ""
                    let email = value?["email"] as? String ?? ""
                    let username = value?["username"] as? String ?? ""
                    
                    let newFriend = Friend(userID: friendsId, name: name, username: username, email: email, image: UIImage())
                    userFriends.append(newFriend)
                    print("userFriends \(userFriends.count)")
                    self.userFriends = userFriends
                    
                    
                })
            }
            
           
            
        }) { (error) in
            
            
            print("error: \(error.localizedDescription)")
            
            
        }
        
        
    }
    
    func insertNewRequests(){
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let requestsID = ["tVsSzAgJkbbMa11Oe7XJPrVduzp2"]
        self.ref.child("requests").updateChildValues([currentUserID : requestsID])
        
        ref.child("users").child(currentUserID).updateChildValues(["requests" : "tVsSzAgJkbbMa11Oe7XJPrVduzp2"])
        
    }
    
}

extension FavPlacesVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
