//
//  ChatVC.swift
//  chatClient
//
//  Created by Matthew on 10/6/18.
//  Copyright © 2018 Matthew. All rights reserved.
//

import UIKit
import Parse

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatMessageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var parseMessages: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Ensure dynamic cell size
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        // Refresh timer every second to check for messages
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)

    }
    
    @IBAction func onSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        // Store the text of the text field in a key called text. (Provide a default empty string so message text is never nil)
        chatMessage["text"] = chatMessageField.text ?? ""
        chatMessage["user"] = PFUser.current()
        
        //
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                // clear text field on success
                self.chatMessageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        // clears current user cache and takes user back to LoginVC
        // PFUser.current() will now be nil
        PFUser.logOutInBackground(block: { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Successful loggout")
                // Load and show the login view controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                self.view.window?.rootViewController = loginViewController
            }
        })
    }
    
    @objc func onTimer() {
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (messages, error) in
            if let messages = messages {
                self.parseMessages = messages
            }
            else {
                print(error?.localizedDescription as Any)
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parseMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath as IndexPath) as! ChatCell
        
        if let user = parseMessages[indexPath.row]["user"] as? PFUser {
            // User found! update username label with username
            cell.usernameLabel.text = user.username
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        
        cell.messageLabel.text = parseMessages[indexPath.row]["text"] as? String
        return cell
    }
}
