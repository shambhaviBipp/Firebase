//
//  Validation.swift
//  RealtimeDB
//
//  Created by Admin on 10/03/22.
//

import Foundation

class Validation{
    func isValidEmail(value:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: value)
    }
}

