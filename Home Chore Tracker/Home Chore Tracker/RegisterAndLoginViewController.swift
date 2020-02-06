//
//  RegisterAndLoginViewController.swift
//  Home Chore Tracker
//
//  Created by Michael on 2/4/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import UIKit

enum LoginType {
    case register
    case parentLogin
    case childLogin
}

class RegisterAndLoginViewController: UIViewController {

    var choreTrackerController: ChoreTrackerController?
    
    var loginType = LoginType.register
    
    @IBOutlet weak var registerOrLoginLabel: UILabel!
    @IBOutlet weak var registerOrLoginSegmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpOrInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .register
            signUpOrInButton.setTitle("Sign Up", for: .normal)
            registerOrLoginLabel.text = "Create An Account"
        } else if sender.selectedSegmentIndex == 1 {
            loginType = .parentLogin
            signUpOrInButton.setTitle("Sign In", for: .normal)
            registerOrLoginLabel.text = "User Sign In"
        } else if sender.selectedSegmentIndex == 2 {
            loginType = .childLogin
            signUpOrInButton.setTitle("Sign In", for: .normal)
            registerOrLoginLabel.text = "Child Sign In"
        }
    }
    
    @IBAction func signUpOrInButtonTapped(_ sender: UIButton) {
        guard let choreTrackerController = choreTrackerController else { return }
        if let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty,
            let email = emailTextField.text, !email.isEmpty {
            let user = User(username: username, password: password, email: email)
            
            if loginType == .register {
                choreTrackerController.parentSignUp(user: user) { error in
                    if let error = error {
                        NSLog("Error occured during sign up: \(error)")
                    } else {
                        DispatchQueue.global().async {
                            choreTrackerController.saveToPersistentStore()
                            
                        }
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful!", message: "Please log in...", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true) {
                                self.loginType = .parentLogin
                                
                                self.registerOrLoginSegmentedControl.selectedSegmentIndex = 1
                                self.signUpOrInButton.setTitle("Sign In", for: .normal)
                                self.registerOrLoginLabel.text = "Sign In"
                            }
                        }
                    }
                }
            } else if loginType == .parentLogin {
                choreTrackerController.parentLogin(user: user) { error in
                    if let error = error {
                        NSLog("Error occured during sign in: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
