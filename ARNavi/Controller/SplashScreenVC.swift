//
//  SplashScreenVC.swift
//  ARNavi
//
//  Created by Martin on 11/12/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import Lottie

class SplashScreenVC: UIViewController {
    @IBOutlet weak var animationView: LOTAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startAnimating()
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(stopAnimating), userInfo: nil, repeats: false)
    }
    

    func startAnimating(){
        animationView.setAnimation(named: "location")
        animationView.loopAnimation = true
        animationView.play()
        
    }
    
    @objc func stopAnimating(){
        if let rootNavigationController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navigationController") as? UIViewController {
         AppDelegate.sharedInstance().window?.rootViewController = rootNavigationController
        }
        
        
    }

}
