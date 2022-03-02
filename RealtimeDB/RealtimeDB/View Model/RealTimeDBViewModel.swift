//
//  RealTimeDBViewModel.swift
//  RealtimeDB
//
//  Created by Admin on 01/03/22.
//

import Foundation
import Firebase


class RealTimeDBViewModel {
    
    let db = Database.database().reference()
    
    func saveData(name: String, mail: String, address: String, completion: @escaping (_ result: String?) -> Void ){
        
        db.child("Data").childByAutoId().setValue(["Name": name, "Email": mail, "Address": address]) { error, reference in
            if let _ = error {
                completion("error")
            } else {
                completion("suceess")
            }
        }
        
    }
    
    func getData(completion: @escaping (_ result: [DataSnapshot]?) -> Void){
        db.child("Data").observe(.value) { data in
            if let users = data.children.allObjects as? [DataSnapshot]{
                if users.count != 0{
                    completion(users)
                }else{
                    completion(nil)
                }
            }
        }
    }
    
}
