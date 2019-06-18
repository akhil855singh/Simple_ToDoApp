//
//  AddItemTableViewController.swift
//  ToDoApp
//
//  Created by Akhil Singh on 29/05/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//

import UIKit

class ItemDetailViewController: UITableViewController {

    @IBOutlet weak var addNotesLabel: UILabel!
    @IBOutlet weak var itemNotesTextView: UITextView!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var addPriorityButton: UIButton!
    var toBeEditedItem:ToDoItem?
    var itemList:ToDoList?
    var toBeEditedIndex:IndexPath?
    var priorityObject:Priority = .no
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var addItemTextField: UITextField!
    
    var itemUpdateHandler:((ToDoItem,IndexPath?)->Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
        addItemTextField.attributedPlaceholder = NSAttributedString(string: "Add Item",
                                                               attributes: [NSAttributedString.Key.foregroundColor: appThemeColorFaded])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let item = toBeEditedItem{
            addItemTextField.text = item.itemName
            itemNotesTextView.text = item.itemDescription ?? ""
            if let notes = item.itemDescription{
                itemNotesTextView.text = notes
                showTextViewPlaceholderIfNotesAreEmpty(notes)
                
            }
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
    
    private func showTextViewPlaceholderIfNotesAreEmpty(_ notes:String){
        if notes.count > 0{
            addNotesLabel.isHidden = true
        }
        else{
            addNotesLabel.isHidden = false
        }
    }
    
    private func enableDoneButtonBasedOnChanges(_ changedString:String){
        if changedString.isEmpty{
            doneBarButtonItem.isEnabled = false
        }
        else{
            doneBarButtonItem.isEnabled = true
        }
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
        let trimmedItemName = addItemTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if itemList?.checkIfItemAlreadyExists(trimmedItemName ?? "") ?? false{
            let itemExistAlert = UIAlertController(title: "", message: "Item already exists", preferredStyle: .alert)
            let okAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            itemExistAlert.addAction(okAlertAction)
            self.present(itemExistAlert, animated: true, completion: nil)
            return
        }
            if let handler = itemUpdateHandler{
                if let editedItem = toBeEditedItem{
                    let itemData:NSDictionary = NSDictionary(dictionary: [itemName:trimmedItemName ?? "",itemPriority:editedItem.itemPriority,itemDescription:itemNotesTextView.text ?? ""])
                    itemList?.updateToDoItem(editedItem, itemDict: itemData as NSDictionary)
                    handler(editedItem, toBeEditedIndex)
                }
                else{
                    let itemData:NSDictionary = NSDictionary(dictionary: [itemName:trimmedItemName ?? "",isCompleted:false,itemPriority:priorityObject.rawValue,itemDescription:"",itemReminderDate:NSDate(),itemDescription:itemNotesTextView.text ?? ""])
                    let toDoItem = itemList?.createAToDoItem(itemData as NSDictionary) ?? ToDoItem()
                    handler(toDoItem,toBeEditedIndex)
                }
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
        enableDoneButtonBasedOnChanges(newText)
        return true
    }
}

extension ItemDetailViewController:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        showTextViewPlaceholderIfNotesAreEmpty(textView.text)
        enableDoneButtonBasedOnChanges(textView.text)
    }
}
