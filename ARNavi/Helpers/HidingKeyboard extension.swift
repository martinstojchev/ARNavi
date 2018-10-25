//
//  HidingKeyboard extension.swift
//  ARNavi
//
//  Created by Martin on 10/25/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}
