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




class FavPlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfilePictureDelegate {
    
    
    

    @IBOutlet weak var favPlacesTableView: UITableView!
    let favPlaces: [String] = ["Home", "Work", "City Mall"]
    
    var selectedCustomImage: UIImage!
    var checkChangesForProfilePic: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favPlacesTableView.dataSource = self
        favPlacesTableView.delegate   = self
        navigationItem.title = "Favourite places"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationItem.title = "Favourite places"
        navigationController?.navigationBar.tintColor = UIColor.red
        //navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sheets_icon"), style: .plain, target: self, action: #selector(showLeftMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "placemark_icon"), style: .plain, target: self, action: #selector(addNewLocation))
        
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
        return favPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = favPlaces[indexPath.row]
        
        return cell 
    }
    
    func changePickedProfilePicture(image: UIImage?) {
        if let uploadedImage = image {
            selectedCustomImage = uploadedImage
            print("favplaceVC selectedCustom image set")
        }
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
}
