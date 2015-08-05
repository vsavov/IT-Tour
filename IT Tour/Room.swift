//
//  Room.swift
//  IT Tour
//
//  Created by Vladimir Savov on 2.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation
import CoreData

class Room: NSManagedObject {

    @NSManaged var roomID: NSNumber?
    @NSManaged var roomName: String?
    @NSManaged var lectures: NSSet?

}
