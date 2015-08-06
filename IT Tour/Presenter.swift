//
//  Presenter.swift
//  IT Tour
//
//  Created by Vladimir Savov on 5.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation
import CoreData

public class Presenter: NSManagedObject {

    @NSManaged public var firstName: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var lastName: String?
    @NSManaged public var presenterID: NSNumber?
    @NSManaged public var shortBio: String?
    @NSManaged public var image: NSData?
    @NSManaged public var lectures: NSSet?

}
