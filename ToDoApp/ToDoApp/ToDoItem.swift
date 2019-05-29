//
//  ToDoItem.swift
//  ToDoApp
//
//  Created by Akhil Singh on 28/05/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//

import Foundation

class ToDoItem{
    var text = ""
    var checked = false
    
    init(toDoName:String, isChecked:Bool) {
        self.text = toDoName
        self.checked = isChecked
    }
}
