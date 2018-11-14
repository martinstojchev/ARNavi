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
import FirebaseDatabase
import SwiftEntryKit
import SwiftSpinner

class SignupVC: UIViewController {

    @IBOutlet weak var nameTextField: DTTextField!
    @IBOutlet weak var usernameTextField: DTTextField!
    @IBOutlet weak var emailTextField: DTTextField!
    @IBOutlet weak var passwordTextField: DTTextField!
    @IBOutlet weak var repeatPassTextField: DTTextField!
    @IBOutlet weak var signupButton: UIButton!
    //@IBOutlet weak var facebookSignupButton: UIButton!
    //@IBOutlet weak var twitterSignupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    var loggedUser: User?
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        self.hideKeyboardWhenTappedAround()
        prepareSignupVC()
        
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
        
        print("username: \(username)")
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
                SwiftSpinner.show("Signing up...", animated: true)
                // signup the user
                Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                    
                    if let err = error {
                         print("creating user failed")
                         print(err.localizedDescription)
                        SwiftSpinner.show(err.localizedDescription, animated: true).addTapHandler({
                            SwiftSpinner.hide()
                        })
                    }
                    else {
                        
                        print("successfully created user")
                        self.loggedUser = User(name: name, username: username, email: email)
                        self.updateUsersName(displayName: name)
                        SwiftSpinner.hide()
                    }
                    
                    
                }
                
            }
            
            
            
            
          }
        }
        
        
    }
    
    func prepareSignupVC() {
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = AppColor.backgroundColor.rawValue
        signupButton.backgroundColor = AppColor.red.rawValue
        signupButton.tintColor = AppColor.white.rawValue
        signupButton.layer.cornerRadius = 7
//        facebookSignupButton.backgroundColor = AppColor.facebookBlue.rawValue
//        facebookSignupButton.tintColor = AppColor.white.rawValue
//        facebookSignupButton.layer.cornerRadius = 7
//        twitterSignupButton.backgroundColor = AppColor.twitterBlue.rawValue
//        twitterSignupButton.tintColor = AppColor.white.rawValue
//        twitterSignupButton.layer.cornerRadius = 7
        infoLabel.textColor = AppColor.gray.rawValue
        loginButton.tintColor = AppColor.white.rawValue
        passwordTextField.addShowPasswordButton(showImage: UIImage(named: "show_icon")!, hideImage: UIImage(named: "hide_icon")!)
        repeatPassTextField.addShowPasswordButton(showImage: UIImage(named: "show_icon")!, hideImage: UIImage(named: "hide_icon")!)
        
    }
    

    func updateUsersName(displayName name: String){

        if let userID  = Auth.auth().currentUser?.uid {
        print("userID: \(userID)")
        
            self.loggedUser?.setUserID(id: userID)
            
           
            if let loggUser = self.loggedUser {
               self.writeUserToDatabase(user: loggUser)
            }
        }
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { (error) in
            
            if let err = error {
                print("error while setting display name for the user")
                print(err.localizedDescription)
                self.showRegisterPopup(title: "Error!", description: err.localizedDescription, image: UIImage(named: "error_icon")!, buttonTitle: "OK", buttonTitleColor: AppColor.white, buttonBackgroundColor: AppColor.black, popupBackgroundColor: AppColor.red, isError: true)
            }
            else {
                print("successfully updated users display name")
                //self.transitionToFavPlaces()
                self.showRegisterPopup(title: "AWESOME!", description: "You have successfully signed up.", image: UIImage(named: "checkmark_icon")!, buttonTitle: "OK", buttonTitleColor: AppColor.white, buttonBackgroundColor: AppColor.black, popupBackgroundColor: AppColor.registerPopupColor, isError: false)
            }
        }
    }
    
    func writeUserToDatabase(user: User) {
        
        guard let userID = self.loggedUser?.getUserID()   else { return }
        guard let userName = self.loggedUser?.getName()   else { return }
        guard let username = self.loggedUser?.getUsername()  else { return }
        guard let userEmail = self.loggedUser?.getEmail() else { return }
        
        print("userID: \(userID), userName: \(userName), username: \(username), userEmail: \(userEmail)")
        
        self.ref.child("users").child(userID).setValue(["name": userName,"username": username,"email": userEmail ])
        
        
        print("User stored to realtime database....")
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
    

    func showRegisterPopup(title: String, description: String, image: UIImage, buttonTitle: String, buttonTitleColor: AppColor, buttonBackgroundColor: AppColor, popupBackgroundColor: AppColor, isError: Bool){
        
        // Generate top floating entry and set some properties
        
        var attributes = EKAttributes()
        
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.9)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.intrinsic
        let entryColor = EKAttributes.BackgroundStyle.color(color: popupBackgroundColor.rawValue)
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
            
            if(!isError){
            
            if let favPlacesVC =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC{
                
                self.navigationController?.pushViewController(favPlacesVC, animated: true)
               }
                
            }
        }
        
        
        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont.boldSystemFont(ofSize: 22), color: AppColor.black.rawValue, alignment: NSTextAlignment.center, numberOfLines: 1))
        
        let description = EKProperty.LabelContent(text: description, style: .init(font: UIFont.boldSystemFont(ofSize: 15), color: UIColor.white, alignment: NSTextAlignment.center, numberOfLines: 0))
        let image = EKProperty.ImageContent(image: image)
        
        
        
        let btnTitle = EKProperty.LabelContent(text: buttonTitle, style: .init(font: .boldSystemFont(ofSize: 20), color: buttonTitleColor.rawValue))
        
        let btnContent = EKProperty.ButtonContent(label: btnTitle, backgroundColor: buttonBackgroundColor.rawValue, highlightedBackgroundColor: popupBackgroundColor.rawValue )
        
        
        
        let themeImage = EKPopUpMessage.ThemeImage(image: image)
        
        
        let popupMessage = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: btnContent) {
            
            SwiftEntryKit.dismiss()
            
            if(!isError){
            
            if let favPlacesVC =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC{
                
                self.navigationController?.pushViewController(favPlacesVC, animated: true)
               }
                
            }
            
        }
        
        let popupMessageView = EKPopUpMessageView(with: popupMessage)
        
        
        SwiftEntryKit.display(entry: popupMessageView, using: attributes)
        
    }

}
