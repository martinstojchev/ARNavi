//
//  User.swift
//  ARNavi
//
//  Created by Martin on 10/19/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

class User {
    
     private var name     : String
     private var username : String
     private var email    : String
     private var password : String
    
    init(name: String, username: String, email: String, password: String) {
        
        self.name     = name
        self.username = username
        self.email    = email
        self.password = password
        
    }
    
    
    func getName() -> String {
        return name
    }
    
    func getUsername() -> String {
        return username
    }
    
    func getEmail() -> String {
        return email
    }
    
    func getPassword() -> String {
        return password
    }
    
}
