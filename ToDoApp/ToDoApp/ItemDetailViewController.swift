//
//  AddItemTableViewController.swift
//  ToDoApp
//
//  Created by Akhil Singh on 29/05/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//

import UIKit

class ItemDetailViewController: UITableViewController {

    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var addPriorityButton: UIButton!
    var toBeEditedItem:ToDoItem?
    var toBeEditedIndex:IndexPath?
    var priorityObject:Priority = .low
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var addItemTextField: UITextField!
    
    var itemUpdateHandler:((ToDoItem,IndexPath?)->Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let item = toBeEditedItem{
            addItemTextField.text = item.text
            self.title = "Edit Item"
            addPriorityButton.isHidden = true
        }
        else{
            self.title = "Add Item"
            addPriorityButton.isHidden = false
        }
        addItemTextField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    @IBAction func addPriority(_ sender: Any) {
        let priorityActionSheet = UIAlertController(title: "", message: "Select Priority", preferredStyle: .actionSheet)
        let highAction = UIAlertAction(title: "High", style: .default) { (action) in
            self.updatePriority(.high)
        }
        priorityActionSheet.addAction(highAction)
        let mediumAction = UIAlertAction(title: "Medium", style: .default) { (action) in
            self.updatePriority(.medium)
        }
        priorityActionSheet.addAction(mediumAction)
        let lowAction = UIAlertAction(title: "Low", style: .default) { (action) in
            self.updatePriority(.low)
        }
        priorityActionSheet.addAction(lowAction)
        self.present(priorityActionSheet, animated: true, completion: nil)
        priorityActionSheet.view.tintColor = appThemeColor
    }
    
    private func updatePriority(_ priority:Priority){
        priorityObject = priority
        doneBarButtonItem.isEnabled = true
        switch priority {
        case .high:
            priorityLabel.text = "!!!"
            break
        case .medium:
            priorityLabel.text = "!!"
            break
        case .low:
            priorityLabel.text = "!"
            break
        default:
            priorityLabel.text = ""
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func done(_ sender: Any) {
            if let handler = itemUpdateHandler{
                let toDoItem = ToDoItem(toDoName: addItemTextField.text ?? "", isChecked: false,priority: priorityObject)
                if let editedItem = toBeEditedItem{
                    toDoItem.checked = editedItem.checked
                    toDoItem.text = addItemTextField.text ?? ""
                }
                handler(toDoItem,toBeEditedIndex)
            }
        self.navigationController?.popViewController(animated: true)
    }
}

extension ItemDetailViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
              let stringRange = Range(range, in: oldText)  else {
            return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty{
            doneBarButtonItem.isEnabled = false
        }
        else{
            doneBarButtonItem.isEnabled = true
        }
        return true
    }
}
