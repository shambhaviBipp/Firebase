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
    var firbaseKey : String?
    var receiverID: String?
    var senderID: String?
    var Msg: String?
    var date_time: String?
    var MsgType: String?
    
    init(firbaseKey: String, receiverID: String, senderID: String, Msg: String, date_time: String, MsgType: String){
        self.firbaseKey = firbaseKey
        self.receiverID = receiverID
        self.senderID = senderID
        self.Msg = Msg
        self.date_time = date_time
        self.MsgType = MsgType
    }
}


class Users{
    var Name : String?
    var Email: String?
    var isOnline: String?
    var userId: String?
    
    init(Name: String, Email: String, isOnline: String, userId: String){
        self.Name = Name
        self.Email = Email
        self.isOnline = isOnline
        self.userId = userId
    }
}
