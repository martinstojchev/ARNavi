//
//  LoginVC.swift
//  ARNavi
//
//  Created by Martin on 9/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var biometricImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginbutton: UIButton!
    @IBOutlet weak var twitterLoginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColor.backgroundColor.rawValue
        loginButton.backgroundColor = AppColor.red.rawValue
        loginButton.tintColor = AppColor.white.rawValue
        loginButton.layer.cornerRadius = 7
        facebookLoginbutton.backgroundColor = AppColor.facebookBlue.rawValue
        facebookLoginbutton.tintColor = AppColor.white.rawValue
        facebookLoginbutton.layer.cornerRadius = 7
        twitterLoginButton.backgroundColor = AppColor.twitterBlue.rawValue
        twitterLoginButton.tintColor = AppColor.white.rawValue
        twitterLoginButton.layer.cornerRadius = 7
        signupButton.backgroundColor = AppColor.backgroundColor.rawValue
        signupButton.tintColor = AppColor.white.rawValue
        forgotPasswordButton.tintColor = AppColor.gray.rawValue
        infoLabel.textColor = AppColor.gray.rawValue
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
