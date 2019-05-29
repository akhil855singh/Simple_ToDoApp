//
//  ToDoList.swift
//  ToDoApp
//
//  Created by Akhil Singh on 29/05/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//

import Foundation

class ToDoList{
    
    var todoItems:[ToDoItem] = []
    
    init() {
       let row0 = ToDoItem()
        row0.text = "Take a jog"
        
       let row1 = ToDoItem()
        row1.text = "Watch a movie"
        
      let row2 = ToDoItem()
        row2.text = "Code an app"
        
       let row3 = ToDoItem()
        row3.text = "Walk the dog"
        
       let row4 = ToDoItem()
        row4.text = "Study design patterns"
        
        todoItems.append(row0)
        todoItems.append(row1)
        todoItems.append(row2)
        todoItems.append(row3)
        todoItems.append(row4)
    }
}
