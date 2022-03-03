//
//  FirestoreViewModel.swift
//  RealtimeDB
//
//  Created by Admin on 02/03/22.
//

import Foundation
import FirebaseFirestore

class FirestoreViewModel {
    
    var dataModel = [UsersData]()
    let db = Firestore.firestore()
    
    func addFirestoreData(name: String, mail: String, address: String, completion: @escaping (_ result: String?) -> Void ){
        
        var ref: DocumentReference? = nil
        ref = db.collection("Data").addDocument(data: [
            "Name": name,
            "Mail": mail,
            "Address": address
        ]) { err in
            if err != nil {
                completion("error")
            } else {
                print(ref ?? "-")
                completion("success")
            }
        }
        
    }
    
    
    
    func getFireStoreData(record: String, completion: @escaping (_ result: [UsersData]?) -> Void){
        if record == "all"{
            db.collection("Data").order(by: "Name").getDocuments() { (querySnapshot, err) in
                if err == nil {
                    for document in querySnapshot!.documents {
                        let doc = document.data()
                        self.dataModel.append(UsersData(name: doc["Name"] as? String ?? "-", mail: doc["Mail"] as? String ?? "-", address: doc["Address"] as? String ?? "-"))
                    }
                    completion(self.dataModel)
                } else {
                    completion(nil)
                }
            }
        }else if record == "latest"{
            db.collection("Data").order(by: "Name").limit(toLast: 1).getDocuments() { (querySnapshot, err) in
                if err == nil {
                    for document in querySnapshot!.documents {
                        let doc = document.data()
                        self.dataModel.append(UsersData(name: doc["Name"] as? String ?? "-", mail: doc["Mail"] as? String ?? "-", address: doc["Address"] as? String ?? "-"))
                    }
                    completion(self.dataModel)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
