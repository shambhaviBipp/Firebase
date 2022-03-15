//
//  chatModel.swift
//  RealtimeDB
//
//  Created by Admin on 04/03/22.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class chatModel{
    
    
    var fRef = DatabaseReference()
    let db = Database.database().reference()
    var messages = [Messages]()
    var fHandle = DatabaseHandle()
    var query = DatabaseQuery()
    var key = ""
    var isRemove = false
    var index = Int()
    
    func getMessages(receiverID: String, senderID: String, completion: @escaping(_ result: [Messages]?) -> Void){
        
        db.child("Message").observe(.childAdded) { data in
            if data.key == receiverID+senderID{
                self.key = receiverID+senderID
                self.db.child("Message").child(receiverID+senderID).observe(.childAdded) { data1 in
                    guard let subData = data1.value as? [String: Any] else{
                        completion(nil)
                        return
                    }
                    
                    print(data)
                    self.messages.append(Messages(firbaseKey: data1.key ,receiverID: subData["receiverID"] as? String ?? "-", senderID: subData["senderID"] as? String ?? "-", Msg: subData["Msg"] as? String ?? "-", date_time: subData["date_time"] as? String ?? "-", MsgType: subData["MsgType"] as? String ?? "-"))
                    completion(self.messages)
                    
                }
            } else if data.key == senderID+receiverID{
                self.key = senderID+receiverID
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
        
//        db.child("Message").child(senderID+receiverID).observe(.childRemoved) { data in
//             print("Removed child \(data)")
//          
//            
//            for i in 0 ..< self.messages.count{
//                if self.messages[i].firbaseKey == data.key{
//                    self.messages.remove(at: i)
//                }
//            }
//            completion(self.messages)
//        }
        
        
    }
    
    func childRemoved(completion: @escaping(DataSnapshot) -> Void){
        if key != ""{
            self.db.child("Message").child(key).observe(.childRemoved){data in
                completion(data)
                
            }
        }
    }
    
    func sendMessage(message: String, receiverID: String, senderID: String){
    
       
        var isKeyAvailable = false
    
            self.db.observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    if snap.key == "Message"{
                        isKeyAvailable = true
                        break
                    }else if snap.key != "Message"{
                        isKeyAvailable = false
                    }
                    }
                
                self.msg(isKeyAvailable: isKeyAvailable, message: message, receiverID: receiverID, senderID: senderID)
            })
    }
    
    
    func msg(isKeyAvailable: Bool, message: String, receiverID: String, senderID: String){
        
        
      
        let date_time = Date()
        let dateFormatter = DateFormatter()
        let strDate_time = dateFormatter.string(from: date_time)
        
        
        if isKeyAvailable{
            db.child("Message").observeSingleEvent(of: .childAdded) { data in
                if data.key == receiverID+senderID{
                    self.key = receiverID+senderID
                    self.db.child("Message").child(receiverID+senderID).childByAutoId().setValue(["Msg": message, "MsgType": "text", "receiverID": receiverID, "senderID": senderID, "date_time": strDate_time])
                }else if data.key == senderID+receiverID{
                    self.key = senderID+receiverID
                    self.db.child("Message").child(senderID+receiverID).childByAutoId().setValue(["Msg": message, "MsgType": "text", "receiverID": receiverID, "senderID": senderID, "date_time": strDate_time])
                }else{
                    self.key = receiverID+senderID
                    self.db.child("Message").child(receiverID+senderID).childByAutoId().setValue(["Msg": message, "MsgType": "text", "receiverID": receiverID, "senderID": senderID, "date_time": strDate_time])
                }
                
            }
        }else{
            self.key = receiverID+senderID
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
            guard let result = data.value as? [String : Any] else{
               return
            }
            completion(result["isOnline"] as? String ?? "-")
        }
        
    }
    
    
    func deleteMsg(receiverID: String, senderID: String, firebaseKey: String, index: Int){
        db.child("Message").observeSingleEvent(of: .value) { data in
     
            if let data1 = data.children.allObjects as? [DataSnapshot]{
                for dict in data1{
                    if dict.key == receiverID+senderID{
                        self.key = receiverID+senderID
                        self.index = index
                        self.db.child("Message").child(receiverID+senderID).child(firebaseKey).removeValue()
                        break
                    }else if dict.key == senderID+receiverID{
                        self.key = senderID+receiverID
                        self.index = index
                        self.db.child("Message").child(senderID+receiverID).child(firebaseKey).removeValue()
                        break
                    }
                    
                }
            }
        }
    }
    
    
}
