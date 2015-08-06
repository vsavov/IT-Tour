//
//  Conference.swift
//  IT Tour
//
//  Created by Vladimir Savov on 6.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation
import CoreData

public class Conference: NSManagedObject {

    @NSManaged public var conferenceID: NSNumber?
    @NSManaged public var conferenceName: String?
    @NSManaged public var endDate: NSDate?
    @NSManaged public var isDefault: NSNumber
    @NSManaged public var logoURL: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var image: NSData?
    @NSManaged public var lectures: NSSet?

}
