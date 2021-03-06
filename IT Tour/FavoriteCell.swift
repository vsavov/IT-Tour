//
//  FavoriteCell.swift
//  IT Tour
//
//  Created by Vladimir Savov on 3.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import CoreDataFramework
import UIKit

class FavoriteCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var lectureNameLabel: UILabel!
    @IBOutlet weak var lectureTimeAndLocationLabel: UILabel!
    @IBOutlet weak var lectureConferenceNameLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    var lectureID: String = ""
    
    // MARK: - View lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.lectureID = ""
        self.lectureNameLabel.text = nil
        self.lectureTimeAndLocationLabel.text = nil
        self.lectureConferenceNameLabel.text = nil
    }
    
    // MARK: - Public methods
    
    func loadDataFrom(lecture: Lecture) {
        if let lectureID = lecture.lectureID {
            self.lectureID = lectureID
        } else {
            self.prepareForReuse()
            
            return
        }
        
        self.lectureNameLabel.text = lecture.lectureName
        self.lectureTimeAndLocationLabel.text = self.generateTimeAndLocationStringFrom(lecture)
        self.lectureConferenceNameLabel.text = lecture.conference?.conferenceName
        self.favoriteImageView.hidden = !lecture.isFavorite.boolValue
    }
    
    // MARK: - Private methods
    
    private func generateTimeAndLocationStringFrom(lecture: Lecture) -> String {
        if let unwrappedStartTime = lecture.startTime, let unwrappedEndTime = lecture.endTime {
            let flags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour
            let startTimeComponents = NSCalendar.currentCalendar().components(flags, fromDate: unwrappedStartTime)
            let endTimeComponents = NSCalendar.currentCalendar().components(flags, fromDate: unwrappedEndTime)
            
            let dateFormatter = MainManager.hourDateFormatter
            
            let startTimeHours = dateFormatter.stringFromDate(unwrappedStartTime)
            let startTimeMinutes = self.getProperTimeStringFrom(startTimeComponents.minute)
            
            let endTimeHours = dateFormatter.stringFromDate(unwrappedEndTime)
            let endTimeMinutes = self.getProperTimeStringFrom(endTimeComponents.minute)
            
            if let roomName = lecture.room?.roomName {
                return "\(startTimeHours):\(startTimeMinutes)-\(endTimeHours):\(endTimeMinutes)   \(roomName)"
            }
            
            return "\(startTimeHours):\(startTimeMinutes)-\(endTimeHours):\(endTimeMinutes)"
        }
        
        if let roomName = lecture.room?.roomName {
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
}
