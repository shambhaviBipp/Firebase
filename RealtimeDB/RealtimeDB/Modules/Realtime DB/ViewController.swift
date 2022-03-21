//
//  ViewController.swift
//  RealtimeDB
//
//  Created by Admin on 01/03/22.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var btnRealTime: UIButton!
    @IBOutlet weak var btnSignOut: UIButton!
    @IBOutlet weak var btnFirestore: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.makeToast("Toast")
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == true{
            let userID = UserDefaults.standard.string(forKey: "UserID")
            btnLogin.setTitle(userID, for: .normal)
            btnLogin.isEnabled = false
            btnSignOut.isHidden = false
        }else{
            btnSignOut.isHidden = true
        }
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
        Analytics.logEvent("ChatType", parameters: [:])
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == true{
            guard let vc =  UIStoryboard.init(name: "chat", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatTypeVC") as? ChatTypeVC else {return}
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.view.makeToast("Please Sign-In")
        }
    }
    @IBAction func signIn(_ sender: Any) {
        
        guard let vc =  UIStoryboard.init(name: "SignIn", bundle: Bundle.main).instantiateViewController(withIdentifier: "signInVC") as? signInVC else {return}
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signOut(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Do you really want to Logout?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default) {
            UIAlertAction in
            let  appdomain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: appdomain)
            UserDefaults.standard.synchronize()
            self.btnSignOut.isHidden = true
            self.btnLogin.setTitle("Sign-In", for: .normal)
            self.btnLogin.isEnabled = true
        }
        let noAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) {
            UIAlertAction in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: logging{
    func loggedIn() {
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == true{
            let userID = UserDefaults.standard.string(forKey: "UserID")
            btnLogin.setTitle(userID, for: .normal)
            btnSignOut.isHidden = false
            btnLogin.isEnabled = false
        }else{
            btnSignOut.isHidden = true
        }
    }
}
