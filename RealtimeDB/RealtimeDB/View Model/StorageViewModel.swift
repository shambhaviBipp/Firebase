//
//  StorageViewModel.swift
//  RealtimeDB
//
//  Created by Admin on 15/03/22.
//

import Foundation
import FirebaseStorage


class StorageViewModel{
    
    let db = Storage.storage().reference()
    
    
    func uploadFile(fileName: String, data: Data, type: String, completion: @escaping (URL?, String?) -> Void){
        let ref = db.child(fileName)
        
        let metadata = StorageMetadata()
        if type == "video"{
            metadata.contentType = "video/mp4"
        }else if type == "image"{
            metadata.contentType = "image/jpeg"
        }else{
            metadata.contentType = "apllication/\(type)"
        }
        
        
        ref.putData(data, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                completion(nil, nil)
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(nil, nil)
                    return
                }
                completion(downloadURL, type)
                
            }
        }
        
        
    }
    
}
