//
//  AboutYouTableViewCell.swift
//  Mermaids
//
//  Created by DEEPINDERPAL SINGH on 03/03/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit

class AboutYouTableViewCell: UITableViewCell {
    
    
    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var labelSlider:NMRangeSlider?
    @IBOutlet var nextBtn:UIButton?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
