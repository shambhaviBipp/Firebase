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
    var count = Int()
    
    func addFirestoreData(name: String, mail: String, address: String, completion: @escaping (_ result: String?) -> Void ){
        
        var ref: DocumentReference? = nil
        ref = db.collection("Data2").addDocument(data: [
            "Name": name,
            "Mail": mail,
            "Address": address,
            "Id": count + 1
        ]) { err in
            if err != nil {
                completion("error")
            } else {
                print(ref ?? "-")
                completion("success")
            }
        }
        
    }
    
    func getDataUsingListner(completion: @escaping (_ result: [UsersData]?) -> Void){
        db.collection("Data2").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                completion(nil)
                return
            }
            document.documentChanges.forEach { data in
                if (data.type == .added) {
                    print("New data: \(data.document.data())")
                    let doc = data.document.data()
                    self.dataModel.append(UsersData(name: doc["Name"] as? String ?? "-", mail: doc["Mail"] as? String ?? "-", address: doc["Address"] as? String ?? "-"))
                }else if (data.type == .modified) {
                    print("Modified data: \(data.document.data())")
                }else if (data.type == .removed) {
                    print("Removed data: \(data.document.data())")
                }
            }
            completion(self.dataModel)
        }
    }
    
    
    
    func getFireStoreData(record: String, completion: @escaping (_ result: [UsersData]?) -> Void){
        if record == "all"{
            db.collection("Data1").order(by: "Id").getDocuments() { (querySnapshot, err) in
                if err == nil {
                    for document in querySnapshot!.documents {
                        let doc = document.data()
                        self.dataModel.append(UsersData(name: doc["Name"] as? String ?? "-", mail: doc["Mail"] as? String ?? "-", address: doc["Address"] as? String ?? "-"))
                    }
                    self.count = self.dataModel.count
                    completion(self.dataModel)
                } else {
                    completion(nil)
                }
            }
        }else if record == "latest"{
            db.collection("Data1").order(by: "Id").limit(toLast: 1).getDocuments() { (querySnapshot, err) in
                if err == nil {
                    for document in querySnapshot!.documents {
                        let doc = document.data()
                        self.dataModel.append(UsersData(name: doc["Name"] as? String ?? "-", mail: doc["Mail"] as? String ?? "-", address: doc["Address"] as? String ?? "-"))
                    }
                    self.count = self.dataModel.count
                    completion(self.dataModel)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
