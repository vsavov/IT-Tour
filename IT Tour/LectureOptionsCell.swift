//
//  LectureOptionsCell.swift
//  IT Tour
//
//  Created by Vladimir Savov on 6.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import UIKit

class LectureOptionsCell: UITableViewCell {

    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var shouldShowSeparator = true {
        didSet {
            self.separatorView.hidden = !self.shouldShowSeparator
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.heightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
    }
}
