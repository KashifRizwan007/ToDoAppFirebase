//
//  login.swift
//  TodoAppFirestore
//
//  Created by Kashif Rizwan on 7/10/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import Foundation
import FirebaseAuth

struct loginUser {
    private var email:String
    private var password:String
    
    init(email:String, password:String) {
        self.email = email
        self.password = password
    }
    
    func loginRequest( completion: @escaping (_ error: String? , _ isLogin: Bool?) -> ()){
        Auth.auth().signIn(withEmail: self.email, password: self.password, completion: {(user,error) in
            if let err = error{
                print(err.localizedDescription)
                completion(err.localizedDescription,false)
            }else{
                completion(nil,true)
            }
        })
    }
    
}
