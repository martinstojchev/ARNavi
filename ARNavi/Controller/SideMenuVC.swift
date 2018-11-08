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
import FirebaseFirestore
import FirebaseStorage

protocol ProfilePictureDelegate: class {
    
    func changePickedProfilePicture(image: UIImage?)
    
}

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
    var currentProfilePicture: UIImage!
    weak var pictureDelegate: ProfilePictureDelegate?
    var ref: DatabaseReference!
    let storage = Storage.storage()
    var storageRef: StorageReference!
    var isProfileImgSet = false
    var checkImageChanges = false
    var userFriends:[Friend] = [Friend]()
    var quickAction:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        storageRef = storage.reference()
        setupMenuView()
        if(checkImageChanges){
          checkChangedProfilePicture()
        }else {
        setProfileImage()
        }
        
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(quickAction == "Add user"){
            
            self.transitionTo(viewControllerIdentifier: "FriendsVC")
            quickAction = ""
        }
    }
    
    func setupMenuView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        
        
        
        view.backgroundColor = AppColor.backgroundColor.rawValue
     
        nameLabel.text = currentUserName
        profileImageView.image = currentProfilePicture
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
      
        if viewControllerIdentifier == "FriendsVC"{
            if let friendsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendsVC") as? FriendsVC {
                friendsVC.friends = userFriends
                navigationController?.pushViewController(friendsVC, animated: true)
                return
            }
        }
        
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
    
    func saveImageToCloud(image: UIImage){
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        var imageDownloadURL: String!
        let imageName = currentUserID.appending(".jpg")
        let imagesRef = storageRef.child(imageName)
        
        guard let uploadData = image.jpegData(compressionQuality: 1.0) else {return}

        imagesRef.putData(uploadData, metadata: nil) { (metaData, error) in
            
            if let err = error {
             print(err.localizedDescription)
            }
            else {
              print("successfull uploaded image to cloud")
                print(metaData)
                imagesRef.downloadURL(completion: { (url, error) in
                    if let err = error {
                        print("error while getting the download url for the image")
                        print(err.localizedDescription)
                     }
                    else {
                        guard let downloadURL = url else {return }
                        imageDownloadURL = downloadURL.absoluteString
                        print("downloadURL: \(downloadURL)")
                        print("imageDownloadURL absolute string: \(imageDownloadURL!)")
                        self.ref.child("users").child(currentUserID).updateChildValues(["imageURL": imageDownloadURL!], withCompletionBlock: { (error, databaseRef) in
                            if let err = error {
                                print("error while uploading image url to cloud")
                                print(err)
                                return
                            }
                            else {
                                print("successfully uploaded image url to cloud")
                            }
                        })

                        
                         }
                                   })
                   }
        }
        
        print("upload data: \(uploadData)")

      
    }
    
    func downloadImageFromCloud() {
        
        
        let directoryPath = NSHomeDirectory().appending("/Documents")
        
        if !FileManager.default.fileExists(atPath: directoryPath){
            do{
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print(error)
                print("error while saving image")
            }
        }
        
        if let fileName = Auth.auth().currentUser?.uid.appending(".jpg") {
            let downloadRef = storageRef.child(fileName)
            
            let filepath = directoryPath.appending("\(fileName)")
            let url = NSURL.fileURL(withPath: filepath)
            
            downloadRef.write(toFile: url) { (url, error) in
                
                if let err = error {
                    print("error while downloading image from cloud")
                    print(err.localizedDescription)
                }
                else {
                    print("successfully downloaded image from cloud")
                    print("url: \(url!)")
                    self.setProfileImage()
                }
            }
            
        }
        else {
            print("error file name")
            return
        }
        
        
        
    }
    
    
    //UIImagePicker delegate methods



}

extension SideMenuVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImg: UIImage!
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.profileImageView.image = editedImage
            self.currentProfilePicture = editedImage
            selectedImg = editedImage
            
            
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true) {
            
            if let favPlacesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC {
                favPlacesVC.selectedCustomImage = self.currentProfilePicture
                print("selected image transfered")
                self.pictureDelegate?.changePickedProfilePicture(image: selectedImg)
                let profilePictureFilePath = self.savePickedImageToStorage(pickedImage: selectedImg)
                print("profilePictureFilePath: \(profilePictureFilePath)")
                self.saveImageToCloud(image: selectedImg)
                self.changeDatabaseValue(parameter: "profilePictureChanged", value: "true")
                
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func changeDatabaseValue(parameter: String, value: String) {
        guard let userID = Auth.auth().currentUser?.uid else {return }
        ref.child("users").child(userID).updateChildValues([parameter: value]) { (error, databaseRed) in
            
            if let err = error {
                print("error while chainging parameter in cloud")
                print(err.localizedDescription)
            }
            else {
                print("successfully changed parameter")
            }
            
        }
    }
    
    func setProfileImage() {
        let image = getProfilePictureFromStorage()
        currentProfilePicture = image
        print("setProfileImage called")
        profileImageView.image = currentProfilePicture
        isProfileImgSet = true
        
    }
    
    func checkChangedProfilePicture(){
        print("checkChangedProfilePicture called")
        guard let userID = Auth.auth().currentUser?.uid else {return }
        print("checkChangedProfilePicture called")
        ref.child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let isProfilePicChanged = value?["profilePictureChanged"] as? String ?? ""
            print("isProfilePicChanged: \(isProfilePicChanged)")
            if (isProfilePicChanged == "true"){
                //download the imaga locally
                self.changeDatabaseValue(parameter: "profilePictureChanged", value: "false")
                self.downloadImageFromCloud()
                
            }
        }
        
        
    }
    
    
    func savePickedImageToStorage(pickedImage image: UIImage) -> String{
        
        let directoryPath = NSHomeDirectory().appending("/Documents")
        
        if !FileManager.default.fileExists(atPath: directoryPath){
            do{
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                 print(error)
                 print("error while saving image")
            }
        }
        
        guard let fileName = Auth.auth().currentUser?.uid.appending(".jpg") else { return "error"}
        let filepath = directoryPath.appending(fileName)
        let url = NSURL.fileURL(withPath: filepath)
        
        do{
            try image.jpegData(compressionQuality: 1.0)?.write(to: url, options: .atomic)
             print("image saved ")
            return String.init("/Documents/\(fileName)")
           
        }
        
        catch {
             print(error)
            print("file cant not be save at path \(filepath), with error: \(error)")
            return filepath
            
        }
        
    }
    
    func getProfilePictureFromStorage() -> UIImage {
        print("getPictureFromStorage called")
        var imageForReturn: UIImage!
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let userID = Auth.auth().currentUser?.uid else {return UIImage()}
        print("userID get: \(userID) ")
        
        
        if let dirPath          = paths.first{
         
            print("dirPath: \(dirPath)")
            let imagePath = dirPath.appending("\(userID).jpg")
            let imageURL = NSURL.fileURL(withPath: imagePath)
            if let image = UIImage(contentsOfFile: imageURL.path){
                imageForReturn = image
                print("image returned from documents")
                
            } else {
                downloadImageFromCloud()
                print("download image because is not existing in the storage")
                imageForReturn = UIImage()
            }
            
        
         }
        
        return imageForReturn
    }
    

}


