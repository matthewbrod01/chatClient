//
//  ChatCell.swift
//  chatClient
//
//  Created by Matthew on 10/6/18.
//  Copyright © 2018 Matthew. All rights reserved.
//

import UIKit
import Parse

class ChatCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
