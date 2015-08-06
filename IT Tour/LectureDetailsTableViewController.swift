//
//  LectureDetailsTableViewController.swift
//  IT Tour
//
//  Created by Vladimir Savov on 5.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import CoreDataFramework
import UIKit

class LectureDetailsTableViewController: UITableViewController {

    // MARK: - Properties
    
    @IBOutlet weak var lectureNameLabel: UILabel!
    @IBOutlet weak var lectureTimeAndLocationLabel: UILabel!
    @IBOutlet weak var lectureConferenceNameLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    var lecture: Lecture? {
        didSet {
            if let presenters = self.lecture?.presenters {
                self.presenters = self.lecture?.presenters?.allObjects as! [Presenter]
            } else {
                self.presenters = []
            }
            
            if self.view.superview != nil {
                self.updateUI()
            }
        }
    }
    
    private var presenters: [Presenter] = []
    
    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.title = NSLocalizedString("Lecture", comment: "Title for lecture details screen")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUI()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPresenterInfo" {
            let destinationController = segue.destinationViewController as! PresenterDetailsTableViewController
            let castedSender = sender as! LecturePresenterCell
            
            var presenter = MainManager.sharedInstance.presenterWithID(castedSender.presenterID)
            destinationController.presenter = presenter
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let lecture = self.lecture {
            switch section {
            case 0:
                return self.presenters.count
            case 1:
                var numberOfRows = 1
                
                if let videoURL = lecture.videoURL {
                    numberOfRows++
                }
                
                if let slidesURL = lecture.presentationURL {
                    numberOfRows++
                }
                
                return numberOfRows
            default:
                return 0
            }
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        switch indexPath.section {
        case 0:
            cell = prepareCellForPresenterAt(indexPath)
        default:
            cell = prepareCellForOptionsAt(indexPath)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section != 1 {
            return
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.changeFavoriteStatus()
        } else if indexPath.row == 1 && self.lecture!.videoURL != nil {
            self.openVideoLink()
        } else {
            self.openPresentationLink()
        }
    }
    
    // MARK: - Private methods
    
    private func prepareCellForPresenterAt(indexPath: NSIndexPath) -> UITableViewCell {
        let presenter = self.presenters[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("lecturePresenterCell", forIndexPath: indexPath) as! LecturePresenterCell
        
        cell.loadDataFrom(presenter)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    private func prepareCellForOptionsAt(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("optionsCell", forIndexPath: indexPath) as! LectureOptionsCell
        
        if indexPath.row == 0 {
            var localizedString: String
            
            cell.shouldShowSeparator = false
            
            if self.lecture!.isFavorite.boolValue {
                localizedString = NSLocalizedString("Remove from Favorites", comment: "Option in Lecture detail screen")
            } else {
                localizedString = NSLocalizedString("Add to Favorites", comment: "Option in Lecture detail screen")
            }
            
            cell.textLabel!.text = localizedString
        } else if indexPath.row == 1 && self.lecture!.videoURL != nil {
            cell.textLabel!.text = NSLocalizedString("Video", comment: "Option in Lecture detail screen")
        } else {
            cell.textLabel!.text = NSLocalizedString("Presentation", comment: "Option in Lecture detail screen")
        }
        
        return cell
    }
    
    private func updateUI() {
        self.lectureNameLabel.text = self.lecture?.lectureName
        self.lectureTimeAndLocationLabel.text = self.generateTimeAndLocationStringFrom(self.lecture)
        self.lectureConferenceNameLabel.text = self.lecture?.conference?.conferenceName
        
        if let unwrappedLecture = self.lecture {
            self.favoriteImageView.hidden = !unwrappedLecture.isFavorite.boolValue
        } else {
            self.favoriteImageView.hidden = true
        }
        
        let size = self.tableView.tableHeaderView!.systemLayoutSizeFittingSize(CGSize(width: self.tableView.frame.width, height: CGFloat.max), withHorizontalFittingPriority: 1000.0, verticalFittingPriority: 1.0)
        self.tableView.tableHeaderView!.frame = CGRect(origin: self.tableView.tableHeaderView!.frame.origin, size: size)
        
        self.tableView.reloadData()
    }
    
    private func generateTimeAndLocationStringFrom(lecture: Lecture?) -> String {
        if lecture == nil {
            return ""
        }
        
        if let unwrappedStartTime = lecture?.startTime, let unwrappedEndTime = lecture?.endTime {
            let flags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour
            let startTimeComponents = NSCalendar.currentCalendar().components(flags, fromDate: unwrappedStartTime)
            let endTimeComponents = NSCalendar.currentCalendar().components(flags, fromDate: unwrappedEndTime)
            
            let dateFormatter = MainManager.hourDateFormatter
            
            let startTimeHours = dateFormatter.stringFromDate(unwrappedStartTime)
            let startTimeMinutes = self.getProperTimeStringFrom(startTimeComponents.minute)
            
            let endTimeHours = dateFormatter.stringFromDate(unwrappedEndTime)
            let endTimeMinutes = self.getProperTimeStringFrom(endTimeComponents.minute)
            
            if let roomName = lecture?.room?.roomName {
                return "\(startTimeHours):\(startTimeMinutes)-\(endTimeHours):\(endTimeMinutes)   \(roomName)"
            }
            
            return "\(startTimeHours):\(startTimeMinutes)-\(endTimeHours):\(endTimeMinutes)"
        }
        
        if let roomName = lecture?.room?.roomName {
            return roomName
        }
        
        return ""
    }
    
    private func getProperTimeStringFrom(integer: Int) -> String {
        if integer < 10 {
            return "0\(integer)"
        }
        
        return "\(integer)"
    }
    
    private func changeFavoriteStatus() {
        self.favoriteImageView.hidden = !self.favoriteImageView.hidden
        self.lecture = MainManager.sharedInstance.changeFavoriteStatusOf(lecture!.lectureID!)
        
        self.tableView.beginUpdates()
        
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        self.tableView.endUpdates()
    }
    
    private func openVideoLink() {
        let url = NSURL(string: self.lecture!.videoURL!)!
        
        UIApplication.sharedApplication().openURL(url)
    }
    
    private func openPresentationLink() {
        let url = NSURL(string: self.lecture!.presentationURL!)!
        
        UIApplication.sharedApplication().openURL(url)
    }
}
