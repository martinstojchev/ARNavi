//
//  UpdateInfoVC.swift
//  ARNavi
//
//  Created by Martin on 10/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import DTTextField
import Firebase
import FirebaseCore
import FirebaseDatabase
import SwiftEntryKit

class UpdateInfoVC: UIViewController {
    @IBOutlet weak var updateUsernameTxtField: DTTextField!
    
    @IBOutlet weak var updateNameTxtField: DTTextField!
    @IBOutlet weak var changePassTxtField: DTTextField!
    @IBOutlet weak var removeAccButton: UIButton!
    var ref: DatabaseReference!
    
    let user = Auth.auth().currentUser
    var credential: AuthCredential!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        self.hideKeyboardWhenTappedAround()
         prepareUpdateInfoVC()
        //displayReauthenticateForm(title: "Reauthenticate user", buttonTitle: "Login", buttonTitleColor: AppColor.gray, buttonBackgroundColor: AppColor.green, popupBackgroundColor: AppColor.twitterBlue)
        
        
       
    }
    
    func prepareUpdateInfoVC() {
        
        self.navigationItem.title = "Update info"
        view.backgroundColor = AppColor.backgroundColor.rawValue
        updateNameTxtField.placeholder = "Update name"
        updateUsernameTxtField.placeholder = "Update username"
        changePassTxtField.placeholder = "Change password"
        removeAccButton.titleLabel?.text = "Remove Account"
        removeAccButton.backgroundColor = AppColor.red.rawValue
        removeAccButton.tintColor = AppColor.white.rawValue
        removeAccButton.layer.cornerRadius = 10
        updateNameTxtField.addUpdateButton(title: "Update", titleColor: AppColor.white.rawValue, buttonColor: AppColor.green.rawValue)
        updateUsernameTxtField.addUpdateButton(title: "Update", titleColor: AppColor.white.rawValue, buttonColor: AppColor.green.rawValue)
        changePassTxtField.addUpdateButton(title: "Update", titleColor: AppColor.white.rawValue, buttonColor: AppColor.green.rawValue)
    }
    

    @IBAction func removeAccount(_ sender: Any) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      reauthenticateUserForm()
    }
    
    func updateUsersName(name: String) {
        
        ref = Database.database().reference()
        
        print("updateUsersName with name: \(name)")
        
            guard let currentUserID = Auth.auth().currentUser?.uid else { return }
            print("currentUserID: \(currentUserID)")
                 //update the name in database
          ref.child("users/\(currentUserID)/name").setValue(name)
                
                print("updated info for logged user.")
        
         //update the display name for logged user
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
          changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: { (error) in

            if let err = error {

                print("Error: \(err.localizedDescription)")
            }
            else {
                print("Successfully changed displayname for current user")
            }

        })
        
    }
    
    func updateUsersUsername(username: String) {
        ref = Database.database().reference()
        print("updateUsersUsername with username: \(username)")
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        print("currentUserID: \(currentUserID)")
        //update the username in database
        ref.child("users/\(currentUserID)/username").setValue(username)
        
        print("updated info for logged user.")
        
    }
    
    func updateUsersPassword(password: String) {
        
        
        print("updateUsersPassword with password: \(password)")
        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
            
            if let err = error {
                print("error occurred while updating users password")
                print(err.localizedDescription)
            }
            else {
                print("successfully updated users password")
            }
        })
    }
    
    func reauthenticateUserForm(){
        
        let alert = UIAlertController(title: "Reauthenticate", message: "Please fill your credentials", preferredStyle: .alert)
        let action = UIAlertAction(title: "Mail input", style: .default) { (alertAction) in
            
            let emailTextField = alert.textFields![0] as UITextField
            let passTextField = alert.textFields![1] as  UITextField
            
            
            guard let email = emailTextField.text else {return}
            guard let pass  = passTextField.text else { return }
            
            print("email: \(email), pass: \(pass)")
            
            self.credential = EmailAuthProvider.credential(withEmail: email, password: pass)
            
            
            
            //try to log the user
            self.user?.reauthenticateAndRetrieveData(with: self.credential, completion: { (result, error) in
                
                if let err = error {
                    print("error occured while reauthenticating")
                    print(err.localizedDescription)
                    
                }
                else {
                    // user re-authenticated
                    print("user re-authenticated")
                    //SwiftEntryKit.dismiss()
                }
            })
            
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
            
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    #warning("Implement this popup for reauthenticating")
    func displayReauthenticateForm(title: String, buttonTitle: String, buttonTitleColor: AppColor, buttonBackgroundColor: AppColor, popupBackgroundColor: AppColor){
        
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
        attributes.positionConstraints.verticalOffset = self.view.frame.height / 2
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        attributes.entryBackground = entryColor
        attributes.screenBackground = screenBlur
        attributes.position = .center
        attributes.windowLevel = .normal
        
        
        
        
        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont.boldSystemFont(ofSize: 22), color: AppColor.black.rawValue, alignment: NSTextAlignment.center, numberOfLines: 1))
        
        let textFields = FormFieldPresetFactory.fields(by: [.email, .password], style: FormStyle.light)
        
        let btnTitle = EKProperty.LabelContent(text: buttonTitle, style: .init(font: .boldSystemFont(ofSize: 20), color: buttonTitleColor.rawValue))
        
        let btnContent = EKProperty.ButtonContent(label: btnTitle, backgroundColor: buttonBackgroundColor.rawValue, highlightedBackgroundColor: buttonBackgroundColor.rawValue) {
        
            
        }
       
        attributes.entryInteraction.customTapActions = [{
            print("button action")
            
            
            
            let userEmail = textFields[0].textContent
            let userPass  = textFields[1].textContent
            print("userEmail: \(userEmail)")
            print("userPass: \(userPass)")
            if(userEmail == "" || userPass == ""){
                
                return
            }
            else {
                self.credential = EmailAuthProvider.credential(withEmail: userEmail, password: userPass)
                
                
                
                //try to log the user
                self.user?.reauthenticateAndRetrieveData(with: self.credential, completion: { (result, error) in
                    
                    if let err = error {
                        print("error occured while reauthenticating")
                        print(err.localizedDescription)
                        
                    }
                    else {
                        // user re-authenticated
                        print("user re-authenticated")
                        SwiftEntryKit.dismiss()
                    }
                })
                
            }
            
            }]
        
        let formView = EKFormMessageView(with: title, textFieldsContent: textFields, buttonContent: btnContent)
        
        attributes.lifecycleEvents.didAppear = {
          formView.becomeFirstResponder(with: 0)
        }
        
        SwiftEntryKit.display(entry: formView, using: attributes, presentInsideKeyWindow: true)
        
        
        
    }

    

}
