//
//  ChatTypeVC.swift
//  RealtimeDB
//
//  Created by Admin on 03/03/22.
//

import UIKit

class ChatTypeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Dhiraj(_ sender: Any) {
        
        guard let vc =  UIStoryboard.init(name: "chat", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatVC") as? ChatVC else {return}
        vc.name = "Dhiraj"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func Priya(_ sender: Any) {
        
        guard let vc =  UIStoryboard.init(name: "chat", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatVC") as? ChatVC else {return}
        vc.name = "Priya"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
