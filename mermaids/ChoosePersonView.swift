//
//  ChoosePersonView.swift
//  SwiftLikedOrNope
//
// Copyright (c) 2014 to present, Richard Burdish @rjburdish
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

class ChoosePersonView: MDCSwipeToChooseView {
    
    let ChoosePersonViewImageLabelWidth:CGFloat = 42.0;
    var person: Person!
    var informationView: UIView!
    var headerBV: UIView!
    var nameLabel: UILabel!
    var locationLabel: UILabel!
    var carmeraImageLabelView:ImagelabelView!
    var interestsImageLabelView: ImagelabelView!
    var friendsImageLabelView: ImagelabelView!
    
    init(frame: CGRect, person: Person, options: MDCSwipeToChooseViewOptions) {
        
        super.init(frame: frame, options: options)
        self.person = person
        
        for (index, element) in self.person.PhotosArray.enumerated() {
//
//            print("New element :\(element) at: \(index) ")
//            if let obj = element as? [String:Any] {
        
//                var imageStr:String = (obj["image"] as! String?)!
//                print(obj)

                let imageStr:String = "https://api.mermaidsdating.com/images/95/DESKTOP-HDWALLPAPERS(5)_1485440520_UP.jpg"
                
                if let image = self.person.Image {
                    self.constructImageView(with:image, onPosition: UInt(index))
                }
        
//                Global.sharedInstance.setImageFromUrl(str: imageStr, completion:  {
//                    (image: UIImage) in
//                    print("Downloaded Image:\(image)")
//                    DispatchQueue.main.sync {
//                        self.constructImageView(with: image, onPosition: 0)
//                    }
//                })
//            }
        }
        
        self.constructscrollView(for: Int32(self.person.PhotosArray.count))
        
        self.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.imageView.autoresizingMask = self.autoresizingMask
        constructInformationView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func constructInformationView() -> Void {
        let bottomHeight:CGFloat = 60.0
        let bottomFrame:CGRect = CGRect(x: 0,
            y: self.bounds.height - bottomHeight,
            width: self.bounds.width,
            height: bottomHeight);
        
        self.informationView = UIView(frame:bottomFrame)
        self.informationView.clipsToBounds = true
        self.informationView.backgroundColor = .clear
        self.informationView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleTopMargin]
        self.addSubview(self.informationView)
        constructNameLabel()
//        constructCameraImageLabelView()
//        constructInterestsImageLabelView()
//        constructFriendsImageLabelView()
    }
    
    
    func constructNameLabel() -> Void {
        
        let leftPadding:CGFloat = 12.0
        let containerHeight:CGFloat = 25.0

        var frame:CGRect = CGRect(
            x: 0,
            y: 0,
            width: self.informationView.frame.width,
            height: 60)
        
        headerBV = UIView(frame:frame)
        headerBV.clipsToBounds = true
        headerBV.backgroundColor = UIColor.init(red: 227.0/255, green: 227.0/255, blue: 227.0/255, alpha: 1)
        self.informationView.clipsToBounds = true
        self.informationView.addSubview(headerBV)
        
        //1
        frame.origin.x = leftPadding
        frame.origin.y = 5
        frame.size.height = containerHeight
        frame.size.width = floor(self.informationView.frame.width - (leftPadding * 2))
        
        self.nameLabel = UILabel(frame:frame)
        self.nameLabel.text = "\(person.Name), \(person.Age)"
        headerBV.addSubview(self.nameLabel)
        
        //2
        frame.origin.y = frame.size.height + frame.origin.y
        
        self.locationLabel = UILabel(frame:frame)
        self.locationLabel.text = String(person.Address)
        if (self.locationLabel.text?.characters.count)! > 0 {
            print("done")
            self.locationLabel.text = "UCLA, California"
        }
        self.locationLabel.text = "UCLA, California"
        self.locationLabel.font = UIFont.init(name: "Helvetica", size: 12)
        headerBV.addSubview(self.locationLabel)
        
        constructShare(frame: headerBV.frame)
        constructMenu(frame: headerBV.frame)

    }
    
    func constructDetailsBtn(frame:CGRect) -> Void {
        let details = UIButton(frame: frame)
        details.backgroundColor = .red
        self.headerBV.addSubview(details)
    }
    
    func constructShare(frame:CGRect) -> Void {
        let image:UIImage = UIImage(named:"forward_Icon")!
        let shareBtn = UIButton(frame: CGRect(x: frame.size.width - 80, y: 15, width: 30, height: 30))
        shareBtn.setImage(image.maskWithColor(color: UIColor.mermaidBlue()), for: .normal)

        self.headerBV.addSubview(shareBtn)
    }
    
    func constructMenu(frame:CGRect) -> Void {
        let image: UIImage = UIImage(named: "menu_Icon")!
        let menuBtn = UIButton(frame: CGRect(x: frame.size.width - 40, y: 17, width: 26, height: 26))
        menuBtn.setImage(image.maskWithColor(color: UIColor.mermaidBlue()), for: .normal)
        self.headerBV.addSubview(menuBtn)
    }
    
    func constructFriendsImageLabelView() -> Void {
        let image:UIImage = UIImage(named:"group")!
        self.friendsImageLabelView = buildImageLabelViewLeftOf(self.interestsImageLabelView.frame.minX, image:image, text:"No Friends")
        self.informationView.addSubview(self.friendsImageLabelView)
    }
    
    func buildImageLabelViewLeftOf(_ x:CGFloat, image:UIImage, text:String) -> ImagelabelView {
        let frame:CGRect = CGRect(x:x-ChoosePersonViewImageLabelWidth, y: 0,
            width: ChoosePersonViewImageLabelWidth,
            height: self.informationView.bounds.height)
        let view:ImagelabelView = ImagelabelView(frame:frame, image:image, text:text)
        
        view.autoresizingMask = UIViewAutoresizing.flexibleLeftMargin
        return view
    }
}
