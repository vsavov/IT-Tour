//
//  FavoriteCell.swift
//  IT Tour
//
//  Created by Vladimir Savov on 3.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var lectureNameLabel: UILabel!
    @IBOutlet weak var lectureTimeAndLocationLabel: UILabel!
    @IBOutlet weak var lectureConferenceNameLabel: UILabel!
    
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
        self.lectureID = lecture.lectureID
        self.lectureNameLabel.text = lecture.lectureName
        self.lectureTimeAndLocationLabel.text = self.generateTimeAndLocationStringFrom(lecture)
        self.lectureConferenceNameLabel.text = lecture.conference.conferenceName
    }
    
    // MARK: - Private methods
    
    func generateTimeAndLocationStringFrom(lecture: Lecture) -> String {
        let flags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour
        let startTimeComponents = NSCalendar.currentCalendar().components(flags, fromDate: lecture.startTime)
        let endTimeComponents = NSCalendar.currentCalendar().components(flags, fromDate: lecture.endTime)
        
        let startTimeMinutes = self.getProperTimeStringFrom(startTimeComponents.minute)
        let startTimeHours = self.getProperTimeStringFrom(startTimeComponents.hour)
        let endTimeMinutes = self.getProperTimeStringFrom(endTimeComponents.minute)
        let endTimeHours = self.getProperTimeStringFrom(endTimeComponents.hour)
        
        return "\(startTimeHours):\(startTimeMinutes)-\(endTimeHours):\(endTimeMinutes)   \(lecture.room.roomName)"
    }
    
    func getProperTimeStringFrom(integer: Int) -> String {
        if integer < 10 {
            return "0\(integer)"
        }
        
        return "\(integer)"
    }
}
