//
//  PresenterCell.swift
//  IT Tour
//
//  Created by Vladimir Savov on 3.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import UIKit

class PresenterCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var presenterImageView: UIImageView!
    @IBOutlet weak var presenterNameLabel: UILabel!
    
    var presenterID: Int = -1
    
    // MARK: - View lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.presenterImageView.layer.cornerRadius = self.presenterImageView.frame.size.width / 2.0
        self.presenterImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
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
        self.presenterNameLabel.text = "\(presenter.firstName!) \(presenter.lastName!)"
    }
}
