//
//  SplashViewController.swift
//  UseGithubAPI
//
//  Created by gem on 7/20/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Thread.sleep(forTimeInterval: 1.0)
        let navigation = storyboard?.instantiateViewController(withIdentifier: "Navigation") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navigation
        
    }
}
