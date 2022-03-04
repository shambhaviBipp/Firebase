//
//  ChatVC.swift
//  RealtimeDB
//
//  Created by Admin on 03/03/22.
//

import UIKit
import FirebaseFirestore
//import MessageKit
//import InputBarAccessoryView
//
//struct Sender: SenderType{
//    //var photoURL: URL
//    var senderId: String
//    var displayName: String
//}
//
//
//struct Message : MessageType{
//    var sender: SenderType
//    var messageId: String
//    var sentDate: Date
//    var kind: MessageKind
//}


class ChatVC: UIViewController {
    
//    var messageListener: ListenerRegistration?
//    let sender = Sender(senderId: "sender", displayName: "Sender")
//    let receiver = Sender(senderId: "receiver", displayName: "Receiver")
//    var messages = [Message]()
    
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var tblView: UITableView!
    
    var name = ""
    let viewModel = chatModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        txtMessage.delegate = self
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
        
        
        viewModel.sendMessage(message: txtMessage.text!, receiver: receiver, sender: sender) { result in
            if result == "success"{
                
            }else{
                self.view.makeToast("Something went wrong! Please try again later!!")
            }
        }
        
        viewModel.receiveMessage(message: txtMessage.text!, receiver: receiver, sender: sender) { result in
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
                self.txtMessage.text = ""
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

extension ChatVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
