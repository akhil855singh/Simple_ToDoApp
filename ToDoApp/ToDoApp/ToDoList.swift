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
       let row0 = ToDoItem(toDoName: "Take a jog", isChecked: false)
       let row1 = ToDoItem(toDoName: "Watch a movie", isChecked: false)
       let row2 = ToDoItem(toDoName: "Code an app", isChecked: false)
       let row3 = ToDoItem(toDoName: "Walk the dog", isChecked: false)
       let row4 = ToDoItem(toDoName: "Study design patterns", isChecked: false)
        
        todoItems.append(row0)
        todoItems.append(row1)
        todoItems.append(row2)
        todoItems.append(row3)
        todoItems.append(row4)
    }
    
    func createNewToDoItem(){
        let todo = ToDoItem(toDoName: generateRandomText(), isChecked: true)
        todoItems.append(todo)
    }
    
    fileprivate func generateRandomText() -> String{
        let nameArray = ["New todo item", "Generic todo", "Fill me out", "I need something to do", "Much todo about nothing"]
        let randomInt = Int.random(in: 0..<nameArray.count)
        return nameArray[randomInt]
    }
}
