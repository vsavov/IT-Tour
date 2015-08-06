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
    
    var year: String? {
        if let unwrappedStartDate = self.startDate {
            let flags = NSCalendarUnit.CalendarUnitYear
            let components = NSCalendar.currentCalendar().components(flags, fromDate: unwrappedStartDate)
            
            let yearComponent = components.year
            
            return String(yearComponent)
        }
        
        return nil
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