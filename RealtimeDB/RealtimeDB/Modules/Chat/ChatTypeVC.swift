//
//  ChatTypeVC.swift
//  RealtimeDB
//
//  Created by Admin on 03/03/22.
//

import UIKit

class ChatTypeVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var viewModel = loginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        viewModel.getUsers { data in
            if data?.isEmpty == false{
                self.tblView.reloadData()
            }else{
                self.view.makeToast("Data not found")
            }
        }
    }
    func registerCell(){
        tblView.register(UINib(nibName: "usersCell" , bundle: nil), forCellReuseIdentifier: "usersCell")
    }
    
    //    @IBAction func Dhiraj(_ sender: Any) {
    //
    //        guard let vc =  UIStoryboard.init(name: "chat", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatVC") as? ChatVC else {return}
    //        vc.name = "Dhiraj"
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    //    @IBAction func Priya(_ sender: Any) {
    //
    //        guard let vc =  UIStoryboard.init(name: "chat", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatVC") as? ChatVC else {return}
    //        vc.name = "Priya"
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    
}

extension ChatTypeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "usersCell") as? usersCell else{
            return UITableViewCell()
        }
        
        cell.lblName.text = viewModel.users[indexPath.row].Name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc =  UIStoryboard.init(name: "chat", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatVC") as? ChatVC else {return}
        vc.data = viewModel.users[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
