//
//  SideMenuVC.swift
//  ARNavi
//
//  Created by Martin on 10/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import Photos

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var updateInfoButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var requestsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var currentUserName: String?
    let imagePicker = UIImagePickerController()
    var currenProfilePicture = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      setupMenuView()
       
        
    
    }
    
    func setupMenuView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        
        view.backgroundColor = AppColor.backgroundColor.rawValue
     
        nameLabel.text = currentUserName
        profileImageView.image = currenProfilePicture
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        
        nameLabel.textColor              = AppColor.white.rawValue
        updateInfoButton.tintColor       = AppColor.black.rawValue
        friendsButton.tintColor          = AppColor.black.rawValue
        requestsButton.tintColor         = AppColor.black.rawValue
        settingsButton.tintColor         = AppColor.black.rawValue
        logoutButton.tintColor           = AppColor.white.rawValue
        logoutButton.backgroundColor     = AppColor.red.rawValue
        
    
    }
    

    func logoutCurrentUser() {
        
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            print("user is signed out")
            //isUserLogged = false
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    
    @IBAction func logoutUser(_ sender: Any) {
        
        logoutCurrentUser()
        transitionToFirstScreen()
    }
    
    func transitionToFirstScreen() {
        
        if let firstScreenVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstScreenVC") as? FirstScreenVC {
            navigationController?.pushViewController(firstScreenVC, animated: true)
        }
    }
    
    
    @IBAction func updateInfo(_ sender: Any) {
        
        transitionTo(viewControllerIdentifier: "UpdateInfoVC")
        
    }
    
    func transitionTo(viewControllerIdentifier: String) {
        
        
    if let destinationVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewControllerIdentifier) as? UIViewController {
        
        navigationController?.pushViewController(destinationVC, animated: true)
         }
        
    }
    
    
    @IBAction func friendsAction(_ sender: Any) {
        transitionTo(viewControllerIdentifier: "FriendsVC")
    }
    
    @IBAction func requestsAction(_ sender: Any) {
        transitionTo(viewControllerIdentifier: "RequestsVC")
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        transitionTo(viewControllerIdentifier: "SettingsVC")
    }
    
    
    @IBAction func chooseProfileImage(_ sender: Any) {

        checkPhotoLibraryPermissions()
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        //present(imagePicker,animated: true, completion: nil)
        
        present(alert, animated: true, completion: nil)
    }
    
    func checkPhotoLibraryPermissions(){
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
            
        case .authorized:     print("Access is granted by user")
        case .notDetermined:  PHPhotoLibrary.requestAuthorization { (newStatus) in
            print("status is: \(newStatus)")
            if newStatus == PHAuthorizationStatus.authorized {
                // implement func..
                print("notDetermined -> authorized")
            }
            
          }
        case .restricted:     print("User do not have access to photo album")
            
        case .denied:         print("User has denied the permission.")
                              dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    //UIImagePicker delegate methods



}

extension SideMenuVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImg: UIImage!
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.profileImageView.image = editedImage
            self.currenProfilePicture = editedImage
            selectedImg = editedImage
            
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true) {
            
            if let favPlacesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC {
                favPlacesVC.selectedCustomImage = self.currenProfilePicture
                print("selected image transfered")
                #warning("Improve tranfsering the selected photo, not with pushing again the favPlacesVC..")
                self.navigationController?.popViewController(animated: false)
                self.navigationController?.pushViewController(favPlacesVC, animated: true)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            // using segue.destination.children.first because the destination is SideMenu navigation controller
        if segue.destination is FavPlacesVC {
                //set the user's name
               // sideMenuVC.currenProfilePicture = self.currenProfilePicture
                
                print("prepare for segue")
                //print("user email: \(user), name: \(name)")
            }
    }
    
   
    
    
}
