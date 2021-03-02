//
//  cellChatMessageMe.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 06.02.21.
//

import UIKit

class cellChatMessageMe: UITableViewCell {
    
    @IBOutlet var messageText: UILabel!
    @IBOutlet var messageUser: UILabel!
    @IBOutlet var messageTime: UILabel!
    @IBOutlet var messageBack: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.messageBack?.layer.cornerRadius = 18
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
