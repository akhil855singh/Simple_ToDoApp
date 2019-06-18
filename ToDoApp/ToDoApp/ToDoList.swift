//
//  ToDoList.swift
//  ToDoApp
//
//  Created by Akhil Singh on 29/05/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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
    
    func addToDoItemToArray(_ toDoItem:ToDoItem){
        if let priority = Priority(rawValue: Int(toDoItem.itemPriority)){
        switch priority {
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
    }
    
    func populateAllArrays(_ showCompleted:Bool){
        highPriorityToDoItems = populateRespectiveArraysBasedOnPriority(.high, showCompleted: showCompleted)
        mediumPriorityToDoItems = populateRespectiveArraysBasedOnPriority(.medium, showCompleted: showCompleted)
        lowPriorityToDoItems = populateRespectiveArraysBasedOnPriority(.low, showCompleted: showCompleted)
        noPriorityToDoItems = populateRespectiveArraysBasedOnPriority(.no, showCompleted: showCompleted)
    }
    
    private func populateRespectiveArraysBasedOnPriority(_ priority:Priority, showCompleted:Bool) -> [ToDoItem]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return []
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
        fetchRequest.returnsObjectsAsFaults = false
        let priorityKeyPredicate = NSPredicate(format: "\(itemPriority) = %d", priority.rawValue)
        let completedKeyPredicate = NSPredicate(format: "\(isCompleted) = %d", showCompleted)
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [priorityKeyPredicate, completedKeyPredicate])
        fetchRequest.predicate = andPredicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: itemName, ascending: true)]
        do{
            let items = try managedObjectContext.fetch(fetchRequest)
            return items
        }
        catch{
            print("failed")
        }
        return []
    }
    
    func createAToDoItem(_ itemDict:NSDictionary) -> ToDoItem{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return ToDoItem()
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "ToDoItem", in: managedObjectContext){
            let toDoItem = ToDoItem(entity: entity, insertInto: managedObjectContext)
            toDoItem.itemName = itemDict.value(forKey: itemName) as? String
            toDoItem.itemDescription = itemDict.value(forKey: itemDescription) as? String
            toDoItem.isCompleted = itemDict.value(forKey: isCompleted) as? Bool ?? false
            toDoItem.itemPriority = Int16(itemDict.value(forKey: itemPriority) as? Int ?? 0)
            toDoItem.itemReminderDate = itemDict.value(forKey: itemReminderDate) as? NSDate
            saveContextForManagedObjectContext(managedObjectContext)
            return toDoItem
        }
        return ToDoItem()
    }
    
    func updateToDoItem(_ item:ToDoItem, itemDict:NSDictionary){
        if let name = itemDict.value(forKey: itemName){
            item.itemName = name as? String
        }
        if let description = itemDict.value(forKey: itemDescription){
            item.itemDescription = description as? String
        }
        if let completed = itemDict.value(forKey: isCompleted){
            item.isCompleted = completed as? Bool ?? false
        }
        if let priority = itemDict.value(forKey: itemPriority){
            item.itemPriority = Int16(priority as? Int ?? 0)
        }
        if let reminder = itemDict.value(forKey: itemReminderDate){
            item.itemReminderDate = reminder as? NSDate
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        saveContextForManagedObjectContext(managedObjectContext)
    }
    
    func deleteItem(_ item:ToDoItem){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        managedObjectContext.delete(item)
        saveContextForManagedObjectContext(managedObjectContext)
    }
    
    func checkIfItemAlreadyExists(_ name:String) -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return false
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "\(itemName) = %@", name)
        do{
            let items = try managedObjectContext.fetch(fetchRequest)
            if items.count > 0{
                return true
            }
            else{
                return false
            }
        }
        catch{
            print("failed")
        }
        return false
    }
    
    func saveContextForManagedObjectContext(_ managedObjectContext:NSManagedObjectContext){
        do {
            try managedObjectContext.save()
        }
        catch let error as NSError{
            print("could not save .\(error.userInfo)")
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
        let itemData:NSDictionary = NSDictionary(dictionary: [itemPriority:toPriority.rawValue])
        updateToDoItem(item, itemDict: itemData)
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
        var toDoItem:ToDoItem = ToDoItem()
        switch priorityObject {
        case .high:
            toDoItem = highPriorityToDoItems[index]
            highPriorityToDoItems.remove(at: index)
        case .medium:
            toDoItem = mediumPriorityToDoItems[index]
            mediumPriorityToDoItems.remove(at: index)
        case .low:
            toDoItem = lowPriorityToDoItems[index]
            lowPriorityToDoItems.remove(at: index)
        case .no:
            toDoItem = noPriorityToDoItems[index]
            noPriorityToDoItems.remove(at: index)
        }
        deleteItem(toDoItem)
    }
}
