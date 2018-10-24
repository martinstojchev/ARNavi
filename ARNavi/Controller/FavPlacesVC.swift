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

class FavPlacesVC: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                let name = Auth.auth().currentUser?.displayName
                sideMenuVC.currentUserName = name
                //print("user email: \(user), name: \(name)")
            }
        }
        
        
    }
    
    @objc func addNewLocation(){
        
        print("add new place tapped")
    }
    
    
    
}
