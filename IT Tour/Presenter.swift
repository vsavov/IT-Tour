//
//  Presenter.swift
//  IT Tour
//
//  Created by Vladimir Savov on 5.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation
import CoreData

class Presenter: NSManagedObject {

    @NSManaged var firstName: String?
    @NSManaged var imageURL: String?
    @NSManaged var lastName: String?
    @NSManaged var presenterID: NSNumber?
    @NSManaged var shortBio: String?
    @NSManaged var image: NSData?
    @NSManaged var lectures: NSSet?

}
