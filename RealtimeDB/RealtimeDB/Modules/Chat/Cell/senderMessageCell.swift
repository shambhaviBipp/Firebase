//
//  senderMessageCell.swift
//  RealtimeDB
//
//  Created by Admin on 04/03/22.
//

import UIKit

class senderMessageCell: UITableViewCell {
    
    @IBOutlet weak var msgStackView: UIView!
    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var msgView: SenderMsgBox!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bindData(Messages: Messages){
        if Messages.MsgType == "text"{
            imgView.isHidden = true
            msgStackView.isHidden = false
            lbl.text = Messages.Msg
        }else if Messages.MsgType == "video"{
            imgView.isHidden = false
            msgStackView.isHidden = true
            img.image = UIImage(named: "videoPreview")
        }else if Messages.MsgType == "image"{
            imgView.isHidden = false
            msgStackView.isHidden = true
            guard let imgUrl = URL(string: Messages.Msg ?? "-") else { return  }
            
            do{
                let data = try Data (contentsOf: imgUrl)
                img.image = UIImage(data: data)
            } catch{
                print("error")
            }
            
            
        }else{
            imgView.isHidden = false
            msgStackView.isHidden = true
            
            img.image = UIImage(named: "document")
        }
    }
    
}
