//
//  senderMessageCell.swift
//  RealtimeDB
//
//  Created by Admin on 04/03/22.
//

import UIKit

class senderMessageCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var msgView: SenderMsgBox!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
