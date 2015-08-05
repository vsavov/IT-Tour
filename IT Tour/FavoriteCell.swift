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
        self.lectureID = lecture.lectureID
        self.lectureNameLabel.text = lecture.lectureName
        self.lectureTimeAndLocationLabel.text = self.generateTimeAndLocationStringFrom(lecture)
        self.lectureConferenceNameLabel.text = lecture.conference.conferenceName
        self.favoriteImageView.hidden = !lecture.isFavorite.boolValue
    }
    
    // MARK: - Private methods
    
    private func generateTimeAndLocationStringFrom(lecture: Lecture) -> String {
        let flags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour
        let startTimeComponents = NSCalendar.currentCalendar().components(flags, fromDate: lecture.startTime)
        let endTimeComponents = NSCalendar.currentCalendar().components(flags, fromDate: lecture.endTime)
        
        let dateFormatter = MainManager.hourDateFormatter
        
        let startTimeHours = dateFormatter.stringFromDate(lecture.startTime)
        let startTimeMinutes = self.getProperTimeStringFrom(startTimeComponents.minute)
        
        let endTimeHours = dateFormatter.stringFromDate(lecture.endTime)
        let endTimeMinutes = self.getProperTimeStringFrom(endTimeComponents.minute)
        
        if let room = lecture.room {
            return "\(startTimeHours):\(startTimeMinutes)-\(endTimeHours):\(endTimeMinutes)   \(room.roomName)"
        }
        
        return "\(startTimeHours):\(startTimeMinutes)-\(endTimeHours):\(endTimeMinutes)"
    }
    
    private func getProperTimeStringFrom(integer: Int) -> String {
        if integer < 10 {
            return "0\(integer)"
        }
        
        return "\(integer)"
    }
}
