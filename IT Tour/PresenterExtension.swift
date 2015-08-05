//
//  PresenterExtension.swift
//  IT Tour
//
//  Created by Vladimir Savov on 5.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation
import UIKit

extension Presenter {
    
    var firstLetter: String? {
        return self.firstName?.stringByPaddingToLength(1, withString: "", startingAtIndex: 0)
    }
    
    func setImageData(image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        
        self.image = imageData
    }
    
    func getImage() -> UIImage? {
        if let imageData = self.image {
            return UIImage(data: imageData)
        }
        
        return nil
    }
}