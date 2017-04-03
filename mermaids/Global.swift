//
//  Global.swift
//  mermaids
//
//  Created by DAVID on 14/02/17.
//  Copyright © 2016 Jingged. All rights reserved.
//


import Foundation
import UIKit
import CoreData
import EZLoadingActivity

//Singleton class

class Global {
    
    //MARK: Shared Instance
    
    static let sharedInstance : Global = {
        let instance = Global()
        return instance
    }()
    
    let apiManager = APIManager()
    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    func appColor() -> UIColor {
        return UIColor.mermaidBlue()
    }

    func logOutFromApp() {
        FBSDKAccessToken.current()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
    }
    
    func moveToMainView() {
        //Removing object from user default
        UserDefaults.standard.removeObject(forKey: "token")
        
        let rootVC:LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewControllerID") as! LoginViewController
        let nvc:UINavigationController = storyboard.instantiateViewController(withIdentifier: "loginRootVC") as! UINavigationController
        nvc.viewControllers = [rootVC]
        UIApplication.shared.keyWindow?.rootViewController = nvc
    }
    
    func setImageFromUrl(str:String, completion: @escaping (_ image: UIImage) -> Void) {
        SDWebImageManager.shared().downloadImage(with: NSURL(string: str) as URL!, options: .continueInBackground, progress: {
            (receivedSize :Int, ExpectedSize :Int) in
            
        }, completed: {
            (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
            
            if (error != nil) {
                print(error!.localizedDescription as Any)
            }
            if (image != nil) {
                // Finally convert that Data into an image and do what you wish with it.
                completion(image!)
                // Do something with your image.
            }
            
        })
    }
    
    func addLeftAnimation(_ view: UIView) {
        let slideInFromLeftTransition = CATransition()
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromLeft
        slideInFromLeftTransition.duration = 0.5
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        view.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    
    func addRightAnimation(_ view: UIView) {
        let slideInFromLeftTransition = CATransition()
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromRight
        slideInFromLeftTransition.duration = 0.5
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        view.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }

    func showLoaderWithMsg(str:String) {
        EZLoadingActivity.show(str, disableUI: true)
    }
    
    func hideLoader() {
        EZLoadingActivity.hide()
    }
    
    
}
