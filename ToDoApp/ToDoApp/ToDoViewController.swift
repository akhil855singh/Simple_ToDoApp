//
//  ViewController.swift
//  ToDoApp
//
//  Created by Akhil Singh on 27/05/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {

    var row0:ToDoItem
    var row1:ToDoItem
    var row2:ToDoItem
    var row3:ToDoItem
    var row4:ToDoItem

    
    required init?(coder aDecoder: NSCoder) {
        row0 = ToDoItem()
        row0.text = "Take a jog"
        
        row1 = ToDoItem()
        row1.text = "Watch a movie"
        
        row2 = ToDoItem()
        row2.text = "Code an app"
        
        row3 = ToDoItem()
        row3.text = "Walk the dog"
        
        row4 = ToDoItem()
        row4.text = "Study design patterns"
        
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
            
            var labelText = ""
            switch indexPath.row{
            case 0:
                labelText = row0.text
            case 1:
                labelText = row1.text
            case 2:
                labelText = row2.text
            case 3:
                labelText = row3.text
            case 4:
                labelText = row4.text
            default:
                labelText = "Sleep"
                }
                label.text = labelText
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
        switch indexPath.row{
        case 0:
            if row0.checked{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
            row0.checked = !row0.checked
        case 1:
            if row1.checked{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
            row1.checked = !row1.checked
        case 2:
            if row2.checked{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
            row2.checked = !row2.checked
        case 3:
            if row3.checked{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
            row3.checked = !row3.checked
        case 4:
            if row4.checked{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
            row4.checked = !row4.checked
        default:
            break
        }
    }

}

