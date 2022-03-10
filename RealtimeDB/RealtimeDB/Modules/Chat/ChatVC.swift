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
    
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.online_offline(name: name, status: true) { result in
                //print(result)
        }
        
        var contactName = ""
        if name == "Priya"{
            contactName = "Dhiraj"
        }else{
            contactName = "Priya"
        }
        
        viewModel.checkOnlineUser(name: contactName) { result in
            if result == "true"{
                    self.navigationItem.titleView = setTitle(title: contactName, subtitle: "online")
                
            }else{
                    self.navigationItem.titleView = setTitle(title: contactName, subtitle: "last seen at \(result)")
                }
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.online_offline(name: name, status: false) { result in
        }
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
                self.txtMsg.resignFirstResponder()
                self.txtMsg.text = "Type Here"
                self.txtMsg.textColor = UIColor.lightGray
                self.tblView.reloadData()
            }else{
                self.view.makeToast("No data found!")
            }
            
        }
    }
    
    func copyText(){
        
    }
    
    func deleteMsg(firebaseKey: String, index: Int, indexPath: IndexPath){
        viewModel.deleteMessgae(firebaseKey: firebaseKey, index: index){ result in
            if result == "success"{
               // self.tblView.reloadData()
                self.tblView.deleteRows(at: [indexPath], with: .none)
            }else{
                self.view.makeToast("Please try again later!")
            }
        }
    }
}
extension ChatVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let backgroundSelectionView = UIView()
        backgroundSelectionView.backgroundColor = UIColor.white
        
        if viewModel.messages[indexPath.row].senderID == name{
            guard let cell = tblView.dequeueReusableCell(withIdentifier: "senderMessageCell") as? senderMessageCell else {return UITableViewCell()}
            cell.selectedBackgroundView = backgroundSelectionView
            cell.lbl.text = viewModel.messages[indexPath.row].Msg
            return cell
        }else{
            guard let cell = tblView.dequeueReusableCell(withIdentifier: "ReceiverMesssageCell") as? ReceiverMesssageCell else {return UITableViewCell()}
            cell.selectedBackgroundView = backgroundSelectionView
            cell.lbl.text = viewModel.messages[indexPath.row].Msg
            return cell
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let index = indexPath.row
        let data = viewModel.messages[indexPath.row]
        let identifier = "\(index)" as NSString
          
        return UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: nil) { _ in
                
              let copyAction = UIAction(
                title: "Copy") { _ in
                    UIPasteboard.general.string = self.viewModel.messages[index].Msg
              }
                
              let deleteAction = UIAction(
                title: "Delete") { _ in
                    self.deleteMsg(firebaseKey: data.firbaseKey ?? "-", index: index, indexPath: indexPath)
              }
                return UIMenu(title: "", image: nil, children: [copyAction, deleteAction])
            }
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?{
        guard let identifier = configuration.identifier as? String,
              let index = Int(identifier) else{
            return nil
        }
        
        if viewModel.messages[index].senderID == name{
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
                  as? senderMessageCell
            return UITargetedPreview(view: (cell?.msgView)!)
        }else{
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
                  as? ReceiverMesssageCell

            return UITargetedPreview(view: (cell?.msgView)!)
        }
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
