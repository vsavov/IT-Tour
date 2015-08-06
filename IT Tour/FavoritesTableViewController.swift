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
    
    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 82
        
        self.title = NSLocalizedString("Favorites", comment: "Title for favorites screen")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowLectureDetails" {
            let destinationController = segue.destinationViewController as! LectureDetailsTableViewController
            let castedSender = sender as! FavoriteCell
            
            var lecture = MainManager.sharedInstance.lectureWithID(castedSender.lectureID)
            destinationController.lecture = lecture
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController!.active {
            return self.searchResults.count
        }
        
        if let count = self.fetchedResultsController.fetchedObjects?.count {
            return count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var lecture: Lecture
        
        if self.searchController!.active {
            lecture = self.searchResults[indexPath.row] as! Lecture
        } else {
            lecture = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Lecture
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteCell", forIndexPath: indexPath) as! FavoriteCell
        
        cell.loadDataFrom(lecture)
        
        return cell
    }
    
    // MARK: - Private methods
    
    override func createFetchedResultsController() -> NSFetchedResultsController {
        var fetchRequest = NSFetchRequest(entityName: "Lecture")
        fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", true)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lectureName", ascending: true)]
        fetchRequest.relationshipKeyPathsForPrefetching = ["conference", "room"]
        
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        var error : NSError?
        
        if fetchedResultsController.performFetch(&error) == false {
            NSLog("Failed to load favorite lectures with error \(error)")
        }
        
        return fetchedResultsController
    }
    
    override func searchTextUpdatedTo(searchString: String) {
        var array = self.fetchedResultsController.fetchedObjects as! [Lecture]
        
        if count(searchString) > 0 {
            array = array.filter { (lecture) -> Bool in
                let topicRange = lecture.lectureName?.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil)
                
                return topicRange != nil
            }
        }
        
        self.searchResults = array
    }
}
