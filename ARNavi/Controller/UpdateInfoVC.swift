//
//  UpdateInfoVC.swift
//  ARNavi
//
//  Created by Martin on 10/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import DTTextField

class UpdateInfoVC: UIViewController {
    @IBOutlet weak var updateUsernameTxtField: DTTextField!
    
    @IBOutlet weak var updateNameTxtField: DTTextField!
    @IBOutlet weak var changePassTxtField: DTTextField!
    @IBOutlet weak var removeAccButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
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
    
    func updateUsersName(name: String) {
        
        
    }
    
    func updateUsersUsername(username: String) {
        
    }
    
    func updateUsersPassword(password: String) {
        
    }
    

}
