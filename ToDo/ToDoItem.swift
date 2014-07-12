//
//  ToDoItem.swift
//  ToDo
//
//  Created by Kamil Nicieja on 12/07/14.
//  Copyright (c) 2014 Kamil Nicieja. All rights reserved.
//

import UIKit
import CoreData

class ToDoItem: NSManagedObject {
    @NSManaged var completed:Bool
    @NSManaged var name: String
}

class ToDoItemStore {
    let context: NSManagedObjectContext = {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    class var instance: ToDoItemStore {
        struct Static {
            static let instance: ToDoItemStore = ToDoItemStore()
        }
        return Static.instance
    }
    
    func fetch() -> NSArray {
        var request = NSFetchRequest(entityName: "ToDoItem")
        var items: NSArray = context.executeFetchRequest(request, error: nil)
        return items
    }
    
    func updateStatus(item: ToDoItem) {
        var completed = item.valueForKey("completed") as Bool
        item.setValue(!completed, forKey: "completed")
        context.save(nil)
    }
    
    func create(name: String) {
        var newItem = NSEntityDescription.insertNewObjectForEntityForName("ToDoItem", inManagedObjectContext: context) as ToDoItem
        newItem.setValue(name, forKey: "name")
        newItem.setValue(false, forKey: "completed")
    }
}
