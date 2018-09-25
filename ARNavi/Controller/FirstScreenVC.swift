//
//  FirstScreenVC.swift
//  ARNavi
//
//  Created by Martin on 9/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

class FirstScreenVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        signupButton.backgroundColor = UIColor.red
        signupButton.tintColor       = UIColor.white
        signupButton.layer.cornerRadius = 7
        loginButton.backgroundColor  = UIColor.gray
        loginButton.tintColor        = UIColor.white
        loginButton.layer.cornerRadius = 7
        
    }
    
    @IBAction func signupUser(_ sender: Any) {
        
    }
    
    @IBAction func loginUser(_ sender: Any) {
        
    }
    
    
}
