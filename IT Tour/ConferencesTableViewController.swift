//
//  ConferencesTableViewController.swift
//  IT Tour
//
//  Created by Vladimir Savov on 2.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import CoreData
import UIKit

class ConferencesTableViewController: BaseTableViewController {

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
        if let count = self.fetchedResultsController.sections?.count {
            return count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        let conference = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Conference
        
        return conference.year
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo: NSFetchedResultsSectionInfo? = self.fetchedResultsController.sections?[section] as! NSFetchedResultsSectionInfo?
        
        if let count = sectionInfo?.objects.count {
            return count
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let conference = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Conference
        
        let cell = tableView.dequeueReusableCellWithIdentifier("conferenceCell", forIndexPath: indexPath) as! ConferenceCell

        cell.loadDataFrom(conference)

        return cell
    }
    
    // MARK: - Private methods
    
    override func createFetchedResultsController() -> NSFetchedResultsController {
        var fetchRequest = NSFetchRequest(entityName: "Conference")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext, sectionNameKeyPath: "year", cacheName: nil)
        
        var error : NSError?
        
        if fetchedResultsController.performFetch(&error) == false {
            NSLog("Failed to load current book with error \(error)")
        }
        
        return fetchedResultsController
    }
}
