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
    
    public var firstLetter: String? {
        return self.firstName?.stringByPaddingToLength(1, withString: "", startingAtIndex: 0)
    }
    
    public func setImageData(image: UIImage?) {
        if let unwrappedImage = image {
            let imageData = UIImageJPEGRepresentation(unwrappedImage, 0.8)
            
            self.image = imageData
            
            return
        }
        
        self.image = nil
    }
    
    public func getImage() -> UIImage? {
        if let imageData = self.image {
            return UIImage(data: imageData)
        }
        
        return nil
    }
}