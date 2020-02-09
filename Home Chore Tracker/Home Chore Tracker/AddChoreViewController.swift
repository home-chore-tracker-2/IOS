//
//  AddChoreViewController.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/8/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import UIKit

class AddChoreViewController: UIViewController {

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter
    }()
    
    var choreTrackerController: ChoreTrackerController? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var choreNameTextField: UITextField!
    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var bonusPointsTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var choreDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func saveChoreTapped(_ sender: Any) {
       
        guard
            let bonusPoints = bonusPointsTextField.text,
            let choreName = choreNameTextField.text,
            let choreDescription = descriptionTextView.text,
            let points = pointsTextField.text
            else { return }
        
        let chore = Chore(points: Int64(points) ?? 10, bonusPoints: Int64(bonusPoints), choreName: choreName, description: choreDescription, dueDate: choreDatePicker.date, picture: "", completed: false)
        
        choreTrackerController?.saveToPersistentStore()
        
        
        choreTrackerController?.sendChoreToServer(chore: chore)
        navigationController?.popViewController(animated: true)
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
