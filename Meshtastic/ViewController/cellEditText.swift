//
//  cellEditText.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 06.10.20.
//

import UIKit

class cellEditText: UITableViewCell
{

    
    @IBOutlet var lblCaption: UILabel!
    @IBOutlet var lblValue: UILabel!
    @IBOutlet var lblInfo: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
