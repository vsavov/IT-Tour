//
//  Room.swift
//  IT Tour
//
//  Created by Vladimir Savov on 2.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation
import CoreData

public class Room: NSManagedObject {

    @NSManaged public var roomID: NSNumber?
    @NSManaged public var roomName: String?
    @NSManaged public var lectures: NSSet?

}
