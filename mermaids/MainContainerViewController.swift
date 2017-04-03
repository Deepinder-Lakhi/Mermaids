//
//  MainContainerViewController.swift
//  Mermaids
//
//  Created by DEEPINDERPAL SINGH on 20/02/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController, UIPageViewControllerDelegate {
    
    var pageController = UIPageViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        let page = UIPageControl()
        pageController = self.storyboard?.instantiateViewController(withIdentifier: "MainPageController") as! UIPageViewController
//        pageController.delegate = self
        
        
        let wsVC = self.storyboard?.instantiateViewController(withIdentifier: "WSViewController_ID")
        
        let userProfile = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewControllerID") as! UserProfileViewController
        
        pageController.setViewControllers([userProfile,wsVC!], direction: .forward, animated: true, completion: nil)
        
        print(self.view.bounds)
        var frame = self.view.bounds
        frame.size.height -= 20
        pageController.view.frame = frame
        page.isHidden = true
        
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        
        pageController.didMove(toParentViewController: self)

        // Do any additional setup after loading the view.
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    
    

}
