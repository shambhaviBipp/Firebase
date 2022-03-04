//
//  Users.swift
//  RealtimeDB
//
//  Created by Admin on 01/03/22.
//

import Foundation

class UsersData{
    
    var name: String?
    var mail: String?
    var address: String?
    
    init(name: String, mail: String, address: String){
        self.name = name
        self.mail = mail
        self.address = address
    }
}
    
class Messages{
    var name: String?
    var message: String?
    var type: String?
    
    init(name: String, message: String, type: String){
        self.name = name
        self.message = message
        self.type = type
    }
}
