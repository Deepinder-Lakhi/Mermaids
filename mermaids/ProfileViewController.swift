//
//  ProfileViewController.swift
//  Mermaids
//
//  Created by DEEPINDERPAL SINGH on 27/02/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Constant size for user view
        let boxSize = self.scrollView.frame.size.height
        
        for index in [Int](0...5) {
            
            let x_axis = Int(boxSize) * Int(index)
            
            let userView = UIView(frame: CGRect(x: CGFloat(x_axis), y: 0, width: boxSize, height: boxSize))
            
            let userImg = UIImageView(frame: userView.frame)
            userImg.image = UIImage(named: "user_1")
            userImg.contentMode = .scaleAspectFill
            userImg.clipsToBounds = true
            
            userView.addSubview(userImg)

            self.scrollView.addSubview(userView)

        }
        
        
        //Load scroll view with default views
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: boxSize * 6, height: self.scrollView.frame.size.height)

    }
    
    
    @IBAction func backButtonPressedf(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
