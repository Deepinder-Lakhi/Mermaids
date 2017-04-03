//
//  LaunchViewController.swift
//  Mermaids
//
//  Created by DEEPINDERPAL SINGH on 13/02/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        let tokenInfo = UserDefaults.standard.string(forKey: "token")
        if (tokenInfo != nil) {
            let apiManager = APIManager()
            apiManager.checkTokenValidation(completion:  {
                (status: Bool) in
                
                DispatchQueue.main.sync {
                    if status == true {
                        //Token is valid
                        self.launchWindowShoppingScreen()
                    } else {
                        Global.sharedInstance.logOutFromApp()
                        self.launchLoginScreen()
                    }
                }
            })
        } else {
            self.launchLoginScreen()
        }

        // Do any additional setup after loading the view.
    }
    
    func launchLoginScreen() {
        let rootVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewControllerID") as! LoginViewController
        let nvc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "loginRootVC") as! UINavigationController
        nvc.viewControllers = [rootVC]
        UIApplication.shared.keyWindow?.rootViewController = nvc
    }
    
    func launchWindowShoppingScreen() {
        let rootVC:WSViewController = self.storyboard?.instantiateViewController(withIdentifier: "WSViewController_ID") as! WSViewController
        let nvc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "shoppingRootVC") as! UINavigationController
        nvc.viewControllers = [rootVC]
        UIApplication.shared.keyWindow?.rootViewController = nvc
    }
    
}
