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
import CoreLocation
import MapKit

protocol SavingPlacesDelegate {
    func savePlace(name: String, coordinate: CLLocationCoordinate2D)
}


class FavPlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfilePictureDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var favPlacesTableView: UITableView!
    var favPlaces: [FavouritePlace] = []
    var selectedCustomImage: UIImage!
    var checkChangesForProfilePic: Bool!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPlaces = [FavouritePlace]()
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
    var favPlaceMark: MKPlacemark!
    
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
        searchController.searchBar.placeholder = "Search Places"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
       // getUsersFriends()
        //insertNewRequests()
        setupLongPressGesture()
        checkForPlaces()
        
    }
    
    func checkForPlaces(){
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        ref = Database.database().reference()
        
        ref.child("users").child(currentUserID).child("places").observe(.value) { (snapshot) in
            
            var retrievedPlaces = [FavouritePlace]()
            let value = snapshot.value as? NSDictionary ?? [:]
            var placeLatitudeString: String!
            var placeLongitudeString: String!
            
            for place in value {
                
                guard let placeName = place.key as? String else {return}
                print("placeName: \(placeName)")
                let coordinates = place.value as? NSDictionary ?? [:]
                
                for coordinate in coordinates {
                    
                    
                    guard let coordinateKey = coordinate.key as? String else {return }
                    print("coordinateKey: \(coordinateKey)")
                    print("coordinateValue: \(coordinate.value)")
                    if (coordinateKey == "lat"){
                        //print("coordinate equal to lat")
                        placeLatitudeString = coordinate.value as? String
                        //print("placeLatitude: \(placeLatitudeString)")
                    }
                    if(coordinateKey == "lon"){
                        //print("coordinate equal to lon")
                        placeLongitudeString = coordinate.value as? String
                       // print("placeLatitude: \(placeLongitudeString)")
                        
                        guard let placeLatitude = Double(placeLatitudeString) else {return}
                        guard let placeLongitude = Double(placeLongitudeString) else {return}
                        
                        print("placeLatitude: \(placeLatitude), placeLongitude: \(placeLongitude)")
                        
                        let currentCoordinate = CLLocationCoordinate2D(latitude: placeLatitude, longitude: placeLongitude)
                        let currentFavPlace = FavouritePlace(name: placeName, coordinate: currentCoordinate)
                        retrievedPlaces.append(currentFavPlace)
                        
                    }
                    
                    
                    
                }
                
                self.favPlaces = retrievedPlaces
                self.favPlacesTableView.reloadData()
                
            }
            
            
        }
        
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
            
            let favPlaceCoordinate = self.favPlaces[indexPathForCell.row].getCoordinate()
            print("favPlaceCoordinate lat: \(favPlaceCoordinate.latitude), lon: \(favPlaceCoordinate.longitude)")
            self.favPlaceMark = MKPlacemark(coordinate: favPlaceCoordinate)
            self.performSegue(withIdentifier: "showMap", sender: self)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (action) in
            
            let activityController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            self.present(activityController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Share with friends", style: .default, handler: { (action) in
            
            if let shareModalVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareModalVC") as? ShareModalVC {
               
                self.present(shareModalVC, animated: true, completion: nil)
            }
            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            
             let selecetedCellTitle = self.favPlacesTableView.cellForRow(at: indexPathForCell)
            guard let placeName = selecetedCellTitle?.textLabel?.text else {return}
             self.favPlaces.remove(at: indexPathForCell.row)
             self.favPlacesTableView.deleteRows(at: [indexPathForCell], with: .fade)
             self.favPlacesTableView.reloadData()
            guard let currentUserID = Auth.auth().currentUser?.uid else {return}
            
            print("secelted cell title: \(placeName)")
             self.ref.child("users").child(currentUserID).child("places").child(placeName).removeValue()
            
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
        
        if (segue.identifier == "showMap"){
            
            if let mapARVC = segue.destination as? MapARVC{
                
                mapARVC.savingPlaceDelegate = self
                mapARVC.segueToFirstScreen = false
                
                if let favPlacePlacemark = favPlaceMark {
                    mapARVC.favPlaceMark = favPlacePlacemark
                }
                
                self.navigationController?.navigationBar.prefersLargeTitles = false
            }
        }
        
        
    }
    
    @objc func addNewLocation(){
        
        print("add new place tapped")
//        if let mapARVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapARVC") as? MapARVC {
//            mapARVC.savingPlaceDelegate = self
//
//            self.navigationController?.navigationBar.prefersLargeTitles = false
//            self.navigationController?.pushViewController(mapARVC, animated: true)
//        }
        
        performSegue(withIdentifier: "showMap", sender: nil)
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
            cell.textLabel?.text = filteredPlaces[indexPath.row].getName()
        }else {
            cell.textLabel?.text = favPlaces[indexPath.row].getName()
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
        filteredPlaces = favPlaces.filter({( place : FavouritePlace) -> Bool in
            return place.getName().lowercased().contains(searchText.lowercased())
        })
        
        favPlacesTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func saveNewPlaceToDatabase(name: String, coordinate: CLLocationCoordinate2D) {
        
        ref = Database.database().reference()
        
        guard let currendUserID = Auth.auth().currentUser?.uid else {return}
        let savingLatitude = String(coordinate.latitude)
        let savingLongitude = String(coordinate.longitude)
        
        ref.child("users").child(currendUserID).child("places").child(name).updateChildValues(["lat" : savingLatitude])
        ref.child("users").child(currendUserID).child("places").child(name).updateChildValues(["lon" : savingLongitude])
        
        
        
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

extension FavPlacesVC: SavingPlacesDelegate {
    func savePlace(name: String, coordinate: CLLocationCoordinate2D) {
        print("saving place with name: \(name) and coordinate lat: \(coordinate.latitude), lon: \(coordinate.longitude)")
        saveNewPlaceToDatabase(name: name, coordinate: coordinate)
    }
    
    
}
