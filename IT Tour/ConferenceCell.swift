//
//  ConferenceCell.swift
//  IT Tour
//
//  Created by Vladimir Savov on 2.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import UIKit

class ConferenceCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var conferenceNameLabel: UILabel!
    @IBOutlet weak var conferenceTimeLabel: UILabel!
    
    var conferenceID: Int = -1
    
    // MARK: - View lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.logoImageView.image = nil
        self.conferenceNameLabel.text = nil
        self.conferenceTimeLabel.text = nil
        self.conferenceID = -1
    }
    
    // MARK: - Public methods
    
    func loadDataFrom(conference: Conference) {
        if let conferenceID = conference.conferenceID {
            self.conferenceID = conferenceID.integerValue
        } else {
            self.prepareForReuse()
            
            return
        }
        
        self.logoImageView.image = conference.getImage()
        self.conferenceNameLabel.text = conference.conferenceName
        self.conferenceTimeLabel.text = self.generateTimeStringFrom(conference)
    }
    
    // MARK: - Private methods
    
    func generateTimeStringFrom(conference: Conference) -> String {
        if let unwrappedStartDate = conference.startDate, let unwrappedEndDate = conference.endDate {
            let flags = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear
            let startDateComponents = NSCalendar.currentCalendar().components(flags, fromDate: unwrappedStartDate)
            let endDateComponents = NSCalendar.currentCalendar().components(flags, fromDate: unwrappedEndDate)
            
            if startDateComponents.month == endDateComponents.month {
                if startDateComponents.day == endDateComponents.day {
                    return "\(endDateComponents.day).\(endDateComponents.month).\(endDateComponents.year)"
                }
                
                return "\(startDateComponents.day)-\(endDateComponents.day).\(endDateComponents.month).\(endDateComponents.year)"
            }
            
            return "\(startDateComponents.day).\(startDateComponents.month)-\(endDateComponents.day).\(endDateComponents.month).\(endDateComponents.year)"
        }
        
        return ""
    }
}
