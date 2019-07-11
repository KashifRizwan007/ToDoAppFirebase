//
//  DataListner.swift
//  TodoAppFirestore
//
//  Created by Kashif Rizwan on 7/11/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct DataListner {
    let db = Firestore.firestore()
    
    func getData (completion:  @escaping ( _ error: String? , _ toDoData:[ToDo]?) -> ()){
        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("toDoList").addSnapshotListener({(snapshot,error) in
            if let err = error{
                completion(err.localizedDescription,nil)
            }else{
                var DataArray = [ToDo]()
                for documents in snapshot!.documents{
                    if let date = documents.data()["date"] as? String, let detail = documents.data()["detail"] as? String, let title = documents.data()["title"] as? String{
                        DataArray.append(ToDo(title: title, description: detail, date: date, uid: documents.documentID))
                    }
                }
                if DataArray.count == 0{
                    completion(nil,nil)
                }else{
                    completion(nil,DataArray)
                }
            }
        })
    }
}
