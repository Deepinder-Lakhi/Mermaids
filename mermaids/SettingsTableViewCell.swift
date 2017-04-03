//
//  SettingsTableViewCell.swift
//  Mermaids
//
//  Created by DEEPINDERPAL SINGH on 23/02/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet var titleLbl:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    @IBAction func logout() {
        print("Logout")
        Global.sharedInstance.logOutFromApp()
        Global.sharedInstance.moveToMainView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
