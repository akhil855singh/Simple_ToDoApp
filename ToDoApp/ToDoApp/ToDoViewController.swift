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
        
        if let label = cell.viewWithTag(100) as? UILabel{
            let toDoItem = todoList.todoItems[indexPath.row]
            label.text = toDoItem.text
        }
        
        configureCheckmark(for: cell, and: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            configureCheckmark(for: cell, and: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func configureCheckmark(for cell:UITableViewCell, and indexPath:IndexPath){
        
        let toDoItem = todoList.todoItems[indexPath.row]

        if toDoItem.checked{
            cell.accessoryType = .none
        }
        else{
            cell.accessoryType = .checkmark
        }
        toDoItem.checked.toggle()
    }

}

