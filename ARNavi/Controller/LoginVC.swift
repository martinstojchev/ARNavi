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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.backgroundColor = UIColor.red
        loginButton.tintColor = UIColor.white
        loginButton.layer.cornerRadius = 7
        facebookLoginbutton.backgroundColor = UIColor.blue
        facebookLoginbutton.tintColor = UIColor.white
        facebookLoginbutton.layer.cornerRadius = 7
        twitterLoginButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        twitterLoginButton.tintColor = UIColor.white
        twitterLoginButton.layer.cornerRadius = 7
        signupButton.backgroundColor = UIColor(red: 42, green: 163, blue: 239, alpha: 1)
        forgotPasswordButton.tintColor = UIColor.gray
        
        
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
