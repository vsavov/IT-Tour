//
//  Lecture.swift
//  IT Tour
//
//  Created by Vladimir Savov on 3.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation
import CoreData

class Lecture: NSManagedObject {

    @NSManaged var endTime: NSDate
    @NSManaged var lectureID: String
    @NSManaged var presentationURL: String?
    @NSManaged var startTime: NSDate
    @NSManaged var videoURL: String?
    @NSManaged var isFavorite: NSNumber
    @NSManaged var lectureName: String
    @NSManaged var conference: Conference
    @NSManaged var presenters: NSSet?
    @NSManaged var room: Room?

    var startingHour: String {
        let dateFormatter = MainManager.hourDateFormatter
        
        let startTimeHours = dateFormatter.stringFromDate(self.startTime)
        
        return startTimeHours
    }
}
