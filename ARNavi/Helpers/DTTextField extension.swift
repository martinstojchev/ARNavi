//
//  DTTextField extension.swift
//  ARNavi
//
//  Created by Martin on 10/22/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import DTTextField

extension DTTextField {
    
    
    func addShowPasswordButton(showImage sImage: UIImage, hideImage hImage:UIImage){
        
        self.rightViewMode = .whileEditing
        
        
        let showButton  = UIButton(type: .system)
        showButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: (self.frame.height - 10))
        showButton.setImage(sImage, for: .normal)
        //showButton.titleLabel?.textColor = UIColor.red
        showButton.layer.borderColor = self.borderColor.cgColor
        showButton.layer.borderWidth = 1
        showButton.addTarget(self, action: #selector(showButtonAction), for: .touchDown)
        
        
        self.rightView = showButton
        
    }
    
    
    
    @objc func showButtonAction(){
        
        if(self.isSecureTextEntry){
            
            self.isSecureTextEntry = !self.isSecureTextEntry
            let rightButton = self.rightView as! UIButton
            rightButton.setImage(UIImage(named: "hide_icon"), for: .normal)
            self.rightView = rightButton
            
        }
        else {
            self.isSecureTextEntry = !self.isSecureTextEntry
            let rightButton = self.rightView as! UIButton
            rightButton.setImage(UIImage(named: "show_icon"), for: .normal)
            self.rightView = rightButton
        }
        
    }
    
    func addUpdateButton(title: String, titleColor: UIColor, buttonColor: UIColor){
        
        self.rightViewMode = .whileEditing
        
        let updateButton  = UIButton(type: .system)
        updateButton.frame = CGRect.init(x: 0, y: 0, width: 70 , height: (self.frame.height - 5))
        //updateButton.layer.borderColor = self.borderColor.cgColor
        updateButton.backgroundColor = buttonColor
        updateButton.setTitle(title, for: .normal)
        updateButton.tintColor = titleColor
        //updateButton.layer.borderWidth = 1
        updateButton.addTarget(self, action: #selector(updateInfo), for: .touchDown)
        
        self.rightView = updateButton
        
        
    }
    
    @objc func updateInfo(){
        
        guard let fieldPlaceholder = self.placeholder else { return }
        print("placeholder: ",fieldPlaceholder)
        
        
    }
    
    
    
}

