//
//  RTDataCell.swift
//  RealtimeDB
//
//  Created by Admin on 01/03/22.
//

import UIKit

class RTDataCell: UITableViewCell {

    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(data: UsersData){
        lblName.text = data.name?.capitalized
        lblEmail.text = data.mail?.lowercased()
        lblAddress.text = data.address?.capitalized
    }
    
}
