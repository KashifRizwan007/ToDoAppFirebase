//
//  SignUpViewController.swift
//  TodoAppFirestore
//
//  Created by Kashif Rizwan on 7/10/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit

protocol setUserInfo {
    func fillFields(email:String, password:String)
}

class SignUpViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpBtn: ButtonDesign!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    private var signUpObj:SignUpUser!
    var delegate:setUserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.isHidden = true
        self.loader.hidesWhenStopped = true
    }
    @IBAction func SignUp(_ sender: Any) {
        self.loader.startAnimating()
        self.signUpBtn.isEnabled = false
        if let name = self.name.text, let email = self.email.text, let password = self.password.text {
            self.signUpObj = SignUpUser(name: name, email: email, password: password)
            self.signUpObj.signUpRequest(completion: {(error, isLogin) in
                self.loader.stopAnimating()
                self.signUpBtn.isEnabled = true
                if error != nil{
                    let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Success", message: "Account created.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_) in
                        if self.delegate != nil{
                            self.delegate?.fillFields(email: email, password: password)
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please fill all fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
