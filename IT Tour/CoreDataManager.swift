//
//  CoreDataManager.swift
//  IT Tour
//
//  Created by Vladimir Savov on 2.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import CoreData
import Foundation

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    
    lazy private(set) var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.parentContext = self.privateContext
        
        return managedObjectContext
        }()
    
    lazy private var privateContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistanceStoreCoordinator
        
        return managedObjectContext
        }()
    
    lazy private var persistanceStoreCoordinator: NSPersistentStoreCoordinator = {
        let modelURL = NSBundle.mainBundle().URLForResource("IT_Tour", withExtension: "momd")
        assert(modelURL != nil, "Can't find URL for the CoreData model!")
        
        let mom = NSManagedObjectModel(contentsOfURL: modelURL!)
        assert(mom != nil, "Error initializing ManagedObjectModel from: \(modelURL!)!")
        
        let persistanceStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mom!)
        
        let fileManager = NSFileManager.defaultManager()
        var folderPath = fileManager.containerURLForSecurityApplicationGroupIdentifier("group.bg.it-tour.IT-Tour")!.path!
        folderPath = folderPath.stringByAppendingPathComponent("CoreData")
        
        if !fileManager.fileExistsAtPath(folderPath) {
            var error: NSError?
            
            assert(fileManager.createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil, error: &error), "Failed to create CoreData folder \(folderPath), error \(error!)")
        }
        
        let storeURL = NSURL(fileURLWithPath: folderPath)!.URLByAppendingPathComponent("ITTour.sqlite")
        
        var error: NSError?
        var store = persistanceStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error)
        assert(store != nil, "Failed to load Persistant Store! Unresolved error \(error?.localizedDescription), \(error?.userInfo)\nAttempted to create store at \(storeURL)")
        
        return persistanceStoreCoordinator
    }()
    
    init() {
        save()
    }
    
    func save() {
        if !self.privateContext.hasChanges && !self.managedObjectContext.hasChanges {
            return
        }
        
        self.managedObjectContext.performBlockAndWait { () -> Void in
            var error: NSError?
            
            assert(self.managedObjectContext.save(&error), "Failed to save main context: \(error!.localizedDescription)\n\(error!.userInfo)")
            
            self.privateContext.performBlock({ () -> Void in
                var privateError: NSError?
                
                assert(self.privateContext.save(&error), "Failed to save private context: \(privateError!.localizedDescription)\n\(privateError!.userInfo)")
            })
        }
    }
    
    func defaultConference() -> Conference? {
        var fetchRequest = NSFetchRequest(entityName: "Conference")
        fetchRequest.predicate = NSPredicate(format: "isDefault == %@", true)
        
        var error: NSError?
        var result = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
        
        if let unwrappedError = error {
            NSLog("Error fetching default conference: %@", unwrappedError)
            
            return nil
        }
        
        return result?.first as! Conference?
    }
    
    func conferenceWithID(conferenceID: Int) -> Conference? {
        var fetchRequest = NSFetchRequest(entityName: "Conference")
        fetchRequest.predicate = NSPredicate(format: "conferenceID == %d", conferenceID)
        
        var error: NSError?
        var result = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
        
        if let unwrappedError = error {
            NSLog("Error fetching conference: %@", unwrappedError)
            
            return nil
        }
        
        return result?.first as! Conference?
    }
    
    func presenterWithID(presenterID: Int) -> Presenter? {
        var fetchRequest = NSFetchRequest(entityName: "Presenter")
        fetchRequest.predicate = NSPredicate(format: "presenterID == %d", presenterID)
        
        var error: NSError?
        var result = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
        
        if let unwrappedError = error {
            NSLog("Error fetching presenter: %@", unwrappedError)
            
            return nil
        }
        
        return result?.first as! Presenter?
    }
    
    func lectureWithID(lectureID: String) -> Lecture? {
        var fetchRequest = NSFetchRequest(entityName: "Lecture")
        fetchRequest.predicate = NSPredicate(format: "lectureID == %@", lectureID)
        
        var error: NSError?
        var result = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
        
        if let unwrappedError = error {
            NSLog("Error fetching lecture: %@", unwrappedError)
            
            return nil
        }
        
        return result?.first as! Lecture?
    }
    
    func roomWithID(roomID: Int) -> Room? {
        var fetchRequest = NSFetchRequest(entityName: "Room")
        fetchRequest.predicate = NSPredicate(format: "roomID == %d", roomID)
        
        var error: NSError?
        var result = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
        
        if let unwrappedError = error {
            NSLog("Error fetching room: %@", unwrappedError)
            
            return nil
        }
        
        return result?.first as! Room?
    }
    
    func changeFavoriteStatusOf(lectureID: String) -> Lecture? {
        var lecture = self.lectureWithID(lectureID)
        
        if let unwrappedLecture = lecture {
            unwrappedLecture.isFavorite = NSNumber(bool: !unwrappedLecture.isFavorite.boolValue)
            self.save()
            
            return unwrappedLecture
        }
        
        return nil
    }
}
