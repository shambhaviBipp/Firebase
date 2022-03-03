//
//  RealTimeDBViewModel.swift
//  RealtimeDB
//
//  Created by Admin on 01/03/22.
//

import Foundation
import Firebase


class RealTimeDBViewModel {
    
    var dataModel = [UsersData]()
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
    
    
    func getRealtimeData(record: String, completion: @escaping (_ result: [UsersData]?) -> Void){
        if record == "all"{
            db.child("Data").observeSingleEvent(of: .value) { data in
                self.dataModel.removeAll()
                if let users = data.children.allObjects as? [DataSnapshot]{
                    if users.count != 0{
                        for data in users{
                            if let dict = data.value as? [String: String]{
                                self.dataModel.append(UsersData(name: dict["Name"] ?? "-", mail: dict["Email"] ?? "-", address: dict["Address"] ?? "-"))
                            }
                        }
                        print(self.dataModel)
                        completion(self.dataModel)
                    }else{
                        completion(nil)
                    }
                }
            }
        }else if record == "latest"{
            db.child("Data").queryLimited(toLast: 1).observeSingleEvent(of: .value) { data in
                if let users = data.children.allObjects as? [DataSnapshot]{
                    if users.count != 0{
                        for data in users{
                            if let dict = data.value as? [String: String]{
                                self.dataModel.append(UsersData(name: dict["Name"] ?? "-", mail: dict["Email"] ?? "-", address: dict["Address"] ?? "-"))
                            }
                        }
                        completion(self.dataModel)
                    }else{
                        completion(nil)
                    }
                }
            }

        }
        
    }
    
}
