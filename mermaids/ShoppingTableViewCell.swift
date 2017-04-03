//
//  ShoppingTableViewCell.swift
//  Mermaids
//
//  Created by DEEPINDERPAL SINGH on 15/02/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit

class ShoppingTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var catFishButton: UIButton!
    @IBOutlet weak var starFishButton: UIButton!
    
//    var person:Person? {
//        didSet {
//            updateCell()
//        }
//    }
    
    // Update cell with info
    
    func updateCell() {
        
        profileImgView.layer.borderColor = UIColor.white.cgColor
//        titleLbl.text = ("#\(video!.vRank)")
        
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
