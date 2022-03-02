//
//  ViewController.swift
//  RealtimeDB
//
//  Created by Admin on 01/03/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtName: UITextField!
    
    var viewModel = RealTimeDBViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMail.delegate = self
        txtName.delegate = self
        txtAddress.delegate = self
        registerCell()
        getData(record: "all")
        
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
            
            startLoader()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.viewModel.saveData(name: self.txtName.text!, mail: self.txtMail.text!, address: self.txtAddress.text!) { result in
                    if result == "suceess"{
                        self.stopLoader()
                        self.getData(record: "last")
                    }else{
                        self.stopLoader()
                        self.view.makeToast("Something went wrong! Please try again later!!")
                    }
                }
            }

        }
    }
    
    
    func getData(record: String){
        startLoader()
        self.viewModel.getData(record: record){ result in
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

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "RTDataCell") as? RTDataCell else {return UITableViewCell()}
        cell.bindData(data: viewModel.dataModel[indexPath.row])
        return cell
    }
}
