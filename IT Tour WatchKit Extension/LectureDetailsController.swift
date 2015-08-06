//
//  LectureDetailsController.swift
//  IT Tour
//
//  Created by Vladimir Savov on 6.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import CoreDataFramework
import Foundation
import WatchKit

class LectureDetailsController: WKInterfaceController {

    // MARK: - Properties
    
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var favoriteButton: WKInterfaceButton!
    
    private var lecture: Lecture?
    
    // MARK: - Action methods
    
    @IBAction func favoriteButtonPressed() {
        if let lecture = self.lecture {
            self.lecture = MainManager.sharedInstance.changeFavoriteStatusOf(lecture.lectureID!)
            
            self.updateButtonLabel()
        }
    }
    
    // MARK: - View lifecycle methods
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.lecture = context as? Lecture
        
        let presenters = self.lecture!.presenters?.allObjects as? [Presenter]
        
        var rowTypes = ["LectureDetailsHeaderRow"]
        
        if let unwrappedPresenters = presenters {
            for presenter in unwrappedPresenters {
                rowTypes.append("LectureDetailsPresenterRow")
            }
        }
        
        self.table.setRowTypes(rowTypes)
        
        let row = self.table.rowControllerAtIndex(0) as! LectureDetailsHeaderRow
        row.lectureNameLabel.setText(self.lecture?.lectureName)
        row.lectureTimeLabel.setText(self.generateTimeString(self.lecture!))
        row.roomNameLabel.setText(self.generateRoomString(self.lecture!))
        
        if let unwrappedPresenters = presenters {
            var index = 1
            
            for presenter in unwrappedPresenters {
                let presenterRow = self.table.rowControllerAtIndex(index) as! LectureDetailsPresenterRow
                presenterRow.imageGroup.setBackgroundImage(presenter.getImage())
                presenterRow.presenterNameLabel.setText("\(presenter.firstName!) \(presenter.lastName!)")
                
                index++
            }
        }
        
        self.updateButtonLabel()
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    // MARK: - Private methods
    
    private func updateButtonLabel() {
        var buttonTitle: String = ""
        
        if self.lecture!.isFavorite.boolValue {
            buttonTitle = NSLocalizedString("Remove from Favorites", comment: "")
        } else {
            buttonTitle = NSLocalizedString("Add to Favorites", comment: "")
        }
        
        self.favoriteButton.setTitle(buttonTitle)
    }
    
    private func generateTimeString(lecture: Lecture) -> String? {
        if let unwrappedStartTime = lecture.startTime, let unwrappedEndTime = lecture.endTime {
            let flags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour
            let startTimeComponents = NSCalendar.currentCalendar().components(flags, fromDate: unwrappedStartTime)
            let endTimeComponents = NSCalendar.currentCalendar().components(flags, fromDate: unwrappedEndTime)
            
            let dateFormatter = MainManager.hourDateFormatter
            
            let startTimeHours = dateFormatter.stringFromDate(unwrappedStartTime)
            let startTimeMinutes = self.getProperTimeStringFrom(startTimeComponents.minute)
            
            let endTimeHours = dateFormatter.stringFromDate(unwrappedEndTime)
            let endTimeMinutes = self.getProperTimeStringFrom(endTimeComponents.minute)
            
            return "\(startTimeHours):\(startTimeMinutes)-\(endTimeHours):\(endTimeMinutes)"
        }
        
        return nil
    }
    
    private func generateRoomString(lecture: Lecture) -> String? {
        if let roomName = lecture.room?.roomName {
            return roomName
        }
        
        return nil
    }
    
    private func getProperTimeStringFrom(integer: Int) -> String {
        if integer < 10 {
            return "0\(integer)"
        }
        
        return "\(integer)"
    }
}
