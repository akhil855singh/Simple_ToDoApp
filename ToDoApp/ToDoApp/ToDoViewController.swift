//
//  ViewController.swift
//  ToDoApp
//
//  Created by Akhil Singh on 27/05/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {

    @IBOutlet weak var addItemsButton: UIButton!
    @IBOutlet weak var showCompletedButton: UIButton!
    var todoList:ToDoList
    
    @IBOutlet weak var itemSearchBar: UISearchBar!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    required init?(coder aDecoder: NSCoder) {
        todoList = ToDoList()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.allowsMultipleSelectionDuringEditing = true
        todoList.populateAllArrays(showCompletedButton.isSelected)
        tableView.reloadData()
    }
    
    @IBAction func addItems(_ sender: Any) {
        self.performSegue(withIdentifier: "AddItemSegue", sender: nil)
    }
    @IBAction func showCompleted(_ sender: Any) {
        showCompletedButton.isSelected = !showCompletedButton.isSelected
    }
    private func getPriorityForIndex(_ index:Int) -> Priority{
        return Priority(rawValue: index) ?? .no
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows{
            for indexPath in selectedRows.sorted(by: {$0.row > $1.row}){
                let priority = getPriorityForIndex(indexPath.section)
                todoList.remove(basedOn: priority, at: indexPath.row)
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(tableView.isEditing, animated: true)
        if tableView.isEditing{
            deleteBarButton.isEnabled = true
        }
        else{
            deleteBarButton.isEnabled = false
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let priority = getPriorityForIndex(section)
        if todoList.isListEmpty(){
            addItemsButton.isHidden = false
            showCompletedButton.isHidden = true
            itemSearchBar.isHidden = true
            self.navigationItem.leftBarButtonItem = nil
        }
        else{
            addItemsButton.isHidden = true
            showCompletedButton.isHidden = false
            itemSearchBar.isHidden = false
            self.navigationItem.leftBarButtonItem = editButtonItem
        }
        return todoList.toDoItems(for: priority).count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Priority.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ToDoItem"
        let cell:ToDoTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ToDoTableViewCell ?? ToDoTableViewCell()
        
        let priority = getPriorityForIndex(indexPath.section)
        let toDoItemsBasedOnPriority = todoList.toDoItems(for: priority)
        let toDoItemBasedOnPriority = toDoItemsBasedOnPriority[indexPath.row]
        cell.configureCheckmark(for: toDoItemBasedOnPriority)
        cell.configureText(for: toDoItemBasedOnPriority)
        cell.tintColor = appThemeColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let priority = getPriorityForIndex(section)
        var priorityString = ""
        switch priority {
        case .high:
            priorityString = "  High Priority Tasks"
        case .medium:
            priorityString =  "  Medium Priority Tasks"
        case .low:
            priorityString = "  Low Priority Tasks"
        case .no:
            priorityString = "  No Priority Tasks"
        }
        if todoList.isListEmpty(){
            priorityString = ""
        }
        return priorityString
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !tableView.isEditing{
                let priority = getPriorityForIndex(indexPath.section)
                let toDoItemsBasedOnPriority = todoList.toDoItems(for: priority)
                let toDoItemBasedOnPriority = toDoItemsBasedOnPriority[indexPath.row]
                if let cell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell{
                    let itemDict:NSDictionary = NSDictionary(dictionary: [!toDoItemBasedOnPriority.isCompleted:isCompleted])
                    toDoItemBasedOnPriority.isCompleted.toggle()
                    todoList.updateToDoItem(toDoItemBasedOnPriority, itemDict: itemDict as NSDictionary)
                    cell.configureCheckmark(for: toDoItemBasedOnPriority)
                }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourcePriority = getPriorityForIndex(sourceIndexPath.section)
        let toDoItemsBasedOnSourcePriority = todoList.toDoItems(for: sourcePriority)
        let destinationPriority = getPriorityForIndex(destinationIndexPath.section)
        self.todoList.moveItem(item: toDoItemsBasedOnSourcePriority[sourceIndexPath.row], fromPriority: sourcePriority, toPriority: destinationPriority, from: sourceIndexPath.row, to: destinationIndexPath.row)
        todoList.populateAllArrays(showCompletedButton.isSelected)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let priority = getPriorityForIndex(indexPath.section)
            todoList.remove(basedOn: priority, at: indexPath.row)
            todoList.populateAllArrays(showCompletedButton.isSelected)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" || segue.identifier == "EditItemSegue"{
            if let addItemViewController = segue.destination as? ItemDetailViewController{
                if let cell = sender as? UITableViewCell{
                    let indexPath = tableView.indexPath(for: cell)
                    let priorityObject = getPriorityForIndex(indexPath?.section ?? 0)
                    let toDoItem = todoList.toDoItems(for: priorityObject)[indexPath?.row ?? 0]
                    addItemViewController.toBeEditedItem = toDoItem
                    addItemViewController.toBeEditedIndex = indexPath
                    addItemViewController.itemList = todoList
                    addItemViewController.itemUpdateHandler = {(item,indexPath) in
                        if let index = indexPath{
                            self.replaceItem(item, index: index)
                        }
                        else{
                            self.addItem(item)
                        }
                    }
                }
                else{
                    addItemViewController.itemList = todoList
                    addItemViewController.itemUpdateHandler = {(item,indexPath) in
                        if let index = indexPath{
                            self.replaceItem(item, index: index)
                        }
                        else{
                            self.addItem(item)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func addItem(_ item:ToDoItem) {
        let countOfToDoItemsBasedOnPriority = todoList.toDoItems(for: Priority(rawValue: Int(item.itemPriority)) ?? .no).count
        todoList.addToDoItemToArray(item)
        todoList.populateAllArrays(showCompletedButton.isSelected)
        let indexPath = IndexPath(row: countOfToDoItemsBasedOnPriority, section: Int(item.itemPriority))
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    fileprivate func replaceItem(_ item:ToDoItem, index:IndexPath) {
        var toDoItemBasedOnPriority = todoList.toDoItems(for: Priority(rawValue: Int(item.itemPriority)) ?? .no)
        toDoItemBasedOnPriority[index.row] = item
        todoList.populateAllArrays(showCompletedButton.isSelected)
        tableView.reloadRows(at: [index], with: .automatic)
    }
}

