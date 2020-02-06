//
//  FamilyMemberTableViewCell.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/6/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import UIKit

class FamilyMemberTableViewCell: UITableViewCell {

    var user: Parent? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var familyMemberNameLabel: UILabel!
    
    

    func updateViews() {
        
    }
}
