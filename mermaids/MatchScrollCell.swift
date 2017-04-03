//
//  MacthScrollCell.swift
//  Mermaids
//
//  Created by DEEPINDERPAL SINGH on 06/03/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit

class MatchScrollCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var cellSelection:UIButton?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        //Constant size for user view
        let boxSize = self.scrollView.frame.size.height
        
        for index in [Int](0...6) {
            
            let x_axis = Int(boxSize) * Int(index)
            
            let userView = UIView(frame: CGRect(x: CGFloat(x_axis), y: 0, width: boxSize, height: boxSize))
            cellSelection = UIButton(frame:userView.frame)
            cellSelection?.backgroundColor = .clear

            
            let userImg = UIImageView(frame: CGRect(x: 9, y: 0, width: 72, height: 72))
            userImg.image = UIImage(named: "user_1")
            userImg.contentMode = .scaleAspectFill
            userImg.layer.cornerRadius = 5
            userImg.clipsToBounds = true
            
            userView.addSubview(userImg)
            
            let userNameLbl = UILabel(frame: CGRect(x: 0, y: 72, width: boxSize, height: 18))
            userNameLbl.text = "Lisa"
            userNameLbl.font = UIFont.init(name: "Helvetica Neue", size: 14)
            userNameLbl.textAlignment = .center
            userView.addSubview(userNameLbl)
            
            
            userView.addSubview(cellSelection!)
            
            self.scrollView.addSubview(userView)
            
        }
        
        
        //Load scroll view with default views
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: boxSize * 7, height: self.scrollView.frame.size.height)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
