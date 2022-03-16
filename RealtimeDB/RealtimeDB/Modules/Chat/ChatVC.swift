//
//  ChatVC.swift
//  RealtimeDB
//
//  Created by Admin on 03/03/22.
//

import UIKit
import FirebaseFirestore
import MobileCoreServices
import UniformTypeIdentifiers


class ChatVC: UIViewController {
    
    @IBOutlet weak var btnFileUpload: UIButton!
    @IBOutlet weak var txtHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtMsg: UITextView!
    @IBOutlet weak var tblView: UITableView!
    
    var isFirstCall = true
    var name = ""
    var data: Users?
    let viewModel = chatModel()
    let storageVM = StorageViewModel()
    var mediaType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMsg.delegate = self
        txtMsg.text = "Type Here"
        txtMsg.textColor = UIColor.lightGray
        txtHeightConstraint.constant = txtMsg.contentSize.height
        registerCell()
        getMessage()
        //fileUploadMenu()
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
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let image = UIImage(named: "camera")
        let action = UIAlertAction(title: "Camera", style: .default, handler: openCamera)
        action.setValue(image, forKey: "image")
        action.setValue(0, forKey: "titleTextAlignment")
        alertController.addAction(action)
        
        let image1 = UIImage(named: "album")
        let action1 = UIAlertAction(title: "Photo and Video Library", style: .default, handler: uploadImage)
        action1.setValue(image1, forKey: "image")
        action1.setValue(0, forKey: "titleTextAlignment")
        alertController.addAction(action1)
        
        let image2 = UIImage(named: "document")
        let action2 = UIAlertAction(title: "Document", style: .default, handler: uploadFile)
        action2.setValue(image2, forKey: "image")
        action2.setValue(0, forKey: "titleTextAlignment")
        alertController.addAction(action2)
        
        let image3 = UIImage(named: "location")
        let action3 = UIAlertAction(title: "Location", style: .default, handler: nil)
        action3.setValue(image3, forKey: "image")
        action3.setValue(0, forKey: "titleTextAlignment")
        alertController.addAction(action3)
        
        let action4 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(action4)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func send(_ sender: Any) {
        viewModel.sendMessage(message: txtMsg.text!, receiverID: data?.userId ?? "-", senderID: UserDefaults.standard.string(forKey: "UserID") ?? "-", type: "text")
    }
    
    func getMessage(){
        startLoader()
        viewModel.getMessages(receiverID: data?.userId ?? "-", senderID: UserDefaults.standard.string(forKey: "UserID") ?? "-") { result in
            if result != nil{
                self.txtMsg.resignFirstResponder()
                self.txtMsg.text = "Type Here"
                self.txtMsg.textColor = UIColor.lightGray
                self.tblView.reloadData()
                self.stopLoader()
                if self.isFirstCall == true{
                    self.childRemove()
                    self.isFirstCall = false
                }
                
                
            }else{
                self.stopLoader()
                self.view.makeToast("No data found!")
            }
        }
    }
    
    func deleteMsg(firebaseKey: String, index: Int, indexPath: IndexPath){
        
        self.viewModel.deleteMsg(receiverID: self.data?.userId ?? "-", senderID: UserDefaults.standard.string(forKey: "UserID") ?? "-", firebaseKey: firebaseKey, index: index)
    }
    
    //    func fileUploadMenu(){
    //        let uploadImageMenu = UIAction(title: "Photos", identifier: nil) { _ in
    //            self.uploadImage()
    //        }
    //        let uploadFileMenu = UIAction(title: "Document", identifier: nil) { _ in
    //            self.uploadFile()
    //        }
    //        let uploadMenus = UIMenu(title: "", image: nil, identifier: nil, children: [uploadImageMenu,uploadFileMenu])
    //        self.btnFileUpload.menu = uploadMenus
    //        self.btnFileUpload.showsMenuAsPrimaryAction = true
    //    }
    
    func uploadFile(_ action: UIAlertAction){
        let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    func uploadImage(_ action: UIAlertAction){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String, kUTTypeImage as String]
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    
    func openCamera(_ action: UIAlertAction){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType =  UIImagePickerController.SourceType.camera
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    
    func uploadToStorage(fileName: String, data: Data, type:String){
        storageVM.uploadFile(fileName: fileName, data: data, type: type){ url, type in
            
            guard let fileUrl = url else{ return }
            
            self.viewModel.sendMessage(message: "\(fileUrl)", receiverID: self.data?.userId ?? "-", senderID: UserDefaults.standard.string(forKey: "UserID") ?? "-", type: type ?? "-")
        }
    }
}

extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        startLoader()
        
        guard info[UIImagePickerController.InfoKey.mediaType] != nil else { return }
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
        
        
        if mediaType == "public.movie"{
            guard let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL else {return}
            let data = NSData(contentsOf: videoUrl as URL)!
            let name : Int64 = Int64(NSDate().timeIntervalSince1970 * 1000);
            
            uploadToStorage(fileName: String(name), data: data as Data, type: "video")
            
            
        }else if mediaType == "public.image"{
            guard let image = (info[.originalImage] as? UIImage) else { return }
            
            let imageData:Data = image.jpegData(compressionQuality: 0)!
            let imageUniqueName : Int64 = Int64(NSDate().timeIntervalSince1970 * 1000);
            uploadToStorage(fileName: String(imageUniqueName), data: imageData, type: "image")
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        startLoader()
        
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL.lastPathComponent)")
        
        let str = myURL.lastPathComponent
        let array = str.split(separator: ".")
        print(array)
        
        let data = NSData(contentsOf: myURL as URL)!
        let name : Int64 = Int64(NSDate().timeIntervalSince1970 * 1000);
        
        
        
        uploadToStorage(fileName: String(name), data: data as Data, type: String(array[1]))
        //        storageVM.uploadFile(filePath: myURL)
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
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
            cell.bindData(Messages: viewModel.messages[indexPath.row])
            //cell.lbl.text = viewModel.messages[indexPath.row].Msg
            return cell
        }else{
            guard let cell = tblView.dequeueReusableCell(withIdentifier: "ReceiverMesssageCell") as? ReceiverMesssageCell else {return UITableViewCell()}
            cell.selectedBackgroundView = backgroundSelectionView
            cell.bindData(Messages: viewModel.messages[indexPath.row])
            //cell.lbl.text = viewModel.messages[indexPath.row].Msg
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
