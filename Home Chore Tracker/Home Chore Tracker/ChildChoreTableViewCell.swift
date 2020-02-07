//
//  ChildChoreTableViewCell.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/6/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import UIKit

class ChildChoreTableViewCell: UITableViewCell {

    @IBOutlet weak var choreNameLabel: UILabel!
    
    var chore: Chore? {
        didSet {
            
        }
    }

}
