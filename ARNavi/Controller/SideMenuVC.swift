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

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var updateInfoButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var requestsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    var currentUserName: String?
    
    
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
        let profileImage = UIImage(named: "profile_pic")
        profileImageView.image = profileImage
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
    

}
