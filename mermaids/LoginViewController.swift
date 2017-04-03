//
//  LoginViewController.swift
//  mermaids
//
//  Created by DAVID on 18/01/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

//https://developers.facebook.com/docs/graph-api/reference/v2.6/user

import UIKit


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var fbLoginBckView: UIView!
    var response = [String:AnyObject]()

    @IBOutlet weak var fbBtnHeight: NSLayoutConstraint!
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile", "email"]
        return button
    }()
    
    override func viewDidLoad() {
        loginButton.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        if let token = FBSDKAccessToken.current() {
            print(token)
//            fetchProfile()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loginButton.frame = fbLoginBckView.bounds
        fbLoginBckView.addSubview(loginButton)
    }
    
    //FBSDKLogin Delegates
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        fbLoginBckView.isHidden = true
        fbBtnHeight.constant = 0
        fetchProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout")
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func fetchProfile() {
        
        //Setting parameters
        let params = ["fields" : "id, email, name, first_name, last_name, link, gender, age_range, locale, picture.type(large), cover.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: params).start {(connection, result, error) -> Void in
            if error != nil {
                NSLog(error.debugDescription)
                return
            }
            // Handle vars
            if (result as? [String:Any]) != nil
            {
                self.response = result as! [String : AnyObject]
                self.loginAndRegistrationWithFacebook(data: result as! [String : AnyObject])
//                self.present(new, animated: false, completion: nil)
            }
        }

    }
    
    
//MARK: API Call
    
    func loginAndRegistrationWithFacebook(data:[String:Any]) {
        
        //Use Alamofire Next time
        
        Global.sharedInstance.showLoaderWithMsg(str: "Loading...")
        
        print("Data: \(data)")
        
        var request = URLRequest(url: URL(string:"http://api.mermaidsdating.com/index.php")!)
        request.httpMethod = "POST"
        
        let picture = self.convertDataForPicture(data: data["picture"]!) as! [String:Any]
        let age = self.convertDataForCover(data: data["age_range"]!) as! [String:Any]
        
        var postString = "action=Registerlogin&"
        postString.append("platform=ios&")
        postString.append("id=\(data["id"]! as! String)&")
        postString.append("email=\(data["email"]! as! String)&")
        postString.append("name=\(data["name"]! as! String)&")
        postString.append("first_name=\(data["first_name"]! as! String)&")
        postString.append("last_name=\(data["last_name"]! as! String)&")
        postString.append("link=\(data["link"]! as! String)&")
        postString.append("picture=\(picture["url"]! as! String)&")
        postString.append("gender=\(data["gender"]! as! String)&")
        
        let ageAny = age["min"]! as AnyObject
        guard let ageString = ageAny.stringValue
            else {
                print("Error") // Was not a string
                return // needs a return or break here
        }
        postString.append("age_range=\(ageString)&")
        postString.append("locale=\(data["locale"]! as! String)&")
        
        print("PostString:\(postString)")
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
//            
            let picture = self.convertDataForPicture(data: self.response["picture"]!) as! [String:Any]
            
            let age = self.convertDataForCover(data: self.response["age_range"]!) as! [String:Any]
            let ageAny = age["min"]! as AnyObject
            guard let ageString = ageAny.stringValue
                else {
                    print("Error") // Was not a string
                    return // needs a return or break here
            }

            let responseString = String(data: data, encoding: .utf8)
            
            let jsonData = responseString?.data(using: .utf8)
            
            var json = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! [String:Any]
            json["name"] = self.response["name"]! as! String
            json["gender"] = self.response["gender"]! as! String
            json["age"] = ageString
            json["image"] = picture["url"]
            
            print(json)
//
            let details = json["details"] as! [String:Any]
            
            let defaults = UserDefaults.standard
            
            defaults.set(json, forKey: "userProfile")
            
            defaults.set(details["token"], forKey: "token")
            
            DispatchQueue.main.async {
                Global.sharedInstance.hideLoader()
                self.launchAboutYouScreen()
            }
        }
        
        task.resume()
    }
    
    func launchAboutYouScreen() {
        let rootVC:AboutYouViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutYouViewControllerID") as! AboutYouViewController
        let nvc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "aboutRootVC") as! UINavigationController
        nvc.viewControllers = [rootVC]
        UIApplication.shared.keyWindow?.rootViewController = nvc
    }
    
    func launchWindowShoppingScreen() {
        let new = self.storyboard?.instantiateViewController(withIdentifier: "WSViewController_ID") as! WSViewController
        self.navigationController?.pushViewController(new, animated: true)
    }

    
    func convertDataForPicture(data:Any) -> (Any) {
        let jsonData = data as? [String:Any]
        let xmlData = jsonData?["data"]
        let json = xmlData as? [String:Any]
        return json!
    }
    
    func convertDataForCover(data:Any) -> (Any) {
        let jsonData = data as? [String:Any]
        return jsonData!
    }


    
}
