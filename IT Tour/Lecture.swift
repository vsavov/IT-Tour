//
//  Lecture.swift
//  IT Tour
//
//  Created by Vladimir Savov on 2.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation
import CoreData

class Lecture: NSManagedObject {

    @NSManaged var lectureID: String
    @NSManaged var startTime: NSDate
    @NSManaged var endTime: NSDate
    @NSManaged var videoURL: String
    @NSManaged var presentationURL: String
    @NSManaged var presenters: NSSet
    @NSManaged var conference: Conference
    @NSManaged var room: Room

}
