//
//  signUp.swift
//  TodoAppFirestore
//
//  Created by Kashif Rizwan on 7/10/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct SignUpUser {
    private var name:String
    private var email:String
    private var password:String
    
    init(name:String, email:String, password:String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    func signUpRequest( completion: @escaping (_ error: String? , _ isLogin: Bool?) -> ()){
        Auth.auth().createUser(withEmail: self.email, password: self.password, completion: {(user, error) in
            if let err = error{
                completion(err.localizedDescription,false)
            }else{
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.name
                changeRequest?.commitChanges(completion: {(error) in
                    if let err = error{
                        print(err.localizedDescription)
                        completion(nil,true)
                    }else{
                        completion(nil,true)
                    }
                })
            }
        })
    }
    
}
