//
//  AddItemTableViewController.swift
//  ToDoApp
//
//  Created by Akhil Singh on 29/05/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//

import UIKit

protocol ItemDetailTableViewControllerDelegate: class{
    func itemDetailViewController(_ controller:ItemDetailViewController,didFinishUpdating item:ToDoItem, and indexPath:IndexPath?)
}

class ItemDetailViewController: UITableViewController {

    var addItemDelegate:ItemDetailTableViewControllerDelegate?
    var toBeEditedItem:ToDoItem?
    var toBeEditedIndex:IndexPath?
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var addItemTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let item = toBeEditedItem{
            addItemTextField.text = item.text
            self.title = "Edit Item"
        }
        else{
            self.title = "Add Item"
        }
        addItemTextField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func done(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        if let delegate = addItemDelegate{
            var toDoItem = ToDoItem(toDoName: addItemTextField.text ?? "", isChecked: false)
            if let editedItem = toBeEditedItem{
                toDoItem = editedItem
                toDoItem.text = addItemTextField.text ?? ""
            }
            delegate.itemDetailViewController(self, didFinishUpdating: toDoItem, and: toBeEditedIndex)
        }
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
