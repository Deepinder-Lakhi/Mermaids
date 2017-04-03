//
//  PasswordViewController.swift
//  mermaids
//
//  Created by Other on 1/26/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {
    
    var responce = [String:AnyObject]()
    @IBOutlet weak var passTxtFld: SKFormTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passTxtFld.textField.isSecureTextEntry = true
        print("Entered password View controller")
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func singupBtnTapped(_ sender: Any) {
        
        if (passTxtFld.textField.text?.characters.count)! > 0 {
            self.loginAndRegistrationWithFacebook(data: responce)
        } else {
            let alertMessage = UIAlertController(title: nil, message: "Password field should not be empty", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        
    }
    
    func loginAndRegistrationWithFacebook(data:[String:Any]) {
        
        //Use Alamofire Next time
        
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
        postString.append("passw=\(passTxtFld.textField.text!)")
        
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
            
            let picture = self.convertDataForPicture(data: self.responce["picture"]!) as! [String:Any]
            
            let age = self.convertDataForCover(data: self.responce["age_range"]!) as! [String:Any]
            let ageAny = age["min"]! as AnyObject
            guard let ageString = ageAny.stringValue
                else {
                    print("Error") // Was not a string
                    return // needs a return or break here
            }


            
            var responseString = String(data: data, encoding: .utf8)
            var responceArr = responseString?.components(separatedBy: "{")
            responseString = "{\(responceArr![1]){\(responceArr![2])"
            
            let jsonData = responseString?.data(using: .utf8)
            
            var json = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! [String:Any]
            
            json["name"] = self.responce["name"]! as! String
            json["gender"] = self.responce["gender"]! as! String
            json["age"] = ageString
            json["image"] = picture["url"]
            
            print(json)

            let details = json["details"] as! [String:Any]
            
            let defaults = UserDefaults.standard
            
            defaults.set(json, forKey: "userProfile")
            
            defaults.set(details["token"], forKey: "token")
            
            let new = self.storyboard?.instantiateViewController(withIdentifier: "WSViewController_ID") as! WSViewController
            self.present(new, animated: false, completion: nil)

        }

        task.resume()
    }
    
    func setVal(_ val: AnyObject) -> (String) {
        let newVal = val as? String
        return newVal!
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
