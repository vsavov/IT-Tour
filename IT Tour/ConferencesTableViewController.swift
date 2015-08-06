//
//  ConferencesTableViewController.swift
//  IT Tour
//
//  Created by Vladimir Savov on 2.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import CoreData
import CoreDataFramework
import UIKit

class ConferencesTableViewController: BaseTableViewController {

    // MARK: - Properties
    
    var firstTimePresented: Bool = true
    
    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 80
        
        self.title = NSLocalizedString("Conferences", comment: "Title for conferences screen")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.firstTimePresented {
            var defaultConference = MainManager.sharedInstance.defaultConference()
            
            if let unwrappedDefaultConference = defaultConference {
                let cell = tableView.dequeueReusableCellWithIdentifier("conferenceCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ConferenceCell
                
                cell.loadDataFrom(unwrappedDefaultConference)
                
                self.performSegueWithIdentifier("ShowConferenceSchedule", sender: cell)
            }
        }
        
        self.firstTimePresented = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowConferenceSchedule" {
            let destinationController = segue.destinationViewController as! LecturesTableViewController
            let castedSender = sender as! ConferenceCell
            
            destinationController.conferenceID = castedSender.conferenceID
            destinationController.title = castedSender.conferenceNameLabel.text
        }
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
        let conference = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Conference
        
        return conference.year
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
        let conference: Conference
        
        if self.searchController!.active {
            conference = self.searchResults[indexPath.row] as! Conference
        } else {
            conference = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Conference
        }
        
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
    
    override func searchTextUpdatedTo(searchString: String) {
        var array = self.fetchedResultsController.fetchedObjects as! [Conference]
        
        if count(searchString) > 0 {
            array = array.filter { (conference) -> Bool in
                let nameRange = conference.conferenceName?.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil)
                
                return nameRange != nil
            }
        }
        
        self.searchResults = array
    }
}
