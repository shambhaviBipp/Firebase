//
//  signInVC.swift
//  RealtimeDB
//
//  Created by Admin on 10/03/22.
//

import UIKit

protocol logging{
    func loggedIn()
}

class signInVC: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    var delegate: logging?
    var isEmail = false
    var isPassword = false
    var isName = false
    var viewModel = loginViewModel()
    var valid = Validation()
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        txtName.delegate = self
        txtPassword.delegate = self
        btnLogin.isEnabled = false
        
        viewModel.getUsers(){ result in
        }
    }
    
    
    
    @IBAction func login(_ sender: Any) {
        guard valid.isValidEmail(value: txtEmail.text!) else{
            self.view.makeToast("Please enter valid E-mail Id")
            return
        }
        viewModel.addUser(email: txtEmail.text!, name: txtName.text!) { result in
            if result == "success"{
                self.navigationController?.popViewControllerWithHandler{
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self.delegate?.loggedIn()
                }
            }else{
                self.view.makeToast("Please try again later!")
            }
        }
    }
    
    
}

extension signInVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtEmail{
            if let text = textField.text, let range = Range(range, in: text) {
                let proposedText = text.replacingCharacters(in: range, with: string)
                if proposedText.isEmpty == true{
                    isEmail = false
                }else{
                    isEmail = true
                }
            }
        }else if textField == txtPassword{
            if let text = textField.text, let range = Range(range, in: text) {
                let proposedText = text.replacingCharacters(in: range, with: string)
                if proposedText.isEmpty == true{
                    isPassword = false
                }else{
                    isPassword = true
                }
            }
        }else if textField == txtName{
            if let text = textField.text, let range = Range(range, in: text) {
                let proposedText = text.replacingCharacters(in: range, with: string)
                if proposedText.isEmpty == true{
                    isName = false
                }else{
                    isName = true
                }
            }
        }
        
        if isEmail == true && isPassword == true && isName == true{
            btnLogin.isEnabled = true
        }else{
            btnLogin.isEnabled = false
        }
        
        return true
    }
}
