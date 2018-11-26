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
import FirebaseDatabase
import SwiftEntryKit
import LocalAuthentication
import SwiftSpinner
import TwitterKit
import GoogleSignIn

enum BiometricType {
    case none
    case touchID
    case faceID
}


class LoginVC: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: DTTextField!
    @IBOutlet weak var passwordTextField: DTTextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var biometricImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var twitterLoginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    var showPasswordButton: UIButton!
    var ref: DatabaseReference!
    var keychainUser: String!

    var biometricType: BiometricType {
        get {
            let context = LAContext()
            var error: NSError?
            
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
                print(error?.localizedDescription ?? "")
                return .none
            }
            
            if #available(iOS 11.0, *) {
                switch context.biometryType {
                case .none:
                    return .none
                case .touchID:
                    return .touchID
                case .faceID:
                    return .faceID
                }
            } else {
                return  .touchID
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        ref = Database.database().reference()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        print("biometrics: \(biometricType)")
        if(biometricType == .touchID){
          biometricImageView.image = UIImage(named: "touchid_logo")
            
        }
        else if (biometricType == .faceID){
          biometricImageView.image = UIImage(named: "faceid_logo")
        }
        else if (biometricType == .none){
          biometricImageView.isHidden = true
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = AppColor.backgroundColor.rawValue
        loginButton.backgroundColor = AppColor.red.rawValue
        loginButton.tintColor = AppColor.white.rawValue
        loginButton.layer.cornerRadius = 7
        googleLoginButton.backgroundColor = AppColor.googleGreen.rawValue
        googleLoginButton.tintColor = AppColor.white.rawValue
        googleLoginButton.layer.cornerRadius = 7
        googleLoginButton.addTarget(self, action: #selector(googleSignin), for: .touchUpInside)
        twitterLoginButton.backgroundColor = AppColor.twitterBlue.rawValue
        twitterLoginButton.tintColor = AppColor.white.rawValue
        twitterLoginButton.layer.cornerRadius = 7
        signupButton.backgroundColor = AppColor.backgroundColor.rawValue
        signupButton.tintColor = AppColor.white.rawValue
        forgotPasswordButton.tintColor = AppColor.gray.rawValue
        infoLabel.textColor = AppColor.gray.rawValue
        let biometricsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(biometricLoginAction))
        biometricImageView.isUserInteractionEnabled = true
        biometricImageView.addGestureRecognizer(biometricsTapGestureRecognizer)
        
        
        
        emailTextField.placeholderColor = AppColor.gray.rawValue
        passwordTextField.placeholderColor = AppColor.gray.rawValue
        
        passwordTextField.addShowPasswordButton(showImage: UIImage(named: "show_icon")!, hideImage: UIImage(named: "hide_icon")!)
        
    }
    
    @objc func googleSignin(){
        print("google signin tapped")
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func biometricLoginAction(){
      authenticateUserUsingBiometrics()
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
        
        loginUserWithCredentials(email: email, password: password)

    }
    
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    #warning("this method returning always false")
    func checkForExistingUserInDatabase(userID: String) -> Bool{
        var existingUser:Bool = false
        
        DispatchQueue.global(qos: .userInitiated).async {
            
        let group = DispatchGroup()
         group.enter()
        
        self.ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            print("username for existing user: \(username)")
            existingUser = true
            
        }) { (error) in
            
            existingUser = false
            print("error: \(error.localizedDescription)")
            
            
        }
        
        group.leave()
        
        group.wait()
            
        }
        return existingUser
    }
    
    func loginUserWithCredentials(email: String?, password: String?) {
     
                guard let email    = email    else { return }
                guard let password = password else { return }
        
                let emailValid = isValidEmail(email: email)
        
                if (emailValid){
                    //email is valid, try to log in the user
                    SwiftSpinner.show("Logging in...", animated: true)
        
                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
        
                        if let err = error {
                            SwiftSpinner.hide()
                            print("Error with logging user")
                            print(err.localizedDescription)
                            self.showLoginPopup(title: "Error!", description: err.localizedDescription, image: UIImage(named: "error_icon")!, buttonTitle: "OK", buttonTitleColor: AppColor.white, buttonBackgroundColor: AppColor.black, popupBackgroundColor: AppColor.red, isError: true)
                        }
                        else {
                            
                            print("user successfully logged in")
                            DispatchQueue.main.async {
                                self.updateDatabaseForUser()
                            }
        
        
                            if self.keychainUser.elementsEqual("No keychain user"){
                                SwiftSpinner.hide()
                                self.askUserForBiometricalLogin(email: email, password: password)
                            }
                            else{
        
                             //Show fav places vc
                            if let favPlacesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC {
        
                                //self.present(favPlacesVC, animated: true, completion: nil)
                                SwiftSpinner.hide()
                                self.performSegue(withIdentifier: "loginToFavSegue", sender: nil)
                              }
                                
                            else {
                                SwiftSpinner.hide()
                                }
                                
                                
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
    
    
    func updateDatabaseForUser(){
        
        print("updateDatabaseForUser")
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        print("currentUserID: \(currentUserID)")
        let existingUser = checkForExistingUserInDatabase(userID: currentUserID)
        
        print("existingUser: \(existingUser)")
        
        if (existingUser){
            print("existing user")
        }
        else {
            print("user has no data in the database.")
            
            guard let name = Auth.auth().currentUser?.displayName else { return }
            guard let email = Auth.auth().currentUser?.email      else { return }
            
            self.ref.child("users").child(currentUserID).updateChildValues(["name" : name, "email" : email])
            
            print("updated info for logged user.")
        }
        
        
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToFavSegue" {
            if let favPlacesVC = segue.destination as? FavPlacesVC {
                favPlacesVC.checkChangesForProfilePic = true
                print("checkChangesForProfilePic = true")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
         let lastAccessedUserName = UserDefaults.standard.object(forKey: "lastAccessedUserName") as? String
        
        
        if (lastAccessedUserName == nil){
            print("no stored user in the keychain")
            keychainUser = "No keychain user"
            
        }
         else {
            print("lastAccessedUserName: \(lastAccessedUserName!)")
            keychainUser = lastAccessedUserName!
            print("keychainUser: \(keychainUser!)")
            if (biometricType != .none){
              authenticateUserUsingBiometrics()
            }
        }
    }
    
    func askUserForBiometricalLogin(email: String, password: String){
        
        
        
        if keychainUser.elementsEqual("No keychain user") {
            //ask the user if wants to setup biometrical login
            
            let alertController = UIAlertController(title: "Biometrical login", message: "This application has feature to login to your app with your biometric. Do you want to use it?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (cancelAction) in
                
                print("do not save to keychain")
                //Show fav places vc
                if let favPlacesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC {
                    
                    //self.present(favPlacesVC, animated: true, completion: nil)
                    self.performSegue(withIdentifier: "loginToFavSegue", sender: nil)
                }
                
                
            }))
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (yesAction) in
                
                
                self.saveAccountDetailsToKeychain(account: email, password: password)
                //Show fav places vc
                if let favPlacesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC {
                    
                    //self.present(favPlacesVC, animated: true, completion: nil)
                    self.performSegue(withIdentifier: "loginToFavSegue", sender: nil)
                }
                
            }))
            
            
            
            present(alertController, animated: true)
            
        }
        
    }
    
