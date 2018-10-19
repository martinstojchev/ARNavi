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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor         = AppColor.backgroundColor.rawValue
        signupButton.backgroundColor = AppColor.red.rawValue
        signupButton.tintColor       = AppColor.white.rawValue
        signupButton.layer.cornerRadius = 7
        loginButton.backgroundColor  = AppColor.gray.rawValue
        loginButton.tintColor        = AppColor.white.rawValue
        loginButton.layer.cornerRadius = 7
        
        // Check for previous logged user
        if Auth.auth().currentUser != nil {
            // User is signed in
            print("User \(Auth.auth().currentUser?.email) is signed in")
        }
        else {
            // No user is signed in
            print("no user is signed in")
        }
        
    }
    
    @IBAction func signupUser(_ sender: Any) {
        
    }
    
    @IBAction func loginUser(_ sender: Any) {
        
    }
    
    @IBAction func showDemo(_ sender: Any) {
    }
    
    
    
}
