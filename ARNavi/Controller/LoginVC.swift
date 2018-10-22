//
//  LoginVC.swift
//  ARNavi
//
//  Created by Martin on 9/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import DTTextField
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: DTTextField!
    @IBOutlet weak var passwordTextField: DTTextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var biometricImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginbutton: UIButton!
    @IBOutlet weak var twitterLoginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        
        emailTextField.placeholderColor = AppColor.gray.rawValue
        passwordTextField.placeholderColor = AppColor.gray.rawValue
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func loginUser(_ sender: Any) {
        
        if emailTextField.text == "" {
            emailTextField.showError(message: "Insert email")
            return
        }
        
        if passwordTextField.text == "" {
            passwordTextField.showError(message: "Insert password")
            return
        }
        
        guard let email    = emailTextField.text    else { return }
        guard let password = passwordTextField.text else { return }

        let emailValid = isValidEmail(email: email)
        
        if (emailValid){
            //email is valid, try to log in the user
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if let err = error {
                    print("Error with logging user")
                    print(err.localizedDescription)
                }
                else {
                    print("user successfully logged in")
                     //Show fav places vc
                    if let favPlacesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC {
                       
                        //self.present(favPlacesVC, animated: true, completion: nil)
                        self.navigationController?.pushViewController(favPlacesVC, animated: true)
                    }
                }
                
            }
            
        }
        else {
            //email style is not ok, show an error
            
            emailTextField.showError(message: "Email is not valid")
            return
        }
        
        
    }
    
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    
    @IBAction func forgotPassword(_ sender: Any) {
        
        if emailTextField.text == "" {
            emailTextField.showError(message: "Insert email")
            return
        }
        
        guard let email    = emailTextField.text    else { return }
        
        let emailValid = isValidEmail(email: email)
        
        if (emailValid){
            // send the reset password link to the inserted email
            
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                
                if let err = error {
                    print(err.localizedDescription)
                }
                else {
                    print("password reset email sent.")
                }
            }
            
        }
        else {
            emailTextField.showError(message: "Email is not valid")
        }
        
        
    }
    
    
    

}
