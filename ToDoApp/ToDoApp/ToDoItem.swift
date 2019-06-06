//
//  ToDoItem.swift
//  ToDoApp
//
//  Created by Akhil Singh on 28/05/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//

import Foundation

enum Priority:Int,CaseIterable {
    case high,
    medium,
    low,
    no
}

class ToDoItem{
    @objc var text = ""
    var checked = false
    var itemPriority:Priority = .no
    
    init(toDoName:String, isChecked:Bool, priority:Priority) {
        self.text = toDoName
        self.checked = isChecked
        self.itemPriority = priority
    }
}
