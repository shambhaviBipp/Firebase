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
    
    func navigation(){
        if #available(iOS 15, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
            navigationController?.navigationBar.standardAppearance = appearance;
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
            }
    }
}


extension UINavigationController {
    func popViewControllerWithHandler(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
}


