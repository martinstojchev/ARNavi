//
//  User.swift
//  ARNavi
//
//  Created by Martin on 10/19/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import CoreLocation

class User {
    
     private var userID        : String?
     private var name          : String
     private var username      : String
     private var email         : String
     private var image         : UIImage?
     private var friends       : [String]?
     private var favLocations  : [CLLocation]?
     private var requests      : [String]?
    
    init(name: String, username: String, email: String) {
        
        self.name     = name
        self.username = username
        self.email    = email
        
    }
    
    init(id userID: String, name: String, username: String, email: String, image: UIImage, friends: [String], favLocations: [CLLocation], requests: [String]) {
        
        self.userID       = userID
        self.name         = name
        self.username     = username
        self.email        = email
        self.image        = image
        self.friends      = friends
        self.favLocations = favLocations
        self.requests     = requests
        
        
    }
    
    
    func getUserID() -> String            {
        if let uID = userID {
            return uID
        }
        else {
            return ""
        }
     }
    
    func getName() -> String               {
        return name
     }
    
    func getUsername() -> String           {
        return username
     }
    
    func getEmail() -> String              {
        return email
     }
    
    func getImage() -> UIImage             {
        
        if let img = image{
            return img
        }
        else {
            return UIImage.init()
        }
     }
    
    func getFriends() -> [String]          {
        
        if let friends = friends {
            return friends
        }
        else {
            return []
        }
        
     }
    
    func getFavLocations() -> [CLLocation] {
        
        if let favLocs = favLocations{
            return favLocs
        }
        else {
            return []
        }
     }
    
    func getRequests() -> [String]         {
        
        if let reqs = requests {
            return reqs
        }
        else {
            return []
        }
     }
    
            func setUserID(id userID: String)                {
                self.userID = userID
                }
    
            func setName(name: String)                       {
                self.name = name
                }
    
            func setUsername(username: String)               {
                self.username = username
                }
    
            func setEmail(email: String)                     {
                self.email = email
                }
    
            func setImage(image: UIImage)                    {
                self.image = image
                }
    
            func setFriends(friends: [String])               {
                self.friends = friends
                }
    
            func setFavLocations(favLocations: [CLLocation]) {
                self.favLocations = favLocations
                }
    
            func setRequests(requests: [String])             {
                self.requests = requests
            }
    
    
    
}
