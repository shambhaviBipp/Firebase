//
//  DisplayRTDataVC.swift
//  RealtimeDB
//
//  Created by Admin on 01/03/22.
//

import UIKit

class DisplayRTDataVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var dataModel = [UsersData]()
    var viewModel = RealTimeDBViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        //   getData()
    }
    
    func registerCell(){
        tblView.register(UINib(nibName: "RTDataCell" , bundle: nil), forCellReuseIdentifier: "RTDataCell")
    }
    
    //    func getData(){
    //        self.viewModel.getData { result in
    //
    //            if result != nil{
    ////                for data in result ?? []{
    ////                    if let dict = data.value as? [String: String]{
    ////                        self.dataModel.append(UsersData(name: dict["Name"] ?? "-", mail: dict["Email"] ?? "-", address: dict["Address"] ?? "-"))
    ////                    }
    ////                }
    //                self.tblView.isHidden = false
    //                self.tblView.reloadData()
    //            }else{
    //                self.tblView.isHidden = true
    //                self.view.makeToast("Data not found")
    //            }
    //
    //        }
    //    }
    
}

extension DisplayRTDataVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "RTDataCell") as! RTDataCell
        cell.bindData(data: dataModel[indexPath.row])
        return cell
    }
    
    
}
