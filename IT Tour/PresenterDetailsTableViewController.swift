//
//  PresenterDetailsTableViewController.swift
//  IT Tour
//
//  Created by Vladimir Savov on 5.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import UIKit

class PresenterDetailsTableViewController: UITableViewController {

    // MARK: - Properties
    
    @IBOutlet weak var presenterImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var shortBioLabel: UILabel!
    
    var presenter: Presenter? {
        didSet {
            if self.view.superview != nil {
                self.updateUI()
            }
        }
    }
    
    private var lectures: [Lecture] = []
    
    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 79
        
        self.title = NSLocalizedString("Presenter", comment: "Title for presenter details screen")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenterImageView.layer.cornerRadius = self.presenterImageView.frame.size.width / 2.0
        self.presenterImageView.clipsToBounds = true
        
        self.updateUI()
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Lectures", comment: "Title for lectures section in presenter's details screen")
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lectures.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var lecture = self.lectures[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("lectureCell", forIndexPath: indexPath) as! FavoriteCell
        
        cell.loadDataFrom(lecture)
        
        return cell
    }
    
    // MARK: - Private methods
    
    private func updateUI() {
        self.presenterImageView.image = self.presenter?.getImage()
        
        self.firstNameLabel.text = self.presenter?.firstName
        self.lastNameLabel.text = self.presenter?.lastName
        self.shortBioLabel.text = self.presenter?.shortBio
        
        if let lectures = self.presenter?.lectures {
            self.lectures = lectures.allObjects as! [Lecture]
        } else {
            self.lectures = []
        }
        
        let size = self.tableView.tableHeaderView!.systemLayoutSizeFittingSize(CGSize(width: self.tableView.frame.width, height: CGFloat.max), withHorizontalFittingPriority: 1000.0, verticalFittingPriority: 1.0)
        self.tableView.tableHeaderView!.frame = CGRect(origin: self.tableView.tableHeaderView!.frame.origin, size: size)
        
        self.tableView.reloadData()
    }
}
