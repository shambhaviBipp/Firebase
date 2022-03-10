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
        db.child("Message").child("dhirajPriya").observe(.childAdded) { data in
            guard let subData = data.value as? [String: Any] else{
                completion(nil)
                return
            }
            
            self.messages.append(Messages(firbaseKey: data.key ,receiverID: subData["receiverID"] as? String ?? "-", senderID: subData["senderID"] as? String ?? "-", Msg: subData["Msg"] as? String ?? "-", date_time: subData["date_time"] as? String ?? "-", MsgType: subData["MsgType"] as? String ?? "-"))
            completion(self.messages)
        }
    }
    
    func sendMessage(message: String, receiver: String, sender: String, completion: @escaping(_ result: String?) -> Void){
    
        let date_time = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm:ss"
        let strDate_time = dateFormatter.string(from: date_time)
        
        
        let child = db.child("Message")
        child.child("dhirajPriya").childByAutoId().setValue(["Msg": message, "MsgType": "text", "receiverID": receiver, "senderID": sender, "date_time": strDate_time]){ error, reference in
            if let _ = error {
                completion("error")
            } else {
                completion("success")
            }
        }
    }
    
    func online_offline(name: String, status: Bool, completion: @escaping (Bool) -> Void) {
        let date_time = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let strTime = dateFormatter.string(from: date_time)
        var data = String()
        if status == false{
            data = strTime
        }else{
            data = String(status)
        }
        
        let onlinesRef = db.child("Message").child("isOnline").child(name)
        onlinesRef.setValue(data) {(error, _ ) in
            if error != nil {
                completion(false)
            }
            completion(true)
        }
    }
    
    func checkOnlineUser(name: String, completion: @escaping (String) -> Void){

        db.child("Message").child("isOnline").child(name).observe(.value) { data in
            guard let result = data.value as? String else{
               return
            }
            completion(result)
        }
        
    }
    
    
    func deleteMessgae(firebaseKey: String, index: Int, completion: @escaping (String) -> Void){
        let refToRemove = db.child("Message").child("dhirajPriya").child(firebaseKey)
        refToRemove.removeValue() {error,_  in
            if error == nil{
                self.messages.remove(at: index)
                print(self.messages)
                completion("success")
            }else{
                completion("error")
            }
        }
    }
    
    
//    func receiveMessage(message: String, receiver: String, sender: String, completion: @escaping(_ result: String?) -> Void){
//        let child = db.child("\(receiver)")
//        child.childByAutoId().child("\(sender)").setValue(["Message": message,"type": "receive"]){ error, reference in
//            if let _ = error {
//                completion("error")
//            } else {
//                completion("success")
//            }
//        }
//
//    }
}
