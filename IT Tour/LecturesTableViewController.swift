//
//  LecturesTableViewController.swift
//  IT Tour
//
//  Created by Vladimir Savov on 3.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import CoreData
import UIKit

class LecturesTableViewController: BaseTableViewController {

    // MARK: - Properties
    
    @IBOutlet weak var lectureNameLabel: UILabel!
    @IBOutlet weak var lectureTimeAndLocationLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    var conferenceID: Int = -1
    
    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 79
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowLectureDetails" {
            let destinationController = segue.destinationViewController as! LectureDetailsTableViewController
            let castedSender = sender as! LectureCell
            
            var lecture = MainManager.sharedInstance.lectureWithID(castedSender.lectureID)
            destinationController.lecture = lecture
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
        let lecture = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Lecture
        
        return self.generateSectionHeaderFrom(lecture.startingHour)
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
        var lecture: Lecture
        
        if self.searchController!.active {
            lecture = self.searchResults[indexPath.row] as! Lecture
        } else {
            lecture = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Lecture
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("lectureCell", forIndexPath: indexPath) as! LectureCell
        
        cell.loadDataFrom(lecture)
        
        return cell
    }
    
    // MARK: - Private methods
    
    override func createFetchedResultsController() -> NSFetchedResultsController {
        var fetchRequest = NSFetchRequest(entityName: "Lecture")
        fetchRequest.predicate = NSPredicate(format: "conference.conferenceID == %d", self.conferenceID)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true), NSSortDescriptor(key: "room.roomName", ascending: true)]
        fetchRequest.relationshipKeyPathsForPrefetching = ["room"]
        
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext, sectionNameKeyPath: "startingHour", cacheName: nil)
        
        var error : NSError?
        
        if !fetchedResultsController.performFetch(&error) {
            NSLog("Failed to load lectures with error \(error)")
        }
        
        return fetchedResultsController
    }
    
    override func searchTextUpdatedTo(searchString: String) {
        var array = self.fetchedResultsController.fetchedObjects as! [Lecture]
        
        if count(searchString) > 0 {
            array = array.filter { (lecture) -> Bool in
                let topicRange = lecture.lectureName.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil)
                
                return topicRange != nil
            }
        }
        
        self.searchResults = array
    }
    
    private func generateSectionHeaderFrom(hours: String) -> String {
        return "\(hours):00"
    }
}
