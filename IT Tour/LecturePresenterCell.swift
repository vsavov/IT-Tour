//
//  LecturePresenterCell.swift
//  IT Tour
//
//  Created by Vladimir Savov on 5.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import UIKit

class LecturePresenterCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var presenterImageView: UIImageView!
    @IBOutlet weak var presenterNameLabel: UILabel!
    
    var presenterID: Int = -1
    
    // MARK: - View lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.separatorInset = UIEdgeInsetsMake(0.0, CGRectGetWidth(self.bounds)/2.0, 0.0, CGRectGetWidth(self.bounds)/2.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.separatorInset = UIEdgeInsetsMake(0.0, CGRectGetWidth(self.bounds)/2.0, 0.0, CGRectGetWidth(self.bounds)/2.0)
        
        self.presenterID = -1
        self.presenterImageView.image = nil
        self.presenterNameLabel.text = nil
    }
    
    
    
    // MARK: - Public methods
    
    func loadDataFrom(presenter: Presenter) {
        if let presenterID = presenter.presenterID {
            self.presenterID = presenterID.integerValue
        } else {
            self.prepareForReuse()
            
            return
        }
        
        self.presenterImageView.image = presenter.getImage()
        self.presenterNameLabel.text = "\(presenter.firstName) \(presenter.lastName)"
    }
}
