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
    
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    required init?(coder aDecoder: NSCoder) {
        todoList = ToDoList()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let priority = getPriorityForIndex(section)
        switch priority {
        case .high:
            return "  High Priority Tasks"
        case .medium:
            return "  Medium Priority Tasks"
        case .low:
            return "  Low Priority Tasks"
        case .no:
            return "  No Priority Tasks"
        }
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
                    toDoItemBasedOnPriority.checked.toggle()
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
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let priority = getPriorityForIndex(indexPath.section)
            todoList.remove(basedOn: priority, at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" || segue.identifier == "EditItemSegue"{
            if let addItemViewController = segue.destination as? ItemDetailViewController{
                addItemViewController.addItemDelegate = self
                if let cell = sender as? UITableViewCell{
                    let indexPath = tableView.indexPath(for: cell)
                    let priorityObject = getPriorityForIndex(indexPath?.section ?? 0)
                    let toDoItem = todoList.toDoItems(for: priorityObject)[indexPath?.row ?? 0]
                    addItemViewController.toBeEditedItem = toDoItem
                    addItemViewController.toBeEditedIndex = indexPath
                }
            }
        }
    }
    
    fileprivate func addItem(_ item:ToDoItem) {
        let countOfToDoItemsBasedOnPriority = todoList.toDoItems(for: item.itemPriority).count
        todoList.addToDoItem(item)
        let indexPath = IndexPath(row: countOfToDoItemsBasedOnPriority, section: item.itemPriority.rawValue)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    fileprivate func replaceItem(_ item:ToDoItem, index:IndexPath) {
        var toDoItemBasedOnPriority = todoList.toDoItems(for: item.itemPriority)
        toDoItemBasedOnPriority[index.row] = item
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

