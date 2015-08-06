//
//  Lecture.swift
//  IT Tour
//
//  Created by Vladimir Savov on 3.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation
import CoreData

public class Lecture: NSManagedObject {

    @NSManaged public var endTime: NSDate?
    @NSManaged public var lectureID: String?
    @NSManaged public var presentationURL: String?
    @NSManaged public var startTime: NSDate?
    @NSManaged public var videoURL: String?
    @NSManaged public var isFavorite: NSNumber
    @NSManaged public var lectureName: String?
    @NSManaged public var conference: Conference?
    @NSManaged public var presenters: NSSet?
    @NSManaged public var room: Room?
}
