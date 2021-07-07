//
//  ChildDetailTableViewCell.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/8/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import UIKit

class ChildDetailTableViewCell: UITableViewCell {

    var chore: Chore? {
        didSet {
            updateViews()
        }
    }
    @IBOutlet weak var choreNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let unwrappedChore = chore else { return }
        if unwrappedChore.completed {
            
        }
        
    }
}
