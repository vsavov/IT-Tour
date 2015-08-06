//
//  PresentersTableViewController.swift
//  IT Tour
//
//  Created by Vladimir Savov on 2.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import CoreData
import CoreDataFramework
import UIKit

class PresentersTableViewController: BaseTableViewController {

    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 57
        
        self.title = NSLocalizedString("Presenters", comment: "Title for presenters screen")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPresenterInfo" {
            let destinationController = segue.destinationViewController as! PresenterDetailsTableViewController
            let castedSender = sender as! PresenterCell
            
            var presenter = CoreDataFramework.MainManager.sharedInstance.presenterWithID(castedSender.presenterID)
            destinationController.presenter = presenter
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.searchController!.active {
            return 1
        }
        
        if let count = self.fetchedResultsController.sections?.count {
            return count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.searchController!.active {
            return nil
        }
        
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        let presenter = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Presenter
        
        return presenter.firstLetter
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        if self.searchController!.active {
            return nil
        }
        
        var sectionIndexTitles = [UITableViewIndexSearch]
        
        let sections = self.fetchedResultsController.sections as! [NSFetchedResultsSectionInfo]
        
        for sectionInfo in sections {
            sectionIndexTitles.append(sectionInfo.name!)
        }
        
        return sectionIndexTitles
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if self.searchController!.active {
            return NSNotFound
        }
        
        if index > 0 {
            return index - 1
        }
        
        let searchBarFrame = self.searchController!.searchBar.frame
        self.tableView.scrollRectToVisible(searchBarFrame, animated: false)
        
        return NSNotFound
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController!.active {
            return self.searchResults.count
        }
        
        let sectionInfo: NSFetchedResultsSectionInfo? = self.fetchedResultsController.sections?[section] as! NSFetchedResultsSectionInfo?
        
        if let count = sectionInfo?.objects.count {
            return count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let presenter: Presenter
        
        if self.searchController!.active {
            presenter = self.searchResults[indexPath.row] as! Presenter
        } else {
            presenter = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Presenter
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("presenterCell", forIndexPath: indexPath) as! PresenterCell
        
        cell.loadDataFrom(presenter)
        
        return cell
    }
    
    // MARK: - Private methods
    
    override func createFetchedResultsController() -> NSFetchedResultsController {
        var fetchRequest = NSFetchRequest(entityName: "Presenter")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true), NSSortDescriptor(key: "lastName", ascending: true)]
        
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext, sectionNameKeyPath: "firstLetter", cacheName: nil)
        
        var error : NSError?
        
        if !fetchedResultsController.performFetch(&error) {
            NSLog("Failed to load presenters with error \(error)")
        }
        
        return fetchedResultsController
    }
    
    override func searchTextUpdatedTo(searchString: String) {
        var array = self.fetchedResultsController.fetchedObjects as! [Presenter]
        
        if count(searchString) > 0 {
            array = array.filter { (presenter) -> Bool in
                let firstNameRange = presenter.firstName?.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil)
                let lastNameRange = presenter.lastName?.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil)
                
                return (firstNameRange != nil || lastNameRange != nil)
            }
        }
        
        self.searchResults = array
    }
}
