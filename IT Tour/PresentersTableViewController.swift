//
//  PresentersTableViewController.swift
//  IT Tour
//
//  Created by Vladimir Savov on 2.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import CoreData
import UIKit

class PresentersTableViewController: BaseTableViewController {

    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let count = self.fetchedResultsController.sections?.count {
            return count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        let presenter = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Presenter
        
        return presenter.firstLetter
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo: NSFetchedResultsSectionInfo? = self.fetchedResultsController.sections?[section] as! NSFetchedResultsSectionInfo?
        
        if let count = sectionInfo?.objects.count {
            return count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let presenter = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Presenter
        
        let cell = tableView.dequeueReusableCellWithIdentifier("presenterCell", forIndexPath: indexPath) as! PresenterCell
        
        cell.loadDataFrom(presenter)
        
        return cell
    }
    
    // MARK: - Private methods
    
    override func createFetchedResultsController() -> NSFetchedResultsController {
        var fetchRequest = NSFetchRequest(entityName: "Presenter")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext, sectionNameKeyPath: "firstLetter", cacheName: nil)
        
        var error : NSError?
        
        if !fetchedResultsController.performFetch(&error) {
            NSLog("Failed to load presenters with error \(error)")
        }
        
        return fetchedResultsController
    }
}