//    fileprivate func configureTwitterSignInButton() {
//        let twitterSignInButton = TWTRLogInButton(logInCompletion: { session, error in
//            if (error != nil) {
//                print("Twitter authentication failed")
//            } else {
//                guard let token = session?.authToken else {return}
//                guard let secret = session?.authTokenSecret else {return}
//                let credential = TwitterAuthProvider.credential(withToken: token, secret: secret)
//                Auth.auth().signIn(with: credential, completion: { (user, error) in
//                    if error == nil {
//                        print("Twitter authentication succeed")
//                    } else {
//                        print("Twitter authentication failed")
//                    }
//                })
//            }
//        })
//
//        twitterSignInButton.frame = CGRect(x: twitterLoginButton.frame.maxX + 20, y: twitterLoginButton.frame.maxY + 20, width: twitterLoginButton.frame.width, height: twitterLoginButton.frame.height)
//         self.view.addSubview(twitterSignInButton)
//
//    }
    
    // Biometrical login methods
    
    fileprivate func saveAccountDetailsToKeychain(account: String, password: String) {
        
        if (account != "" && password != ""){
        
        print("saveAccountDetails called")
        UserDefaults.standard.set(account, forKey: "lastAccessedUserName")
        print("user defaults set")
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: account, accessGroup: KeychainConfiguration.accessGroup)
        do {
            try passwordItem.savePassword(password)
        } catch {
            print("Error saving password")
        }
        
        }
        
    }
    
     fileprivate func authenticateUserUsingBiometrics() {
        let context = LAContext()
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) {
            self.evaulateTocuhIdAuthenticity(context: context)
        }
    }
    
    func evaulateTocuhIdAuthenticity(context: LAContext) {
        guard let lastAccessedUserName = UserDefaults.standard.object(forKey: "lastAccessedUserName") as? String else { return }
        print("evaluateBiometrical username: \(lastAccessedUserName)")
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: lastAccessedUserName) { (authSuccessful, authError) in
            if authSuccessful {
                self.loadPasswordFromKeychainAndAuthenticateUser(lastAccessedUserName)
            } else {
                
                if let error = authError as? NSError {
                    print("error evaluating biometrics")
                    self.showError(error: error.code)
                }
            }
        }
    }
    
    func showError(error: Int) {
        
        print("show Error: \(error)")
        var message: String = ""
        switch error {
        case LAError.authenticationFailed.rawValue:
            message = "Authentication was not successful because the user failed to provide valid credentials. Please enter password to login."
            break
        case LAError.userCancel.rawValue:
            message = "Authentication was canceled by the user"
            break
        case LAError.userFallback.rawValue:
            message = "Authentication was canceled because the user tapped the fallback button"
            break
        case LAError.biometryNotEnrolled.rawValue:
            message = "Authentication could not start because Biometric security is not enrolled ."
            break
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device."
            break
        case LAError.systemCancel.rawValue:
            message = "Authentication was canceled by system"
            break
        default:
            message = "Did not find error on LAError object"
            break
        }
         //show error message
        let errorAlert = UIAlertController(title: "Biometrical error", message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(errorAlert, animated: true)
        //self.showPopupWithMessage(message)
    }
    
    fileprivate func loadPasswordFromKeychainAndAuthenticateUser(_ account: String) {
        guard !account.isEmpty else { return }
        
        let passwordItem = KeychainPasswordItem(service:   KeychainConfiguration.serviceName, account: account, accessGroup: KeychainConfiguration.accessGroup)
        do {
            let storedPassword = try passwordItem.readPassword()
             //authenticateUser(storedPassword)
             loginUserWithCredentials(email: account, password: storedPassword)
             // login the user with mail and passowrd
        } catch KeychainPasswordItem.KeychainError.noPassword {
            print("No saved password")
        } catch {
            print("Unhandled error")
        }
    }
    
    //Twitter login action
    
    @IBAction func twitterLoginAction(_ sender: Any) {
        
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            
        
            
            if let session = session {
                let authToken = session.authToken
                let authTokenSecret = session.authTokenSecret
                print("session: \(session)")
                
                
                
                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                
                Auth.auth().signInAndRetrieveData(with: credential, completion: { (authResult, error) in
                    
                    if let err = error {
                        
                        print("firebase error sign in and retreive data")
                        print(err.localizedDescription)
                    }
                    else {
                        
                        let alertController = UIAlertController(title: "Input email address", message: "Please input your email address to use this application. Login with Twitter does not provide us your email address.", preferredStyle: .alert)
                        
                        
                        
                        let okAction = UIAlertAction(title: "Add", style: .default, handler: { (action) in
                            
                            let emailTextField = alertController.textFields![0] as UITextField
                            
                            guard let email = emailTextField.text else {return}
                            
                            guard let twitterUserID = Auth.auth().currentUser?.uid else {return}
                            
                            guard let userName = Auth.auth().currentUser?.displayName else { return }
                            
                            print("twitter user id: \(twitterUserID)")
                            print("twitter email address: \(email)")
                            
                            self.writeUserToDatabase(userID: twitterUserID, userName: userName, email: email)
                            self.updateUsersEmail(email: email)
                            
                            
                        })
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                            
                        })
                            
                            alertController.addAction(okAction)
                            alertController.addAction(cancelAction)
                        alertController.addTextField(configurationHandler: { (textField) in
                            textField.placeholder = "Your email"
                        })
                        
                        self.present(alertController, animated: true)
                            
                        
                        print("user is signed in on firebase")
                    }
                })
                
            }
            else if let err = error {
                print("error twitter login: \(err.localizedDescription)")
            }
        
            
        }
            
       
    }
    
    func updateUsersEmail(email : String){
        
            
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            
            if let err = error {
                print("error while chainging mail address for twitter user")
                print(err.localizedDescription)
            }
            else {
                print("successfully changed email address for twitter user")
            }
        })
        
        
        
    }
    
    func writeUserToDatabase(userID: String,userName: String, email: String) {
        
       
        print("userID: \(userID), userName: \(userName),, userEmail: \(email)")
        
        self.ref.child("users").child(userID).setValue(["name": userName,"email": email])
        
        transitionToFavPlaces()
        print("User stored to realtime database....")
    }
    
    func transitionToFavPlaces() {
        
        if let favPlacesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC {
            navigationController?.pushViewController(favPlacesVC, animated: true)
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
                    
                    self.performSegue(withIdentifier: "loginToFavSegue", sender: nil)
                }
                
            }
            
        }
        
        let popupMessageView = EKPopUpMessageView(with: popupMessage)
        
        SwiftEntryKit.display(entry: popupMessageView, using: attributes)
        
    }

}
