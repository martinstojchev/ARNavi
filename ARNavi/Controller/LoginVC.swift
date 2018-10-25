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
import SwiftEntryKit

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
    var showPasswordButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
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
        
        passwordTextField.addShowPasswordButton(showImage: UIImage(named: "show_icon")!, hideImage: UIImage(named: "hide_icon")!)
        
    }
    
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
                    self.showLoginPopup(title: "Error!", description: err.localizedDescription, image: UIImage(named: "error_icon")!, buttonTitle: "OK", buttonTitleColor: AppColor.white, buttonBackgroundColor: AppColor.black, popupBackgroundColor: AppColor.red, isError: true)
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
                    self.showLoginPopup(title: "Password reset", description: err.localizedDescription, image: UIImage(named: "error_icon")!, buttonTitle: "OK", buttonTitleColor: AppColor.white, buttonBackgroundColor: AppColor.black, popupBackgroundColor: AppColor.red, isError: true)
                }
                else {
                    print("password reset email sent.")
                    self.showLoginPopup(title: "Password reset", description: "Password reset email sent", image: UIImage(named: "mail_icon")!, buttonTitle: "OK", buttonTitleColor: AppColor.white, buttonBackgroundColor: AppColor.black, popupBackgroundColor: AppColor.facebookBlue, isError: true)
                }
            }
            
        }
        else {
            emailTextField.showError(message: "Email is not valid")
        }
        
        
    }
    
    
    func showLoginPopup(title: String, description: String, image: UIImage, buttonTitle: String, buttonTitleColor: AppColor, buttonBackgroundColor: AppColor, popupBackgroundColor: AppColor, isError: Bool){
        
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
