//
//  APIManager.swift
//  mermaids
//
//  Created by DAVID on 16/01/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit

 let USER_COUNT = "30"
 let Base_Url = "http://api.mermaidsdating.com/index.php"


class APIManager: NSObject {
    
    /**
     ** Check if access token in valid If status is TRUE then it's valid and app RUN smoothly. If not then it logged user out automatically.
     **/

    func checkTokenValidation(completion: @escaping (_ status: Bool) -> Void) {
        
        //Use Alamofire Next time
        
        var request = URLRequest(url: URL(string: Base_Url)!)
        request.httpMethod = "POST"
        
        let tokenInfo = UserDefaults.standard.string(forKey: "token")

        var postString = "action=check_token&"
        
        postString.append("vtoken=\(tokenInfo!)&")
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.catchError()
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            print(responseString!)
            let jsonData = responseString?.data(using: .utf8)
            
            let json = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! [String:Any]

            let success = json["success"] as! NSNumber
            
            if success == 1  {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        task.resume()
    }
    
    /**
     ** Getting app setting
     **/

    class func getSettings(completion: @escaping (_ details:[Any]) -> Void) {
        
        //Use Alamofire Next time
        
        var request = URLRequest(url: URL(string: Base_Url)!)
        request.httpMethod = "POST"
        
        let tokenInfo = UserDefaults.standard.string(forKey: "token")
        
        var postString = "action=check_token&"
        
        postString.append("vtoken=\(tokenInfo!)")
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            self.catchError()
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            print(responseString!)
            let jsonData = responseString?.data(using: .utf8)
            
            let json = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! [String:Any]
            var details:[Any] = []
            
            details = json["details"] as! [Any]
            
            completion(details)
        }
        
        task.resume()
    }
    
    func setMySettings(completion: @escaping (_ details:[Any]) -> Void) {
        
        //Use Alamofire Next time
        
        var request = URLRequest(url: URL(string: Base_Url)!)
        request.httpMethod = "POST"
        
        let tokenInfo = UserDefaults.standard.string(forKey: "token")
        
        var postString = "action=check_token&"
        
        postString.append("vtoken=\(tokenInfo!)&")
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.catchError()
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            print(responseString!)
            let jsonData = responseString?.data(using: .utf8)
            
            let json = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! [String:Any]
            var details:[Any] = []
            
            details = json["details"] as! [Any]
            
            completion(details)
        }
        
        task.resume()
    }

    /*
     *
     my_settings": {
     "action": "my_settings",
     "pub_profil": "Y|N",
     "seeking": "M,F,C",
     "age_range": "{\"from\":\"18\",\"to\":\"50\"}",
     "distance": "val",
     "notifications": "Y|N",
     "app_sound": "Y|N",
     "app_vibration": "Y|N",
     "token": "Token String"
     }
     */
    
    
    /**
     ** Getting users to swipe
     **/
    func getUsers(completion: @escaping (_ details:[Any]) -> Void) {
        var request = URLRequest(url: URL(string: Base_Url)!)
        request.httpMethod = "POST"
        let tokenInfo = UserDefaults.standard.string(forKey: "token")

        var postString = "action=Swipuser&"
        postString.append("limit=10&")
        postString.append("token=\(tokenInfo!)&")
        postString.append("current_page=1")
        
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error)")
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            
            let jsonData = responseString?.data(using: .utf8)
            //
            let json = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! [String:Any]
            
            var details:[Any] = []

            details = json["details"] as! [Any]
            
            completion(details)
        }
        task.resume()
    }

//    func loadSearchData(_ keyword:String, completion: @escaping ([Videos]) -> Void) {
//        
//        //Use Alamofire Next time
//        
//        var request = URLRequest(url: URL(string:"http://api.mermaidsdating.com/index.php")!)
//        request.httpMethod = "POST"
//        
//        let tokenInfo = UserDefaults.standard.string(forKey: "token")
//        
//        var postString = "action=Search&"
//        
//        postString.append("vtoken=\(tokenInfo!)&")
//        postString.append("keyword=\(keyword!)")
//        request.httpBody = postString.data(using: .utf8)
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            self.catchError()
//            guard error == nil else {
//                print(error!)
//                return
//            }
//            guard let data = data else {
//                print("Data is empty")
//                return
//            }
//            let responseString = String(data: data, encoding: .utf8)
//            print(responseString!)
//            let jsonData = responseString?.data(using: .utf8)
//            
//            let json = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! [String:Any]
//            print(json)
//            
//            completion(json as [Any:String])
//        }x`
//        
//        task.resume()
//    }

    func catchError()
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

   
}
