//
//  Friend.swift
//  ARNavi
//
//  Created by Martin on 11/7/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import Foundation
import UIKit

class Friend {
   
    private var userID        : String
    private var name          : String
    private var username      : String
    private var email         : String
    private var image         : UIImage?
    
    
    init(userID: String, name: String, username: String, email: String, image: UIImage) {
        
        self.userID   = userID
        self.name     = name
        self.username = username
        self.email    = email
        self.image    = image
    }
    
    func getUserID() -> String {
        return self.userID
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getUsername() -> String {
        return self.username
    }
    
    func getEmail() -> String {
        return self.email
    }
    
    func getImage() -> UIImage {
        if let img = image {
            return img
        }
        
        return UIImage()
    }
    

    
}
