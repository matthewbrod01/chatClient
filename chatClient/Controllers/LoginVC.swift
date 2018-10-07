//
//  LoginVC.swift
//  chatClient
//
//  Created by Matthew on 10/6/18.
//  Copyright © 2018 Matthew. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameText.text
        newUser.password = passwordText.text
        
        // Alert IF text fields are empty
        if (usernameText.text?.isEmpty)! || (passwordText.text?.isEmpty)! {
            
            // Create alert controller
            let alertController = UIAlertController(title: "Missing Fields", message: "Error. Login fields are missing.", preferredStyle: .alert)
            
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            present(alertController, animated: true, completion: nil)
        }
        // Else sign up user
        else {
            // call sign up function on the object
            newUser.signUpInBackground {(success: Bool, error: Error?) in
                if success {
                    print("User registered successfully.")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } else {
                    // Alert for any errors
                    print(error?.localizedDescription as Any)
                    let errorAlertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        // handle response here.
                    }
                    
                    // add the OK action to the alert controller
                    errorAlertController.addAction(OKAction)
                    self.present(errorAlertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { (user: PFUser?, error: Error?) in
            if user != nil {
                print("Logged in.")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                // Alert for any errors
                print(error?.localizedDescription as Any)
                let errorAlertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                }
                
                // add the OK action to the alert controller
                errorAlertController.addAction(OKAction)
                self.present(errorAlertController, animated: true, completion: nil)
            }
        }
    }
    
}
