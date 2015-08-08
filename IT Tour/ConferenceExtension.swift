//
//  ConferenceExtension.swift
//  IT Tour
//
//  Created by Vladimir Savov on 5.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation
import UIKit

extension Conference {
    
    public var year: String? {
        if let unwrappedStartDate = self.startDate {
            let flags = NSCalendarUnit.CalendarUnitYear
            let components = NSCalendar.currentCalendar().components(flags, fromDate: unwrappedStartDate)
            
            let yearComponent = components.year
            
            return String(yearComponent)
        }
        
        return nil
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