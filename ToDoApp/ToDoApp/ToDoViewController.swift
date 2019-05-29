//
//  ViewController.swift
//  ToDoApp
//
//  Created by Akhil Singh on 27/05/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {

    var todoList:ToDoList
    
    required init?(coder aDecoder: NSCoder) {
        todoList = ToDoList()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ToDoItem"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let toDoItem = todoList.todoItems[indexPath.row]
        configureText(for: cell, and: toDoItem)
        configureCheckmark(for: cell, and: toDoItem)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            let toDoItem = todoList.todoItems[indexPath.row]
            configureCheckmark(for: cell, and: toDoItem)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func configureCheckmark(for cell:UITableViewCell, and item:ToDoItem){
        
        if item.checked{
            cell.accessoryType = .none
        }
        else{
            cell.accessoryType = .checkmark
        }
        item.checked.toggle()
    }
    
    fileprivate func configureText(for cell:UITableViewCell, and item:ToDoItem){
        
        if let label = cell.viewWithTag(100) as? UILabel{
            label.text = item.text
        }
    }
}

