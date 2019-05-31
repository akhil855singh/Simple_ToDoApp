//
//  AddItemTableViewController.swift
//  ToDoApp
//
//  Created by Akhil Singh on 29/05/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {

    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var addItemTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    }
    
}

extension AddItemTableViewController:UITextFieldDelegate{
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
