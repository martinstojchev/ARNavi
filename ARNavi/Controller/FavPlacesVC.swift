//
//  FavPlacesVC.swift
//  ARNavi
//
//  Created by Martin on 10/22/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

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
        
        print("sheets icon tapped")
    }
    
    @objc func addNewLocation(){
        
        print("add new place tapped")
    }
    
    
    
}
