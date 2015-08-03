//
//  LectureCell.swift
//  IT Tour
//
//  Created by Vladimir Savov on 3.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import UIKit

class LectureCell: UITableViewCell {

    // MARK: - Properties
    
    var lectureID: String = ""
    
    // MARK: - View lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.lectureID = ""
    }
    
    // MARK: - Public methods
    
    func loadDataFrom(lecture: Lecture) {
        self.lectureID = lecture.lectureID
    }
    
    // MARK: - Private methods
    
    
}
