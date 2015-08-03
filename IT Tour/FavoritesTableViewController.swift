//
//  FavoritesTableViewController.swift
//  IT Tour
//
//  Created by Vladimir Savov on 2.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import CoreData
import UIKit

class FavoritesTableViewController: BaseTableViewController {

    // MARK: - Properties
    
    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.fetchedResultsController.fetchedObjects?.count {
            return count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let lecture = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Lecture
        
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteCell", forIndexPath: indexPath) as! FavoriteCell
        
        cell.loadDataFrom(lecture)
        
        return cell
    }
    
    // MARK: - Private methods
    
    override func createFetchedResultsController() -> NSFetchedResultsController {
        var fetchRequest = NSFetchRequest(entityName: "Lecture")
        fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", true)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
        fetchRequest.relationshipKeyPathsForPrefetching = ["conference", "room"]
        
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        var error : NSError?
        
        if fetchedResultsController.performFetch(&error) == false {
            NSLog("Failed to load favorite lectures with error \(error)")
        }
        
        return fetchedResultsController
    }
}
