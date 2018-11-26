//
//  AppDelegate.swift
//  ARNavi
//
//  Created by Martin on 9/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import SideMenu
import Lottie
import TwitterKit
import GoogleSignIn
import SwiftSpinner

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate  {
    
    

    var window: UIWindow?
    var ref: DatabaseReference!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: "W7gUASry4YKefi3EZHgIR9MTX", consumerSecret: "ehTv1Xiq1rHdAzidfsP8f4o1M6McKes1FIFjlNrPmZB4W0hRyG")
        
        if let splashVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashScreenVC") as? SplashScreenVC {
         self.window?.rootViewController = splashVC
         self.window?.makeKeyAndVisible()
        }
        
        
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            if shortcutItem.type == "com.martin.ARNavi.adduser" {
                //shortcut add user was triggered
                
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                          annotation: [:])
        
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        ref = Database.database().reference()
        if let err = error {
            print("Failed to log into google: ", err)
            return
        }
        else {
            print("Successfully logged into google: ", user)
            guard let authentication = user.authentication else {return}
            SwiftSpinner.show("Logging in...", animated: true)
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken , accessToken: authentication.accessToken)
            
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                
                if let err = error{
                
                     print("Error with logging google acc on firebase")
                    print(err.localizedDescription)
                    SwiftSpinner.show(err.localizedDescription, animated: true)
                }
                else {
                    
                    // Successfully signed in on firebase
                    guard let userEmail = authResult?.user.email else {return}
                    guard let name = authResult?.user.displayName else {return}
                    guard let userID = authResult?.user.uid else {return}
                    print("userEmail: \(userEmail) with name: \(name)")
                    
                    self.ref.child("users").child(userID).updateChildValues(["name" : name, "email" : userEmail])
                    
                    SwiftSpinner.hide()
                    if let rootNavigation = self.window?.rootViewController as? UINavigationController {
                    
                        if let favPlacesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavPlacesVC") as? FavPlacesVC {
                            
                            rootNavigation.pushViewController(favPlacesVC, animated: true)
                            print("favplaces instatiated")
                            
                        }
                        
                    }
                    
                    
                }
                
                SwiftSpinner.hide()
                
                
                
                
                
            }
            
        }
    }
    
 
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        
        if let rootNavigation = self.window?.rootViewController as? UINavigationController {
            print("rootnavigation action triggered")
            
            if shortcutItem.type == "Add user"{
                //print("quick action triggered")
                
//                print("root viewcontrollers: \(rootNavigation.viewControllers)")
                
                if let firstScreen = rootNavigation.viewControllers.first as? FirstScreenVC {
                    
                    if let favPlacesVC = rootNavigation.viewControllers.last as? FavPlacesVC {
                        
                         favPlacesVC.quickAction = "Add user"
                         //firstScreen.navigationController?.pushViewController(favPlacesVC, animated: true)
                         //favPlacesVC.performSegue(withIdentifier: "showSideMenu", sender: nil)
                        
                    }
                    
                }
     
            }
            
            else if shortcutItem.type == "Update my info"{
                
                if let firstScreen = rootNavigation.viewControllers.first as? FirstScreenVC {
                    
                    if let favPlacesVC = rootNavigation.viewControllers.last as? FavPlacesVC {
                        
                        favPlacesVC.quickAction = "Update my info"
                        //firstScreen.navigationController?.pushViewController(favPlacesVC, animated: true)
                        //favPlacesVC.performSegue(withIdentifier: "showSideMenu", sender: nil)
                        
                    }
                    
                }
            }
        }
    }
    
    class func sharedInstance() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ARNavi")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

