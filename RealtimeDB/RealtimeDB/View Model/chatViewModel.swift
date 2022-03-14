//
//  chatModel.swift
//  RealtimeDB
//
//  Created by Admin on 04/03/22.
//

import Foundation
import Firebase
import FirebaseDatabase

class chatModel{
    
    var fRef = DatabaseReference()
    let db = Database.database().reference()
    var messages = [Messages]()
    var fHandle = DatabaseHandle()
    var query = DatabaseQuery()
    
    func getMessages(receiverID: String, senderID: String, completion: @escaping(_ result: [Messages]?) -> Void){
        
        db.child("Message").observe(.childAdded) { data in
            if data.key == receiverID+senderID{
                self.db.child("Message").child(receiverID+senderID).observe(.childAdded) { data1 in
                    guard let subData = data1.value as? [String: Any] else{
                        completion(nil)
                        return
                    }
                    
                    self.messages.append(Messages(firbaseKey: data1.key ,receiverID: subData["receiverID"] as? String ?? "-", senderID: subData["senderID"] as? String ?? "-", Msg: subData["Msg"] as? String ?? "-", date_time: subData["date_time"] as? String ?? "-", MsgType: subData["MsgType"] as? String ?? "-"))
                    completion(self.messages)
                    
                }
            }else if data.key == senderID+receiverID{
                self.db.child("Message").child(senderID+receiverID).observe(.childAdded) { data1 in
                    guard let subData = data1.value as? [String: Any] else{
                        completion(nil)
                        return
                    }
                    self.messages.append(Messages(firbaseKey: data1.key ,receiverID: subData["receiverID"] as? String ?? "-", senderID: subData["senderID"] as? String ?? "-", Msg: subData["Msg"] as? String ?? "-", date_time: subData["date_time"] as? String ?? "-", MsgType: subData["MsgType"] as? String ?? "-"))
                    completion(self.messages)
                    
                }
            }
            
        }
    }
    
    func sendMessage(message: String, receiverID: String, senderID: String, completion: @escaping(_ result: String?) -> Void){
    
       
        var isKeyAvailable = false
    
            self.db.observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    print(snap.key)
                    
                    if snap.key == "Message"{
                        isKeyAvailable = true
                        break
                    }else if snap.key != "Message"{
                        isKeyAvailable = false
                    }
                    }
                
                self.msg(isKeyAvailable: isKeyAvailable, message: message, receiverID: receiverID, senderID: senderID)
                
                completion("success")
            })
    
        
    }
    
    
    func msg(isKeyAvailable: Bool, message: String, receiverID: String, senderID: String){

        let date_time = Date()
        let dateFormatter = DateFormatter()
        let strDate_time = dateFormatter.string(from: date_time)
        
        
        if isKeyAvailable{
            db.child("Message").observeSingleEvent(of: .childAdded) { data in
                if data.key == receiverID+senderID{
                    self.db.child("Message").child(receiverID+senderID).childByAutoId().setValue(["Msg": message, "MsgType": "text", "receiverID": receiverID, "senderID": senderID, "date_time": strDate_time])
                }else if data.key == senderID+receiverID{
                    self.db.child("Message").child(senderID+receiverID).childByAutoId().setValue(["Msg": message, "MsgType": "text", "receiverID": receiverID, "senderID": senderID, "date_time": strDate_time])
                }else{
                    self.db.child("Message").child(receiverID+senderID).childByAutoId().setValue(["Msg": message, "MsgType": "text", "receiverID": receiverID, "senderID": senderID, "date_time": strDate_time])
                }
                
            }
        }else{
            self.db.child("Message").child(receiverID+senderID).childByAutoId().setValue(["Msg": message, "MsgType": "text", "receiverID": receiverID, "senderID": senderID, "date_time": strDate_time])
        }
    }
    
    func online_offline(id: String, status: String, completion: @escaping (Bool) -> Void) {
 
        let onlinesRef = db.child("Users").child(id)
        
        onlinesRef.updateChildValues(["isOnline": status]) { error, ref in
            if error != nil{
                completion(true)
            }else{
                completion(false)
            }
        }

    }
    
    func checkOnlineUser(id: String, completion: @escaping (String) -> Void){

        db.child("Users").child("\(id)").observe(.value) { data in
            print(data)
            
            guard let result = data.value as? [String : Any] else{
               return
            }
            completion(result["isOnline"] as? String ?? "-")
        }
        
    }
    
    
    
    func deleteMessgae(receiverID: String, senderID: String, firebaseKey: String, index: Int, completion: @escaping (String) -> Void){
        var key = ""
        db.child("Message").observeSingleEvent(of: .value) { data in
            
            if let data1 = data.children.allObjects as? [DataSnapshot]{
                for dict in data1{
                    if dict.key == receiverID+senderID{
                        key = dict.key
                        break
                    }else if dict.key == senderID+receiverID{
                        key = dict.key
                        break
                    }
                }
                
                self.deleteKey(firebaseKey: firebaseKey, index: index, key: key) { result in
                    if result == "success"{
                        completion("success")
                    }else{
                        completion("error")
                    }
                }
            }
        }
    }
    
    
    
    func deleteKey(firebaseKey: String, index: Int, key: String, completion : @escaping (String) -> Void){
        
        
        let refToRemove = self.db.child("Message").child(key).child(firebaseKey)
        refToRemove.removeValue() {error,_  in
            if error == nil{
                completion("success")
            }else{
                completion("error")
            }
        }
    }
    
    

    
//    func addRemoveObserver(index: Int,key: String, completion : @escaping (String) -> Void) {
//        fRef = db.child("Message").child(key)
//        query = db.child("Message").child(key)
//        self.fHandle = query.observe(.value){ data in
//            self.messages.remove(at: index)
//            self.fRef.removeObserver(withHandle: self.fHandle)
//            completion("success")
//        }
//
//    }

    
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
