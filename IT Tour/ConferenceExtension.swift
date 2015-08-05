//
//  ConferenceExtension.swift
//  IT Tour
//
//  Created by Vladimir Savov on 5.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation

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
}