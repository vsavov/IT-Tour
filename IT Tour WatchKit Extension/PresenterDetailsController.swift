//
//  PresenterDetailsController.swift
//  IT Tour
//
//  Created by Vladimir Savov on 8.08.15.
//  Copyright (c) 2015 г. IT Tour. All rights reserved.
//

import WatchKit
import Foundation
import CoreDataFramework

class PresenterDetailsController: WKInterfaceController {
    
    // MARK: - Properties
    
    @IBOutlet weak var presenterImageGroup: WKInterfaceGroup!
    @IBOutlet weak var presenterNameLabel: WKInterfaceLabel!
    @IBOutlet weak var presenterShortBioLabel: WKInterfaceLabel!
    
    // MARK: - View lifecycle methods
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let presenter = context as! Presenter
        
        self.presenterImageGroup.setBackgroundImage(presenter.getImage())
        self.presenterNameLabel.setText("\(presenter.firstName!) \(presenter.lastName!)")
        self.presenterShortBioLabel.setText(presenter.shortBio)
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
}
