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
        
        if fileManager.fileExistsAtPath(folderPath) {
            var error: NSError?
            
            assert(fileManager.createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil, error: &error), "Failed to create CoreData folder \(folderPath), error \(error!)")
        }
        
        let storeURL = NSURL(fileURLWithPath: folderPath)!.URLByAppendingPathComponent("ITTour.sqlite")
        
        var error: NSError?
        var store = self.persistanceStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error)
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
    
}
