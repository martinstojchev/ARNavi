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
import SwiftEntryKit

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
        passwordTextField.addShowPasswordButton(showImage: UIImage(named: "show_icon")!, hideImage: UIImage(named: "hide_icon")!)
        repeatPassTextField.addShowPasswordButton(showImage: UIImage(named: "show_icon")!, hideImage: UIImage(named: "hide_icon")!)
        
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
                        //print("current User after sign up: \(Auth.auth().currentUser?.email)")
                        self.updateUsersName(displayName: name)
                    }
                    
                    
                }
                
            }
            
            
            
            
          }
        }
        
        
    }
    

    func updateUsersName(displayName name: String){

        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { (error) in
            
            if let err = error {
                print("error while setting display name for the user")
                print(err.localizedDescription)
            }
            else {
                print("successfully updated users display name")
                //self.transitionToFavPlaces()
                self.showRegisterPopup()
            }
        }
    }
    
    func transitionToFavPlaces() {
        
        if let favPlacesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC {
            navigationController?.pushViewController(favPlacesVC, animated: true)
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
    

    func showRegisterPopup(){
        
        // Generate top floating entry and set some properties
        
        var attributes = EKAttributes()
        
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.9)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.intrinsic
        let entryColor = EKAttributes.BackgroundStyle.color(color: AppColor.registerPopupColor.rawValue)
        let screenBlur = EKAttributes.BackgroundStyle.visualEffect(style: UIBlurEffect.Style.dark)
        
        attributes.border = .value(color: AppColor.black.rawValue, width: 1)
        attributes.roundCorners = .all(radius: 20)
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
        attributes.positionConstraints.verticalOffset = 20
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        attributes.entryBackground = entryColor
        attributes.screenBackground = screenBlur
        attributes.position = .bottom
        attributes.windowLevel = .alerts
        
        attributes.lifecycleEvents.willDisappear = {
            
            if let favPlacesVC =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC{
                
                self.navigationController?.pushViewController(favPlacesVC, animated: true)
            }
        }
        
        
        let title = EKProperty.LabelContent(text: "AWESOME!", style: .init(font: UIFont.boldSystemFont(ofSize: 22), color: AppColor.black.rawValue, alignment: NSTextAlignment.center, numberOfLines: 1))
        
        let description = EKProperty.LabelContent(text: "You have successfully signed up.", style: .init(font: UIFont.boldSystemFont(ofSize: 15), color: UIColor.white, alignment: NSTextAlignment.center, numberOfLines: 0))
        let image = EKProperty.ImageContent(image: UIImage(named: "checkmark_icon")!)
        
        
        
        let btnTitle = EKProperty.LabelContent(text: "OK", style: .init(font: .boldSystemFont(ofSize: 20), color: AppColor.white.rawValue))
        
        let btnContent = EKProperty.ButtonContent(label: btnTitle, backgroundColor: AppColor.black.rawValue, highlightedBackgroundColor: AppColor.registerPopupColor.rawValue )
        
        
        
        let themeImage = EKPopUpMessage.ThemeImage(image: image)
        
        
        let popupMessage = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: btnContent) {
            
            SwiftEntryKit.dismiss()
            
            if let favPlacesVC =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC{
                
                self.navigationController?.pushViewController(favPlacesVC, animated: true)
            }
            
        }
        
        let popupMessageView = EKPopUpMessageView(with: popupMessage)
        
        SwiftEntryKit.display(entry: popupMessageView, using: attributes)
        
    }

}
