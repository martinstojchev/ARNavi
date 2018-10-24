//
//  SideMenuVC.swift
//  ARNavi
//
//  Created by Martin on 10/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var updateInfoButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var requestsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    var usersName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      setupMenuView()
        
    
    }
    
    func setupMenuView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        
        view.backgroundColor = AppColor.backgroundColor.rawValue
        print("usersName: \(usersName)")
        if let name = usersName {
            nameLabel.text = name
            print("name label")
        }
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
