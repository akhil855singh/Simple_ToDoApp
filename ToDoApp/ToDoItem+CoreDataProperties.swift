//
//  ToDoItem+CoreDataProperties.swift
//  ToDoApp
//
//  Created by Akhil Singh on 12/06/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var itemName: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var itemDescription: String?
    @NSManaged public var itemPriority: Int16
    @NSManaged public var itemReminderDate: NSDate?

}
