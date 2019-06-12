//
//  ToDoList.swift
//  ToDoApp
//
//  Created by Akhil Singh on 29/05/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//

import Foundation

enum Priority:Int,CaseIterable {
    case high,
    medium,
    low,
    no
}

class ToDoList{
    
    private var highPriorityToDoItems:[ToDoItem] = []
    private var mediumPriorityToDoItems:[ToDoItem] = []
    private var lowPriorityToDoItems:[ToDoItem] = []
    private var noPriorityToDoItems:[ToDoItem] = []
    
    init() {
       
    }
    
    func addToDoItem(_ toDoItem:ToDoItem){
        switch toDoItem.itemPriority {
        case .high:
            highPriorityToDoItems.append(toDoItem)
        case .medium:
            mediumPriorityToDoItems.append(toDoItem)
        case .low:
            lowPriorityToDoItems.append(toDoItem)
        case .no:
            noPriorityToDoItems.append(toDoItem)
        }
    }
    
    func toDoItems(for priority:Priority) -> [ToDoItem]{
        switch priority {
        case .high:
            return highPriorityToDoItems
        case .medium:
            return mediumPriorityToDoItems
        case .low:
            return lowPriorityToDoItems
        case .no:
            return noPriorityToDoItems
        }
    }
    
    func isListEmpty() -> Bool{
        if highPriorityToDoItems.count == 0 && mediumPriorityToDoItems.count == 0 && lowPriorityToDoItems.count == 0 && noPriorityToDoItems.count == 0{
            return true
        }
        else{
            return false
        }
    }
    
    func moveItem(item:ToDoItem, fromPriority:Priority, toPriority:Priority, from fromIndex:Int, to toIndex:Int){
        switch fromPriority {
        case .high:
            highPriorityToDoItems.remove(at: fromIndex)
        case .medium:
            mediumPriorityToDoItems.remove(at: fromIndex)
        case .low:
            lowPriorityToDoItems.remove(at: fromIndex)
        case .no:
            noPriorityToDoItems.remove(at: fromIndex)
        }
        
        switch toPriority {
        case .high:
            highPriorityToDoItems.insert(item, at: toIndex)
        case .medium:
            mediumPriorityToDoItems.insert(item, at: toIndex)
        case .low:
            lowPriorityToDoItems.insert(item, at: toIndex)
        case .no:
            noPriorityToDoItems.insert(item, at: toIndex)
        }
    }
    
    func remove(basedOn priorityObject:Priority, at index:Int){
        switch priorityObject {
        case .high:
            highPriorityToDoItems.remove(at: index)
        case .medium:
            mediumPriorityToDoItems.remove(at: index)
        case .low:
            lowPriorityToDoItems.remove(at: index)
        case .no:
            noPriorityToDoItems.remove(at: index)
        }
    }
}
