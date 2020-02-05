//
//  AddFamilyMemberViewController.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/5/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import UIKit

class AddFamilyMemberViewController: UIViewController {

    var choreTrackerController: ChoreTrackerController?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveChildButtonTapped(_ sender: Any) {
        guard let choreTrackerController = choreTrackerController else { return }
        if let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            let child = ChildRepresentation(id: 0, username: username, password: password)
            
            choreTrackerController.childRegister(with: child) { error in
                if let error = error {
                    NSLog("Error occured while adding child: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Success", message: "Added \(username) to your account.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
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
