//
//  SettingsVC.swift
//  ARNavi
//
//  Created by Martin on 10/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var gpsStackView: UIStackView!
    @IBOutlet weak var biometricalStackView: UIStackView!
    @IBOutlet weak var gpsSwitch: UISwitch!
    @IBOutlet weak var biometricalLabel: UILabel!
    @IBOutlet weak var biometricalSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Settings"
        view.backgroundColor = AppColor.backgroundColor.rawValue
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
