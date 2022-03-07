//
//  ChatVC.swift
//  RealtimeDB
//
//  Created by Admin on 03/03/22.
//

import UIKit
import FirebaseFirestore


class ChatVC: UIViewController {
 
    @IBOutlet weak var txtHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtMsg: UITextView!
    @IBOutlet weak var tblView: UITableView!
    
    var name = ""
    let viewModel = chatModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        txtMsg.delegate = self
        txtMsg.text = "Type Here"
        txtMsg.textColor = UIColor.lightGray
        txtHeightConstraint.constant = txtMsg.contentSize.height
        registerCell()
        getMessage()
    }
    
    
    func registerCell(){
        tblView.register(UINib(nibName: "senderMessageCell" , bundle: nil), forCellReuseIdentifier: "senderMessageCell")
        tblView.register(UINib(nibName: "ReceiverMesssageCell" , bundle: nil), forCellReuseIdentifier: "ReceiverMesssageCell")
    }
    
    
    @IBAction func send(_ sender: Any) {
        
        var sender = ""
        var receiver = ""
        if name == "Priya"{
            sender = "Priya"
            receiver = "Dhiraj"
        }else{
            sender = "Dhiraj"
            receiver = "Priya"
        }
        
        
        viewModel.sendMessage(message: txtMsg.text!, receiver: receiver, sender: sender) { result in
            if result == "success"{
                
            }else{
                self.view.makeToast("Something went wrong! Please try again later!!")
            }
        }
        
        viewModel.receiveMessage(message: txtMsg.text!, receiver: receiver, sender: sender) { result in
            if result == "success"{
                
            }else{
                self.view.makeToast("Something went wrong! Please try again later!!")
            }
        }
        
    }
    
    func getMessage(){
        
        var sender = ""
        var receiver = ""
        if name == "Priya"{
            sender = "Priya"
            receiver = "Dhiraj"
        }else{
            sender = "Dhiraj"
            receiver = "Priya"
        }
        
        viewModel.getMessages(selfName: sender, name: receiver) { result in
            
            if result != nil{
                self.txtMsg.text = "Type Here"
                self.txtMsg.textColor = UIColor.lightGray
                self.tblView.reloadData()
            }else{
                self.view.makeToast("No data found!")
            }
            
        }
    }
}
extension ChatVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if viewModel.messages[indexPath.row].type == "send"{
            guard let cell = tblView.dequeueReusableCell(withIdentifier: "senderMessageCell") as? senderMessageCell else {return UITableViewCell()}
            
            cell.lbl.text = viewModel.messages[indexPath.row].message
            return cell
        }else if viewModel.messages[indexPath.row].type == "receive"{
            guard let cell = tblView.dequeueReusableCell(withIdentifier: "ReceiverMesssageCell") as? ReceiverMesssageCell else {return UITableViewCell()}
            cell.lbl.text = viewModel.messages[indexPath.row].message
            return cell
        }
        return UITableViewCell()
    }
    
    
}

extension ChatVC: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        txtHeightConstraint.constant = txtMsg.contentSize.height
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type Here"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
