//
//  UserProfileViewController.swift
//  mermaids
//
//  Created by Other on 1/29/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var ageRangeLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var aboutMeTxtView: UITextView!
    @IBOutlet weak var LogoutBtn: UIButton!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        Global.sharedInstance.addRightAnimation((self.navigationController?.view)!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settings(_ sedner:Any) {
        launchWindowShoppingScreen()
        
    }
    
    private func showPopUpVC()
    {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewControllerID")
        addChildViewController(newVC!)
        newVC?.view.frame = self.view.bounds
        newVC?.didMove(toParentViewController: self)
    }

    
    func launchWindowShoppingScreen() {
        let new = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewControllerID") as! SettingViewController
        self.present(new, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImgView.layer.borderColor = UIColor.init(colorLiteralRed: 250.0/255, green: 85.0/255, blue: 175.0/255, alpha: 1.0).cgColor
        profileImgView.layer.borderWidth = 5
        showPopUpVC()
//        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func loadData() {
        var userInfo = UserDefaults.standard.dictionary(forKey: "userProfile")! as [String:Any]
        
//        let details = userInfo["details"] as! [String:Any]
        userNameLbl.text = userInfo["name"] as! String?
//        ageRangeLbl.text = userInfo["age"] as! String?
//        genderLbl.text = userInfo["gender"] as! String?
//        userEmailLbl.text = details["email"] as! String?
        
        let imageStr:String = (userInfo["image"] as! String?)!
        
        let dCode = imageStr.removingPercentEncoding
        
        Global.sharedInstance.setImageFromUrl(str: dCode!, completion:  {
            (image: UIImage) in
            self.profileImgView.image = image
        })

    }

    @IBAction func logoutBtnPressed() {
        Global.sharedInstance.logOutFromApp()
        Global.sharedInstance.moveToMainView()
    }

}
