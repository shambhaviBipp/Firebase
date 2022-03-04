//
//  chatModel.swift
//  RealtimeDB
//
//  Created by Admin on 04/03/22.
//

import Foundation
import Firebase

class chatModel{
    
    
    let db = Database.database().reference()
    var messages = [Messages]()
    
    func getMessages(selfName: String, name: String, completion: @escaping(_ result: [Messages]?) -> Void){
        db.child("\(selfName)").observe(.childAdded) { data in
   
            guard let subData = data.value as? [String:Any] else{
                completion(nil)
                return
            }
            
            guard let messageData = subData["\(name)"] as? [String: Any] else{
                completion(nil)
                return
            }
            
            self.messages.append(Messages(name:  subData["\(name)"] as? String ?? "-", message: messageData["Message"] as? String ?? "-", type: messageData["type"] as? String ?? "-"))
            completion(self.messages)
        }
       
    }
    
    func sendMessage(message: String, receiver: String, sender: String, completion: @escaping(_ result: String?) -> Void){
        let child = db.child("\(sender)")
        child.childByAutoId().child("\(receiver)").setValue(["Message": message,"type": "send"]){ error, reference in
            if let _ = error {
                completion("error")
            } else {
                completion("success")
            }
        }
    }
    
    
    func receiveMessage(message: String, receiver: String, sender: String, completion: @escaping(_ result: String?) -> Void){
        let child = db.child("\(receiver)")
        child.childByAutoId().child("\(sender)").setValue(["Message": message,"type": "receive"]){ error, reference in
            if let _ = error {
                completion("error")
            } else {
                completion("success")
            }
        }
        
    }
}
