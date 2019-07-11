//
//  ViewController.swift
//  TodoAppFirestore
//
//  Created by Kashif Rizwan on 7/10/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,setUserInfo {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: ButtonDesign!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    private var loginObj:loginUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.isHidden = true
        self.loader.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "fromLogin"{
            let signUpVc = segue.destination as! SignUpViewController
            signUpVc.delegate = self
        }
    }
    
    @IBAction func loginPress(_ sender: Any) {
        self.loader.startAnimating()
        self.loginBtn.isEnabled = false
        self.email.text = "kashifrizwan3857@gmail.com"
        self.password.text = "qwerty"
        if let email = self.email.text, let password = self.password.text{
            self.loginObj = loginUser(email: email, password: password)
            self.loginObj.loginRequest(completion: {(error, isLogin) in
                self.loader.stopAnimating()
                self.loginBtn.isEnabled = true
                if error != nil{
                    let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Success", message: "You are logged into your account.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_) in
                        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let centerVC = mainStoryBoard.instantiateViewController(withIdentifier: "InitialScreenController") as! InitialViewController
                        // setting the login status to true
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.synchronize()
                        appDel.window!.rootViewController = centerVC
                        appDel.window!.makeKeyAndVisible()
                        //self.performSegue(withIdentifier: "fromLogin", sender: nil)
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
    func fillFields(email: String, password: String) {
        self.email.text = email
        self.password.text = password
    }

}

