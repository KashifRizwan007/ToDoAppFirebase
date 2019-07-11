//
//  TodoDataViewController.swift
//  TodoAppFirestore
//
//  Created by Kashif Rizwan on 7/10/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit
import FirebaseAuth

class TodoDataViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var toDoTableView: UITableView!
    private var todoDataList:[ToDo]!
    private var msg = "Loading..."
    private var dataGetSetObj = DataGetSet()
    var refreshControl = UIRefreshControl()
    var boxView = UIView()
    var data:ToDo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        toDoTableView.tableFooterView = nil
        toDoTableView.rowHeight = UITableView.automaticDimension
        toDoTableView.estimatedRowHeight = 108
        toDoTableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
    }
    
    @IBAction func signOut(_ sender: Any) {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to Sign Out?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: {(_) in
            do {
                try Auth.auth().signOut()
                self.navigationController?.popViewController(animated: true)
            } catch let err {
                let _alert = UIAlertController(title: "Alert", message: err.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                _alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(_alert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        textLabel.text = "Deleting..."
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
    }
    
    @objc func loadData(){
        dataGetSetObj.getData(completion: {(error, toDoData) in
            DispatchQueue.main.async {
                self.refreshControl.beginRefreshing()
                if let err = error{
                    self.msg = err
                    self.todoDataList = nil
                    self.toDoTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }else{
                    self.refreshControl.endRefreshing()
                    if toDoData != nil{
                        self.todoDataList = toDoData
                        self.toDoTableView.reloadData()
                    }else{
                        self.msg = "No ToDos"
                        self.todoDataList = nil
                        self.toDoTableView.reloadData()
                    }
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.data = self.todoDataList[indexPath.row]
        self.performSegue(withIdentifier: "viewTodo", sender: self)
        self.toDoTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewTodo"{
            let viewTodocontroller = segue.destination as? EditToDoViewController
            viewTodocontroller!.data = self.data
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: NSInteger = 0
        
        if self.todoDataList != nil {
            self.toDoTableView.tableFooterView = nil
            numOfSection = 1
        } else {
            
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.toDoTableView.bounds.size.width, height: self.toDoTableView.bounds.size.height))
            noDataLabel.text = msg
            noDataLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.toDoTableView.tableFooterView = noDataLabel
            
        }
        return numOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell") as! TodoTableViewCell
        cell.details.text = self.todoDataList[indexPath.row].description
        cell.title.text = self.todoDataList[indexPath.row].title
        cell.date.text = self.todoDataList[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:  UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete selected item?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                self._loader()
                self.dataGetSetObj.deleteData(id: self.todoDataList[indexPath.row].uid, completion: {(_) in
                    self.boxView.removeFromSuperview()
                    self.loadData()
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
