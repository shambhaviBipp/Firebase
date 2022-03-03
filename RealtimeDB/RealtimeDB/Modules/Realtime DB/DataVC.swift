//
//  DataVC.swift
//  RealtimeDB
//
//  Created by Admin on 02/03/22.
//

import UIKit

class DataVC: UIViewController {

    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtName: UITextField!
    
    var type = ""
    var viewModel = RealTimeDBViewModel()
    var firestoreVM = FirestoreViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMail.delegate = self
        txtName.delegate = self
        txtAddress.delegate = self
        registerCell()
        
        if type == "realtime"{
            self.navigationItem.title = "Realtime"
            getRealtimeData(record: "all")
        }else if type == "firestore"{
            self.navigationItem.title = "Firestore"
           // firestoreVM.getDataUsingListner()
           // getfirestore(record: "all")
            geFirestoreListner()
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        navigation()
    }
    
    func registerCell(){
        tblView.register(UINib(nibName: "RTDataCell" , bundle: nil), forCellReuseIdentifier: "RTDataCell")
    }
    

    @IBAction func save(_ sender: Any) {
        if txtName.text! == "" || txtAddress.text! == "" || txtMail.text == ""{
            self.view.makeToast("Please enter all fields!")
        }else{
            if type == "realtime"{
                    startLoader()
                    self.viewModel.saveData(name: self.txtName.text!, mail: self.txtMail.text!, address: self.txtAddress.text!) { result in
                            if result == "suceess"{
                                self.stopLoader()
                                self.getRealtimeData(record: "latest")
                            }else{
                                self.stopLoader()
                                self.view.makeToast("Something went wrong! Please try again later!!")
                            }
                        }
                }else if type == "firestore"{
                    firestoreVM.addFirestoreData(name: txtName.text!, mail: txtMail.text!, address: txtAddress.text!) { result in
                        if result == "success"{
                            self.stopLoader()
                            //self.getfirestore(record: "latest")
                        }else{
                            self.stopLoader()
                            self.view.makeToast("Something went wrong! Please try again later!!")
                        }
                    }
                }
        }
    }
    
    func getRealtimeData(record: String){
        startLoader()
        self.viewModel.getRealtimeData(record: record){ result in
            if result != nil{
                self.stopLoader()
                self.txtMail.text = ""
                self.txtName.text = ""
                self.txtAddress.text = ""
                self.tblView.isHidden = false
                self.tblView.reloadData()
            }else{
                self.stopLoader()
                self.tblView.isHidden = true
                self.view.makeToast("Data not found")
            }
            
        }
    }
    
    func getfirestore(record: String){
        startLoader()
        self.firestoreVM.getFireStoreData(record: record){ result in
            if result != nil{
                self.stopLoader()
                self.txtMail.text = ""
                self.txtName.text = ""
                self.txtAddress.text = ""
                self.tblView.isHidden = false
                self.tblView.reloadData()
            }else{
                self.stopLoader()
                self.tblView.isHidden = true
                self.view.makeToast("Data not found")
            }
        }
    }
    
    func geFirestoreListner(){
        self.firestoreVM.getDataUsingListner { result in
            if result != nil{
                self.stopLoader()
                self.txtMail.text = ""
                self.txtName.text = ""
                self.txtAddress.text = ""
                self.tblView.isHidden = false
                self.tblView.reloadData()
            }else{
                self.stopLoader()
                self.tblView.isHidden = true
                self.view.makeToast("Data not found")
            }
        }
    }
}

extension DataVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DataVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == "realtime"{
            return viewModel.dataModel.count
        }else if type == "firestore"{
            return firestoreVM.dataModel.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "RTDataCell") as? RTDataCell else {return UITableViewCell()}
        if type == "realtime"{
            cell.bindData(data: viewModel.dataModel[indexPath.row])
        }else if type == "firestore"{
            cell.bindData(data: firestoreVM.dataModel[indexPath.row])
        }
        return cell
    }
}



