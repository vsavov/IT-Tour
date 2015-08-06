//
//  MainListController.swift
//  IT Tour
//
//  Created by Vladimir Savov on 6.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import CoreDataFramework
import Foundation
import WatchKit

class MainListController: WKInterfaceController {

    // MARK: - Properties
    
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var emptyPlaceholderGroup: WKInterfaceGroup!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var descriptionLabel: WKInterfaceLabel!

    private var lectures: [Lecture] = []
    
    // MARK: - View lifecycle methods
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        super.willActivate()
        
        self.lectures = MainManager.sharedInstance.getFavoriteLectures()
        
        self.titleLabel.setText(NSLocalizedString("No Favorite Lectures", comment: ""))
        self.descriptionLabel.setText(NSLocalizedString("Mark lectures as Favorite on your iPhone and they will appear hear", comment: ""))
        
        self.table.setNumberOfRows(self.lectures.count, withRowType: "LectureRow")
        
        for index in 0 ..< self.lectures.count {
            let row = self.table.rowControllerAtIndex(index) as! LectureRow
            let lecture = self.lectures[index]
            
            row.lectureNameLabel.setText(lecture.lectureName)
        }
        
        self.emptyPlaceholderGroup.setHidden(self.lectures.count != 0)
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    // MARK: - Table related methods
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        self.pushControllerWithName("LectureDetailsController", context: self.lectures[rowIndex])
    }
}
