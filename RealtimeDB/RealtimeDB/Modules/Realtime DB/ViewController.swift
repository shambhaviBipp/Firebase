//
//  ViewController.swift
//  RealtimeDB
//
//  Created by Admin on 01/03/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnShowData: UIButton!
    @IBOutlet weak var btnProcced: UIButton!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    var viewModel = RealTimeDBViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnProcced.layer.cornerRadius = 8
        txtMail.delegate = self
        txtName.delegate = self
        txtAddress.delegate = self
    }


    @IBAction func proceed(_ sender: Any) {
        
        if txtName.text! == "" || txtAddress.text! == "" || txtMail.text == ""{
            self.view.makeToast("Please enter all fields!")
        }else{
            viewModel.saveData(name: txtName.text!, mail: txtMail.text!, address: txtAddress.text!) { result in
                if result == "suceess"{
                    let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard1.instantiateViewController(withIdentifier: "DisplayRTDataVC")
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }else{
                    self.view.makeToast("Something went wrong! Please try again later!!")
                }
            }
        }
    }
    
    @IBAction func showData(_ sender: Any) {
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard1.instantiateViewController(withIdentifier: "DisplayRTDataVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
