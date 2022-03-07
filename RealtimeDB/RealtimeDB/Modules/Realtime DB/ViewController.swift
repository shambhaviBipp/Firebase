//
//  ViewController.swift
//  RealtimeDB
//
//  Created by Admin on 01/03/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnRealTime: UIButton!
    @IBOutlet weak var btnFirestore: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigation()
    }
    
    @IBAction func realTime(_ sender: Any) {
        guard let vc =  UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DataVC") as? DataVC else {return}
        vc.type = "realtime"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    @IBAction func fireStore(_ sender: Any) {
        guard let vc =  UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DataVC") as? DataVC else {return}
        vc.type = "firestore"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func chat(_ sender: Any) {
        
        guard let vc =  UIStoryboard.init(name: "chat", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatTypeVC") as? ChatTypeVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
