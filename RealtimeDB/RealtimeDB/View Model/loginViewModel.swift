//
//  loginViewModel.swift
//  RealtimeDB
//
//  Created by Admin on 10/03/22.
//

import Foundation
import Firebase


class loginViewModel{
    
    var users = [Users]()
    let db = Database.database().reference()
    func addUser(email: String, name: String, completion: @escaping (String) -> Void){
        
        var hasUser = false
        let id = name.lowercased()
        db.child("Users").observe(.childAdded) { data in
            if data.key == "\(id)ID"{
                hasUser = true
            }else{
                hasUser = false
            }
        }
        
        if hasUser == false{
            db.child("Users").child("\(id)ID").setValue(["Name": name, "Email": email, "isOnline": "online", "userId": "\(id)ID"]){ error,reference in
                guard error != nil else{
                    UserDefaults.standard.set("\(id)ID", forKey: "UserID")
                    completion("success")
                    return
                }
                 completion("error")
            }
        }else{
            UserDefaults.standard.set("\(id)ID", forKey: "UserID")
            completion("success")
        }
    }
    
    func getUsers(completion: @escaping ([Users]?) -> Void){
        db.child("Users").observe(.childAdded) { data in
            guard let dict = data.value as? [String : String] else{
                completion(nil)
                return
            }
            if dict["userId"] != UserDefaults.standard.string(forKey: "UserID"){
            
                self.users.append(Users(Name: dict["Name"] ?? "-", Email: dict["Email"] ?? "-", isOnline: dict["isOnline"] ?? "-", userId: dict["userId"] ?? "-"))
                
                completion(self.users)
            }
        }
    }
}

