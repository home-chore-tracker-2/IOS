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
        guard let emailTextField = emailTextField else { return }
        
        if sender.selectedSegmentIndex == 0 {
            loginType = .register
            signUpOrInButton.setTitle("Sign Up", for: .normal)
            registerOrLoginLabel.text = "Create An Account"
            emailTextField.isHidden = false
        } else if sender.selectedSegmentIndex == 1 {
            loginType = .parentLogin
            signUpOrInButton.setTitle("Sign In", for: .normal)
            registerOrLoginLabel.text = "User Sign In"
            emailTextField.isHidden = false
        } else if sender.selectedSegmentIndex == 2 {
            loginType = .childLogin
            signUpOrInButton.setTitle("Sign In", for: .normal)
            registerOrLoginLabel.text = "Child Sign In"
            emailTextField.isHidden = true
        }
    }
    
    @IBAction func signUpOrInButtonTapped(_ sender: UIButton) {
        guard let choreTrackerController = choreTrackerController else { return }
        if let username = usernameTextField.text, let password = passwordTextField.text, let email = emailTextField.text {
            let user = User(username: username, password: password, email: email)
            let child = ChildUser(username: username, password: password)
            
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
                        NSLog("Error occured during parent sign in: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } else if loginType == .childLogin {
                choreTrackerController.childLogin(with: child) { error in
                    if let error = error {
                        NSLog("Error occured during child sign in: \(error)")
                    } else {
                        DispatchQueue.main.async {
//                            self.dismiss(animated: true, completion: nil)
                            self.performSegue(withIdentifier: "ChildsChoresSegue", sender: self)
                        }
                    }
                }
            }
        }
        
    }
}
