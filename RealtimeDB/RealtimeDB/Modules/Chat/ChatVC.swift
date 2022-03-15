//
//  ChatVC.swift
//  RealtimeDB
//
//  Created by Admin on 03/03/22.
//

import UIKit
import FirebaseFirestore


class ChatVC: UIViewController {
 
    @IBOutlet weak var btnFileUpload: UIButton!
    @IBOutlet weak var txtHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtMsg: UITextView!
    @IBOutlet weak var tblView: UITableView!
    
    var isFirstCall = true
    var name = ""
    var data: Users?
    let viewModel = chatModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMsg.delegate = self
        txtMsg.text = "Type Here"
        txtMsg.textColor = UIColor.lightGray
        txtHeightConstraint.constant = txtMsg.contentSize.height
        registerCell()
        getMessage()
        fileUploadMenu()
    }
    
    func childRemove(){
        viewModel.childRemoved { data in
            for i in 0 ..< self.viewModel.messages.count{
                if self.viewModel.messages[i].firbaseKey == data.key{
                    self.viewModel.messages.remove(at: i)
                    let indexPath = IndexPath(row: i, section: 0)
                    self.tblView.deleteRows(at: [indexPath], with: .none)
                    break
                }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.checkOnlineUser(id: data?.userId ?? "-") { result in
            self.navigationItem.titleView = setTitle(title:  self.data?.userId ?? "-", subtitle: result)
        }
    }
 
    
    func registerCell(){
        tblView.register(UINib(nibName: "senderMessageCell" , bundle: nil), forCellReuseIdentifier: "senderMessageCell")
        tblView.register(UINib(nibName: "ReceiverMesssageCell" , bundle: nil), forCellReuseIdentifier: "ReceiverMesssageCell")
    }
    
    
    @IBAction func fileUpload(_ sender: Any) {
    }
    @IBAction func send(_ sender: Any) {
        viewModel.sendMessage(message: txtMsg.text!, receiverID: data?.userId ?? "-", senderID: UserDefaults.standard.string(forKey: "UserID") ?? "-")
    }
    
    func getMessage(){
        viewModel.getMessages(receiverID: data?.userId ?? "-", senderID: UserDefaults.standard.string(forKey: "UserID") ?? "-") { result in
            if result != nil{
                self.txtMsg.resignFirstResponder()
                self.txtMsg.text = "Type Here"
                self.txtMsg.textColor = UIColor.lightGray
                self.tblView.reloadData()
                
                if self.isFirstCall == true{
                    self.childRemove()
                    self.isFirstCall = false
                }
               
                
            }else{
                self.view.makeToast("No data found!")
            }
        }
    }
   
    func deleteMsg(firebaseKey: String, index: Int, indexPath: IndexPath){
    
        self.viewModel.deleteMsg(receiverID: self.data?.userId ?? "-", senderID: UserDefaults.standard.string(forKey: "UserID") ?? "-", firebaseKey: firebaseKey, index: index)
    }
    
    func fileUploadMenu(){
        let uploadImageMenu = UIAction(title: "Photos", identifier: nil) { _ in
                    self.uploadImage()
                }
                let uploadFileMenu = UIAction(title: "Document", identifier: nil) { _ in
                    //self.docControllorConfig()
                }
                let uploadMenus = UIMenu(title: "", image: nil, identifier: nil, children: [uploadImageMenu,uploadFileMenu])
                self.btnFileUpload.menu = uploadMenus
                self.btnFileUpload.showsMenuAsPrimaryAction = true
    }
    
    func uploadImage(){
        let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
}

extension ChatVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            self.dismiss(animated: true, completion: nil)
        }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Array",viewModel.messages)
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let backgroundSelectionView = UIView()
        backgroundSelectionView.backgroundColor = UIColor.white
    

        if viewModel.messages[indexPath.row].senderID == UserDefaults.standard.string(forKey: "UserID") ?? "-"{
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
        
        if viewModel.messages[index].senderID == UserDefaults.standard.string(forKey: "UserID") ?? "-"{
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
