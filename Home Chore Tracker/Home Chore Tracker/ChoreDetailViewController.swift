//
//  ChoreDetailViewController.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/8/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import UIKit

class ChoreDetailViewController: UIViewController {

    var choreTrackerController: ChoreTrackerController? {
        didSet {
            
        }
    }
    
    var chore: Chore? {
        didSet {
            
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    @IBOutlet weak var choreNameLabel: UILabel!
    @IBOutlet weak var choreDescriptionTextView: UITextView!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }
    
    @IBAction func markCompleteTapped(_ sender: Any) {
        chore?.completed.toggle()
    }
    
    func updateViews() {
        guard
            let chore = chore,
            let dueDate = chore.dueDate
            else { return }
       
        let stringDate = dateFormatter.string(from: dueDate)
        choreNameLabel.text = chore.choreName
        choreDescriptionTextView.text = chore.choreDescription
        dueDateLabel.text = stringDate
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
