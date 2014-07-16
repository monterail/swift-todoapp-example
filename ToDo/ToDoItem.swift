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
    @NSManaged var position: Int16
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
    
    init() {
        deleteCompleted()
    }
    
    func generateRequest(predicate: NSPredicate?) -> NSFetchRequest {
        var request = NSFetchRequest(entityName: "ToDoItem")
        request.returnsObjectsAsFaults = false
        if predicate != nil {
            request.predicate = predicate
        }
        return request
    }
    
    func updateStatus(item: ToDoItem) {
        var completed = item.valueForKey("completed") as Bool
        item.setValue(!completed, forKey: "completed")
        save()
    }
    
    func updatePosition(item: ToDoItem, index: AnyObject) {
        item.setValue(index, forKey: "position")
    }
    
    func save() {
        context.performBlockAndWait {
            let error: NSErrorPointer = nil
            self.context.save(error)
        }
    }
    
    func create(name: String) -> ToDoItem {
        var newItem = NSEntityDescription.insertNewObjectForEntityForName("ToDoItem", inManagedObjectContext: context) as ToDoItem
        newItem.setValue(name, forKey: "name")
        newItem.setValue(false, forKey: "completed")
        save()
        return newItem
    }
    
    func delete(item: ToDoItem) {
        self.context.deleteObject(item)
        save()
    }
    
    func deleteCompleted() {
        var request = generateRequest(NSPredicate(format: "completed = %@", true))
        var toDelete = context.executeFetchRequest(request, error: nil) as NSArray
        for item in toDelete {
            if item.valueForKey("completed") as Bool == true {
                delete(item as ToDoItem)
            }
        }
    }
}
