

import UIKit

class Person: NSObject {
    
    let Name: NSString
    let Image: UIImage!
    let Age: NSNumber
    let Address: NSString
    let About: NSString
    let NumberOfPhotos: NSNumber
    var PhotosArray = [Any]()
    
    init(name: NSString?, image: UIImage?, age: NSNumber?, address: NSString?, about: NSString?, count:NSNumber?, images: [Any]) {
        self.Name = name ?? ""
        self.Image = image
        self.Age = age ?? 0
        self.Address = address ?? ""
        self.About = about ?? ""
        self.NumberOfPhotos = count ?? 0
        self.PhotosArray = images
    }
}
