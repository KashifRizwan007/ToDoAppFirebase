//
//  DoneEditToDoViewController.swift
//  TodoAppFirestore
//
//  Created by Kashif Rizwan on 7/11/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit

protocol editing {
    func doneWithEditdata(data : ToDo)
}

class DoneEditToDoViewController: UIViewController {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var bodyText: UITextView!
    
    var data:ToDo!
    var boxView = UIView()
    private var dataUpdateSetObj = DataGetSet()
    var editDelegate:editing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyText.tintColor = .black
        titleText.tintColor = .black
        
        let myColor = UIColor.black
        bodyText.layer.borderColor = myColor.cgColor
        titleText.layer.borderColor = myColor.cgColor
        
        bodyText.layer.borderWidth = 2.0
        titleText.layer.borderWidth = 2.0
        self.loadUi()
    }
    
    func loadUi(){
        titleText.text = data.title
        bodyText.text = data.description
    }
    
    @IBAction func edit(_ sender: Any) {
        self._loader()
        if let details = self.bodyText.text, let title = self.titleText.text{
            self.dataUpdateSetObj.updateData(title: title, detail: details, uid: self.data.uid, completion: {(error, _data) in
                self.boxView.removeFromSuperview()
                if error != nil{
                    let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Success", message: "Todo Updated", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_) in
                        self.editDelegate!.doneWithEditdata(data: _data!)
                        self.navigationController?.popViewController(animated: true)
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
    
    private func _loader() {
        // You only need to adjust this frame to move it anywhere you want
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = UIColor.white
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = "Updating..."
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
    }
}
