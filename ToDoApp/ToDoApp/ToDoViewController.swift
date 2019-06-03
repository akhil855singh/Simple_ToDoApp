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
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todoItems.count
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
        
        let toDoItem = self.todoList.todoItems[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath){
            toDoItem.checked.toggle()
            self.configureCheckmark(for: cell, and: toDoItem)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            todoList.todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    fileprivate func configureCheckmark(for cell:UITableViewCell, and item:ToDoItem){
        
        if let check = cell.viewWithTag(1001) as? UILabel{
        if item.checked{
            check.text = "✓"
        }
        else{
            check.text = ""
        }
        }
    }
    
    fileprivate func configureText(for cell:UITableViewCell, and item:ToDoItem){
        
        if let label = cell.viewWithTag(100) as? UILabel{
            label.text = item.text
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" || segue.identifier == "EditItemSegue"{
            if let addItemViewController = segue.destination as? ItemDetailViewController{
                addItemViewController.addItemDelegate = self
                if let cell = sender as? UITableViewCell{
                    let indexPath = tableView.indexPath(for: cell)
                    let toDoItem = todoList.todoItems[indexPath?.row ?? 0]
                    addItemViewController.toBeEditedItem = toDoItem
                    addItemViewController.toBeEditedIndex = indexPath
                }
            }
        }
    }
    
    fileprivate func addItem(_ item:ToDoItem) {
        let countOfToDoItems = todoList.todoItems.count
        todoList.todoItems.append(item)
        let indexPath = IndexPath(row: countOfToDoItems, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    fileprivate func replaceItem(_ item:ToDoItem, index:IndexPath) {
        todoList.todoItems[index.row] = item
        tableView.reloadRows(at: [index], with: .automatic)
    }
}

extension ToDoViewController:ItemDetailTableViewControllerDelegate{
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishUpdating item: ToDoItem, and indexPath: IndexPath?) {
        if let index = indexPath{
            replaceItem(item, index: index)
        }
        else{
            addItem(item)
        }
    }
}

