//
//  Conference.swift
//  IT Tour
//
//  Created by Vladimir Savov on 6.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation
import CoreData

class Conference: NSManagedObject {

    @NSManaged var conferenceID: NSNumber?
    @NSManaged var conferenceName: String?
    @NSManaged var endDate: NSDate?
    @NSManaged var isDefault: NSNumber
    @NSManaged var logoURL: String?
    @NSManaged var startDate: NSDate?
    @NSManaged var image: NSData?
    @NSManaged var lectures: NSSet?

}
