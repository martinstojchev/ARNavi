//
//  SignupVC.swift
//  ARNavi
//
//  Created by Martin on 9/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import DTTextField
import Firebase

class SignupVC: UIViewController {

    @IBOutlet weak var nameTextField: DTTextField!
    @IBOutlet weak var usernameTextField: DTTextField!
    @IBOutlet weak var emailTextField: DTTextField!
    @IBOutlet weak var passwordTextField: DTTextField!
    @IBOutlet weak var repeatPassTextField: DTTextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var facebookSignupButton: UIButton!
    @IBOutlet weak var twitterSignupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    
    @IBAction func signupUser(_ sender: Any) {
        print("signupUser clicked")
        
        if nameTextField.text == "" {
            nameTextField.showError(message: "Name can not be empty")
            return
        }
        
        if usernameTextField.text == ""{
            usernameTextField.showError(message: "Username can not be empty")
            return
        }
        
        if emailTextField.text == ""{
            emailTextField.showError(message: "Email can not be empty")
            return
        }
        
        if passwordTextField.text == ""{
            passwordTextField.showError(message: "Password can not be empty")
            return
        }
        if repeatPassTextField.text == ""{
            repeatPassTextField.showError(message: "Password can not be empty")
            return
        }
        
        
        guard let name            = nameTextField.text              else { return }
        guard let username        = usernameTextField.text          else { return }
        guard let email           = emailTextField.text             else { return }
        guard let password        = passwordTextField.text          else { return }
        guard let confirmPassword = repeatPassTextField.text        else { return }
        
        print("name name")
        
        let checkEmail = isValidEmail(email: email)
        
        if (!checkEmail){
            emailTextField.showError(message: "Email is not valid")
        }
        else {
        let stylePass = checkPasswordStyle(password: password)
        
        if (!stylePass){
         passwordTextField.showError(message: "Password must be longer than 6 chars")
        }
        else {
         let equalsPass = checkEqualsPasswords(password: password, repeatPassword: confirmPassword)
            
            if (!equalsPass){
              //password and repeat password are not equal
                repeatPassTextField.showError(message: "Passwords are diffrent")
                
            }
            else {
                // signup the user
                Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                    
                    if let err = error {
                         print("creating user failed")
                         print(err.localizedDescription)
                    }
                    else {
                        
                        print("successfully created user")
                    }
                    
                    
                }
                
            }
            
            
            
            
          }
        }
        
        
    }
    
    func checkEqualsPasswords(password: String, repeatPassword: String) -> Bool {
        
        return password == repeatPassword
        
    }
    
    func checkPasswordStyle(password: String) -> Bool {
    
         return password.count > 6
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
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
