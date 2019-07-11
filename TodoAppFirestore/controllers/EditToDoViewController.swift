//
//  EditToDoViewController.swift
//  TodoAppFirestore
//
//  Created by Kashif Rizwan on 7/11/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit

class EditToDoViewController: UIViewController,editing {

    @IBOutlet weak var _title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var detail: UILabel!
    var data:ToDo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUi()
    }
    
    func loadUi(){
        self._title.text = self.data.title
        self.detail.text = self.data.description
        self.date.text = self.data.date
    }

    @IBAction func edit(_ sender: Any) {
        self.performSegue(withIdentifier: "edit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            let editTodocontroller = segue.destination as? DoneEditToDoViewController
            editTodocontroller!.data = self.data
            editTodocontroller?.editDelegate = self
        }
    }
    
    func doneWithEditdata(data: ToDo) {
        self.data = data
        self.loadUi()
    }

}
