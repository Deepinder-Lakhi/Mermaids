//
//  IceBreakerViewController.swift
//  mermaids
//
//  Created by Other on 1/25/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit

class IceBreakerViewController: UIViewController {

    @IBOutlet weak var answerTxtView: SKTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.tintColor = UIColor.white
        backButton.setImage(UIImage.init(named: "angle_2")?.withRenderingMode(.alwaysTemplate), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitYourAnswer(_ sender: Any) {
//        if (answerTxtView.text?.characters.count)! > 0 {
//            self.postIceBreaker()
//        } else {
//            let alertMessage = UIAlertController(title: nil, message: "This field should not be empty", preferredStyle: .alert)
//            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alertMessage, animated: true, completion: nil)
//        }
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func postIceBreaker() {
        var request = URLRequest(url: URL(string:"http://api.mermaidsdating.com/index.php")!)
        request.httpMethod = "POST"
        let tokenInfo = UserDefaults.standard.string(forKey: "token")
        
        var postString = "action=icebreaker&"
        postString.append("answer=\(tokenInfo)&")
        postString.append("token=\(answerTxtView.text!)")
        
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error)")
                let new = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewControllerID") as! UserProfileViewController
                self.present(new, animated: false, completion: nil)

                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            
            print("responseString = \(responseString!)")
            
            
            DispatchQueue.main.sync {
                
                let rootVC:UserProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewControllerID") as! UserProfileViewController
                let nvc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "rootNavigationController_2") as! UINavigationController
                nvc.viewControllers = [rootVC]
                UIApplication.shared.keyWindow?.rootViewController = nvc

            }
        }
        task.resume()
    }


}
