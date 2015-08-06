//
//  LectureExtension.swift
//  IT Tour
//
//  Created by Vladimir Savov on 5.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import Foundation

extension Lecture {
    
    public var startingHour: String? {
        let dateFormatter = MainManager.hourDateFormatter
        
        if let startTime = self.startTime {
            return dateFormatter.stringFromDate(startTime)
        }
        
        return nil
    }
}