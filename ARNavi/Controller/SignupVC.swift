//
//  SignupVC.swift
//  ARNavi
//
//  Created by Martin on 9/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPassTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var facebookSignupButton: UIButton!
    @IBOutlet weak var twitterSignupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColor.backgroundColor.rawValue
        signupButton.backgroundColor = AppColor.red.rawValue
        signupButton.tintColor = AppColor.white.rawValue
        signupButton.layer.cornerRadius = 7
        facebookSignupButton.backgroundColor = AppColor.facebookBlue.rawValue
        facebookSignupButton.tintColor = AppColor.white.rawValue
        facebookSignupButton.layer.cornerRadius = 7
        twitterSignupButton.backgroundColor = AppColor.twitterBlue.rawValue
        twitterSignupButton.tintColor = AppColor.white.rawValue
        twitterSignupButton.layer.cornerRadius = 7
        infoLabel.textColor = AppColor.gray.rawValue
        loginButton.tintColor = AppColor.white.rawValue
        
        
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
