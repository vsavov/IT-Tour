//
//  BaseTableViewController.swift
//  IT Tour
//
//  Created by Vladimir Savov on 3.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import CoreData
import UIKit

typealias TableViewChanges = Dictionary<NSFetchedResultsChangeType, Array<NSIndexPath>>

class BaseTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        return self.createFetchedResultsController()
        }()
    
    private var tableViewUpdates : TableViewChanges = {
        var changes = TableViewChanges()
        
        changes[.Insert] = Array<NSIndexPath>()
        changes[.Delete] = Array<NSIndexPath>()
        changes[.Update] = Array<NSIndexPath>()
        
        return changes
        }()
    
    private var tableViewSectionUpdates : Dictionary<NSFetchedResultsChangeType, NSIndexSet> = {
        var changes = Dictionary<NSFetchedResultsChangeType, NSIndexSet>()
        
        changes[.Insert] = NSIndexSet()
        changes[.Delete] = NSIndexSet()
        
        return changes
        }()
    
    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var error : NSError?
        
        if self.fetchedResultsController.performFetch(&error) == false {
            NSLog("Failed to load current book with error \(error)")
        }
        
        self.tableView.reloadData()
        
        self.fetchedResultsController.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.fetchedResultsController.delegate = nil
    }
    
    // MARK: - NSFetchedResultsControllerDelegate methods
    
    internal func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch(type) {
        case .Insert:
            self.tableViewUpdates[.Insert]?.append(newIndexPath!)
            
            break
        case .Delete:
            self.tableViewUpdates[.Delete]?.append(indexPath!)
            
            break
        case .Update:
            self.tableViewUpdates[.Update]?.append(indexPath!)
            
            break
        default:
            break
        }
    }
    
    internal func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch(type) {
        case .Insert:
            var temp = NSMutableIndexSet(indexSet: self.tableViewSectionUpdates[.Insert]!)
            temp.addIndex(sectionIndex)
            self.tableViewSectionUpdates[.Insert] = NSIndexSet(indexSet: temp)
            
            break
        case .Delete:
            var temp = NSMutableIndexSet(indexSet: self.tableViewSectionUpdates[.Delete]!)
            temp.addIndex(sectionIndex)
            self.tableViewSectionUpdates[.Delete] = NSIndexSet(indexSet: temp)
            
            break
        default:
            break
        }
    }
    
    
    internal func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.resetChangesTracking()
    }
    
    internal func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if self.view.window == nil {
            self.resetChangesTracking()
            
            return
        }
        
        let inserted = self.tableViewUpdates[.Insert]!
        let deleted  = self.tableViewUpdates[.Delete]!
        let updated  = self.tableViewUpdates[.Update]!
        
        self.tableView.beginUpdates()
        
        if self.tableViewSectionUpdates[.Insert]?.count > 0 {
            self.tableView.insertSections(self.tableViewSectionUpdates[.Insert]!, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        if self.tableViewSectionUpdates[.Delete]?.count > 0 {
            self.tableView.insertSections(self.tableViewSectionUpdates[.Delete]!, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        if deleted.count > 0 {
            self.tableView.deleteRowsAtIndexPaths(deleted, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        if inserted.count > 0 {
            self.tableView.insertRowsAtIndexPaths(inserted, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        if updated.count > 0 {
            self.tableView.reloadRowsAtIndexPaths(updated, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        self.tableView.endUpdates()
        
        self.resetChangesTracking()
    }

    // MARK: - Private methods
    
    internal func createFetchedResultsController() -> NSFetchedResultsController {
        fatalError("This method has to be overriden!")
    }
    
    private func resetChangesTracking() {
        self.tableViewUpdates[.Insert]?.removeAll(keepCapacity: false)
        self.tableViewUpdates[.Delete]?.removeAll(keepCapacity: false)
        self.tableViewUpdates[.Update]?.removeAll(keepCapacity: false)
        self.tableViewSectionUpdates[.Insert] = NSIndexSet()
        self.tableViewSectionUpdates[.Delete] = NSIndexSet()
    }
}
