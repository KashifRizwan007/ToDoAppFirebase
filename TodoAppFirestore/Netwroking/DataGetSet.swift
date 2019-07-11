//
//  DataGetSet.swift
//  TodoAppFirestore
//
//  Created by Kashif Rizwan on 7/10/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct DataGetSet {
    let db = Firestore.firestore()
    func getData (completion: @escaping (_ error: String? , _ toDoData:[ToDo]?) -> ()){
        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("toDoList").getDocuments(completion: {(snapshot, error) in
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
    
    func addData(title: String, detail:String, completion: @escaping (_ error: String?) -> ()){
        let date = String(DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .long, timeStyle: .short))
        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("toDoList").addDocument(data: ["date":date,"title":title,"detail":detail], completion: {(error) in
            if let err = error{
                completion(err.localizedDescription)
            }else{
                completion(nil)
            }
        })
    }
    
    func deleteData(id:String, completion: @escaping (_ error: String?) -> ()){
        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("toDoList").document(id).delete(){(error) in
            if let err = error{
                completion(err.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
    
    func updateData(title: String, detail:String, uid:String, completion: @escaping (_ error: String?,_ data:ToDo?) -> ()){
        let date = String(DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .long, timeStyle: .short))
        self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("toDoList").document(uid).updateData(["date":date,"title":title,"detail":detail], completion: {(error) in
            if let err = error{
                completion(err.localizedDescription,nil)
            }else{
                completion(nil,ToDo(title: title, description: detail, date: date, uid: uid))
            }
        })
    }
    
}
