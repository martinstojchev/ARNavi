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



class FavPlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfilePictureDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var favPlacesTableView: UITableView!
    var favPlaces: [String] = ["Home", "Work", "City Mall"]
    var selectedCustomImage: UIImage!
    var checkChangesForProfilePic: Bool!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPlaces = [String]()
    var userFriends:[Friend] = [Friend]()
    var quickAction: String! {
        didSet {
         //print("didSet quick action")
            performSegue(withIdentifier: "showSideMenu", sender: nil)
            quickAction = ""
        }
    }
    var ref: DatabaseReference!
    let impact = UIImpactFeedbackGenerator()
    
    
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
        
       // getUsersFriends()
        //insertNewRequests()
        setupLongPressGesture()
        
    }
    
    func setupLongPressGesture(){
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.6
        longPressGesture.delegate = self
        self.favPlacesTableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
   
        if gestureRecognizer.state == .ended {
            
          let touchPoint = gestureRecognizer.location(in: self.favPlacesTableView)
            
            if let indexPath = favPlacesTableView.indexPathForRow(at: touchPoint){
             
                print("favPlace long press: \(favPlaces[indexPath.row])")
                guard let selectedCell = favPlacesTableView.cellForRow(at: indexPath) else { return }
                
                showAlertLongPress(forCell: selectedCell)
            }
            
         }
        
        if gestureRecognizer.state == .began{
        impact.impactOccurred()
        }
    }
    
    func showAlertLongPress(forCell cell: UITableViewCell){
        
        guard let favPlaceName = cell.textLabel?.text else {return }
        
        let shareText = favPlaceName.appending(" with coordinate(lat: 20.232312312, lon: 23.323211441)")
        
        guard let indexPathForCell = favPlacesTableView.indexPath(for: cell) else {return}
        
      let alert = UIAlertController(title: "Select action for \(favPlaceName)", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Show in AR", style: .default, handler: { (action) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Show on map", style: .default, handler: { (action) in
                
        }))
        
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (action) in
            
            let activityController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            self.present(activityController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            
             self.favPlaces.remove(at: indexPathForCell.row)
             self.favPlacesTableView.deleteRows(at: [indexPathForCell], with: .fade)
             self.favPlacesTableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        present(alert, animated: true)
        
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
                
                if let quickAct = quickAction {
                
                 sideMenuVC.quickAction = quickAct
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
    
    
//    func getUsersFriends(){
//
//        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
//
//        var userFriends:[Friend] = [Friend]()
//
//        self.ref.child("users").child(currentUserID).observeSingleEvent(of: .value, with: { (snapshot) in
//
//            let value = snapshot.value as? NSDictionary
//            let friends = value?["friends"] as? NSDictionary ?? [:]
//            let ids  = friends["id"] as? NSArray ?? []
//
//            for id in ids{
//                guard let friendsId = id as? String else {return }
//                print("frineds id: \(friendsId)")
//
//                 // get the info for every user id
//
//                self.ref.child("users").child(friendsId).observeSingleEvent(of: .value, with: { (snapshot) in
//
//                    let value = snapshot.value as? NSDictionary
//                    let name = value?["name"] as? String ?? ""
//                    let email = value?["email"] as? String ?? ""
//                    let username = value?["username"] as? String ?? ""
//
//                    let newFriend = Friend(userID: friendsId, name: name, username: username, email: email, image: UIImage())
//                    userFriends.append(newFriend)
//                    print("userFriends \(userFriends.count)")
//                    self.userFriends = userFriends
//
//
//                })
//            }
//
//
//
//        }) { (error) in
//
//
//            print("error: \(error.localizedDescription)")
//
//
//        }
//
//
//    }
    
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
