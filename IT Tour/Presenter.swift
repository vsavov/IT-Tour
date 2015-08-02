//
//  Presenter.swift
//  IT Tour
//
//  Created by Vladimir Savov on 2.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation
import CoreData

class Presenter: NSManagedObject {

    @NSManaged var presenterID: NSNumber
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var imageURL: String
    @NSManaged var shortBio: String
    @NSManaged var lectures: NSSet

}
