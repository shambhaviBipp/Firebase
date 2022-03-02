//
//  ViewController.swift
//  RealtimeDB
//
//  Created by Admin on 01/03/22.
//

import UIKit

class ViewController: UIViewController {

//    @IBOutlet weak var btnShowData: UIButton!
//    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtName: UITextField!
    
    var dataModel = [UsersData]()
    var viewModel = RealTimeDBViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      btnProcced.layer.cornerRadius = 8
        txtMail.delegate = self
        txtName.delegate = self
        txtAddress.delegate = self
        registerCell()
        getData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 15, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
            navigationController?.navigationBar.standardAppearance = appearance;
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
            }
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
                        self.getData()
                    }else{
                        self.stopLoader()
                        self.view.makeToast("Something went wrong! Please try again later!!")
                    }
                }
            }

        }
    }
    
    
    func getData(){
        startLoader()
        self.viewModel.getData { result in
            if result != nil{
                for data in result ?? []{
                    if let dict = data.value as? [String: String]{
                        self.dataModel.append(UsersData(name: dict["Name"] ?? "-", mail: dict["Email"] ?? "-", address: dict["Address"] ?? "-"))
                    }
                }
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

//    @IBAction func showData(_ sender: Any) {
//        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard1.instantiateViewController(withIdentifier: "DisplayRTDataVC")
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "RTDataCell") as! RTDataCell
        cell.bindData(data: dataModel[indexPath.row])
        return cell
    }
}
