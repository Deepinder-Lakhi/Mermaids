//
//  MatchViewController.swift
//  mermaids
//
//  Created by Other on 1/25/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    fileprivate struct storyboard {
        static let newCell = "newUser"
        static let allCell = "allUser"
    }
    
    var details:[Any] = []
    
    @IBAction func backButtonPressedf(_ sender: Any) {
        goBack()
    }
    
    @IBAction func homeButtonPressedf(_ sender: Any) {
        goBack()
    }
    
    @IBAction func menuoptions(_ sender: Any) {
//        goBack()
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        }
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.newCell, for: indexPath) as! MatchScrollCell
            cell.cellSelection?.addTarget(self, action: #selector(self.launchChatScreen), for: .touchUpInside)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.allCell, for: indexPath) as! MatchTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        if indexPath.section == 0 {
            launchProfileScreen()
        } else {
            launchChatScreen()
        }
    }
    
    func launchChatScreen() {
        let new = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewControllerID") as! ChatViewController
        self.navigationController?.pushViewController(new, animated: true)
    }
    
    func launchProfileScreen() {
        let new = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewControllerID") as! ProfileViewController
        self.navigationController?.pushViewController(new, animated: true)
    }

    
}
