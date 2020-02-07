//
//  FamilyMemberTableViewCell.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/6/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import UIKit

class FamilyMemberTableViewCell: UITableViewCell {

    var child: Child? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var childNameLabel: UILabel!

    
    

    func updateViews() {
        
    }
}
