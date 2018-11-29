//
//  ShowFriendVC.swift
//  ARNavi
//
//  Created by Martin on 11/29/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftSpinner
import Firebase
import FirebaseDatabase

class ShowFriendVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var showNameLabel: UILabel!
    
    @IBOutlet weak var showEmailLabel: UILabel!
    @IBOutlet weak var shareCurrenLocationButton: UIButton!
    
    var showingFriend: Friend!
    var isFriend: Bool!
    let locationManager = CLLocationManager()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let friend = showingFriend {
            //showImageView.image = friend.getImage()
            showNameLabel.text  = friend.getName()
            showEmailLabel.text = friend.getEmail()
        }
        
        view.backgroundColor = AppColor.backgroundColor.rawValue
        showImageView.layer.borderColor = AppColor.black.rawValue.cgColor
        showImageView.layer.borderWidth = 1
        showImageView.layer.cornerRadius = showImageView.frame.width / 2
        
        if isFriend {
            shareCurrenLocationButton.isHidden = false
        shareCurrenLocationButton.tintColor = AppColor.white.rawValue
        }
        else {
            shareCurrenLocationButton.isHidden = true
        }
    }
    
    @IBAction func shareCurrenLocation(_ sender: Any) {
        
        //Start location services
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        checkLocationServices()
        
    }
    
    func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            //setup our location manager
            
            checkLocationAuthorization()
            
            
            
        }
        else {
            // Show alert letting the user know they have to turn this on.
        }
        
        
    }
    
    func checkLocationAuthorization(){
        
        switch CLLocationManager.authorizationStatus(){
            
        case .authorizedWhenInUse:
            
            
            //centerViewOnUserLocation()
            print("authorization when in use")
            locationManager.requestLocation()
            SwiftSpinner.show("Getting your current location", animated: true)
            //print("userLocation in setupLocation manager: \(userLocation)")
            
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
            
            
        }
        
    }
    
    //Mark: - CLLocationManager
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Implementing this method is required
        print(error.localizedDescription)
    }
    

    
    //Once the user's location is received, take the last element of the array, update the status, and connect to Pusher
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            print("user's current locaiton: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            sendCurrentLocationToFriend(friend: showingFriend, currentLocation: location)
        }
    }
    
    
    func sendCurrentLocationToFriend(friend: Friend, currentLocation: CLLocation ){
       
        let friendName = friend.getName()
        let friendID   = friend.getUserID()
        guard let currentUserName = Auth.auth().currentUser?.displayName else {return}
        guard let currentUserID   = Auth.auth().currentUser?.uid else {return}
        
        
        SwiftSpinner.show("Sending your location to \(friendName)...", animated: true)
        
        ref = Database.database().reference()
        
       
            
            let placeName = currentUserName.appending("'s current position")
            let placeCoordinate = currentLocation
            let placeLatitudeString = String(placeCoordinate.coordinate.latitude)
            let placeLongitudeString = String(placeCoordinate.coordinate.longitude)
            
            print("Place for sharing: place: \(placeName) with lat: \(placeLatitudeString) and lon: \(placeLongitudeString)")
            
        
            
            print("Current user name: \(currentUserName)")
        
            ref.child("users").child(friendID).child("places").child(placeName).updateChildValues(["lat" : placeLatitudeString])
            ref.child("users").child(friendID).child("places").child(placeName).updateChildValues(["lon" : placeLongitudeString])
            
         SwiftSpinner.show("Done..!", animated: true)
         SwiftSpinner.hide()
        
        
        
    }

}
