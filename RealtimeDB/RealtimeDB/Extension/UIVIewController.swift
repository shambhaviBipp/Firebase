//
//  UIVIewController.swift
//  RealtimeDB
//
//  Created by Admin on 02/03/22.
//

import UIKit
import SVProgressHUD


extension UIViewController{
    func startLoader() {
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show()
    }
    
    func stopLoader() {
        SVProgressHUD.dismiss()
    }
}

extension UINavigationController{
    func navigation(){
        if #available(iOS 15, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
            navigationController?.navigationBar.standardAppearance = appearance;
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
            }
    }
}