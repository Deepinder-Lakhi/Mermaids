//
//  AboutYouViewController.swift
//  Mermaids
//
//  Created by DEEPINDERPAL SINGH on 03/03/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit

class AboutYouViewController: UITableViewController {
    
    fileprivate struct storyboard {
        static let cellReuseIdentifier = "blankCell"
        static let stepOne = "stepOne"
        static let stepTwo = "stepTwo"
        static let stepThree = "stepThree"
        static let next = "nextCell"
        static let ageRange = "ageRange"
    }
    
    let titleArray:[String] = ["I am", "Seeking"]
    var optionStatus:Int = 1
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 227.0/255, green: 227.0/255, blue: 227.0/255, alpha: 1.0)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            
            if optionStatus == 2{
                
                return 1
            
            }
            return 2
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if optionStatus == 1 {
            return loadOptionOneCellForTableView(tableView, cellForRowAt: indexPath)
            
        } else if optionStatus == 2 {
            return loadOptionTwoCellForTableView(tableView, cellForRowAt: indexPath)
        
        }
        return loadOptionThreeCellForTableView(tableView, cellForRowAt: indexPath)
    }
    
    func selectionStyleForCell(_ cell:UITableViewCell) {
        cell.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250
        }
        if optionStatus == 2 {
            if indexPath.section == 1 {
                return 235
            }
        } else if optionStatus == 3 {
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    return 140
                }
            }
        }
        
        return 100
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2
        {
            if optionStatus < 3 {
                
                optionStatus = optionStatus + 1
                
                let slideInFromLeftTransition = CATransition()
                // Customize the animation's properties
                slideInFromLeftTransition.type = kCATransitionPush
                slideInFromLeftTransition.subtype = kCATransitionFromRight
                slideInFromLeftTransition.duration = 0.5
                slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                slideInFromLeftTransition.fillMode = kCAFillModeRemoved
                
                // Add the animation to the View's layer
                tableView.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
                tableView.reloadData()
            } else {
                launchWindowShoppingScreen()
            }
        }
    }
    
    
    func launchWindowShoppingScreen() {
        let new = self.storyboard?.instantiateViewController(withIdentifier: "WSViewController_ID") as! WSViewController
        self.navigationController?.pushViewController(new, animated: true)
    }

    

    /**
     * Multiple option of cells
     **/
    func loadOptionOneCellForTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.stepOne, for: indexPath) as! AboutYouTableViewCell
            cell.titleLabel?.text = titleArray[indexPath.row]
            
            selectionStyleForCell(cell)
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.next, for: indexPath) as! AboutYouTableViewCell
            selectionStyleForCell(cell)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.cellReuseIdentifier) as! AboutYouTableViewCell
        selectionStyleForCell(cell)
        return cell
    }
    
    func loadOptionTwoCellForTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.stepTwo, for: indexPath) as! AboutYouTableViewCell
            selectionStyleForCell(cell)
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.next, for: indexPath) as! AboutYouTableViewCell
            selectionStyleForCell(cell)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.cellReuseIdentifier) as! AboutYouTableViewCell
        selectionStyleForCell(cell)
        return cell
    }
    
    func loadOptionThreeCellForTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.ageRange, for: indexPath) as! AboutYouTableViewCell
                cell.labelSlider?.minimumValue = 0;
                cell.labelSlider?.maximumValue = 100;
                
                cell.labelSlider?.lowerValue = 0;
                cell.labelSlider?.upperValue = 100;
                
                cell.labelSlider?.minimumRange = 10;

                selectionStyleForCell(cell)
                
                return cell
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.stepThree, for: indexPath) as! AboutYouTableViewCell
            selectionStyleForCell(cell)
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.next, for: indexPath) as! AboutYouTableViewCell
            selectionStyleForCell(cell)
            cell.nextBtn?.setTitle("Finish", for: .normal)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.cellReuseIdentifier) as! AboutYouTableViewCell
        selectionStyleForCell(cell)
        return cell
    }
    
    

}
