//
//  FirstScreenVC.swift
//  ARNavi
//
//  Created by Martin on 9/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import Firebase

class FirstScreenVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var tryDemoButton: UIButton!
    
    var isUserLogged = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor         = AppColor.backgroundColor.rawValue
        signupButton.backgroundColor = AppColor.red.rawValue
        signupButton.tintColor       = AppColor.white.rawValue
        signupButton.layer.cornerRadius = 7
        loginButton.backgroundColor  = AppColor.gray.rawValue
        loginButton.tintColor        = AppColor.white.rawValue
        loginButton.layer.cornerRadius = 7
        print("viewDidLoad")
        // Check for previous logged user
        if Auth.auth().currentUser != nil {
            // User is signed in
            print("User \(Auth.auth().currentUser?.email) is signed in")
            
            isUserLogged = true
            //logoutCurrentUser()
        }
        else {
            // No user is signed in
            print("no user is signed in")
            
            isUserLogged = false
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
       
        if(isUserLogged){
            
            if let favPlacesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC {
                
                //self.present(favPlacesVC, animated: true, completion: nil)
                self.navigationController?.pushViewController(favPlacesVC, animated: true)
            }
            
        }
        
    }
    
    func logoutCurrentUser() {
        
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            print("user is signed out")
            isUserLogged = false
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    @IBAction func signupUser(_ sender: Any) {
        
    }
    
    @IBAction func loginUser(_ sender: Any) {
        
    }
    
    @IBAction func showDemo(_ sender: Any) {
    }
    
    
    
}
