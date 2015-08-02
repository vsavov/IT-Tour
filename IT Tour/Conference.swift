//
//  Conference.swift
//  IT Tour
//
//  Created by Vladimir Savov on 2.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation
import CoreData

class Conference: NSManagedObject {

    @NSManaged var conferenceID: NSNumber
    @NSManaged var conferenceName: String
    @NSManaged var endDate: NSDate
    @NSManaged var isDefault: NSNumber
    @NSManaged var logoURL: String
    @NSManaged var startDate: NSDate
    @NSManaged var lectures: NSSet

    var year: String {
        let flags = NSCalendarUnit.CalendarUnitYear
        let components = NSCalendar.currentCalendar().components(flags, fromDate: self.startDate)
        
        let yearComponent = components.year
        
        return String(yearComponent)
    }
}
