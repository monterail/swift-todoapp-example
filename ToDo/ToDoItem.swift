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
    
    func fetch() -> NSArray {
        var request = generateRequest(nil)
        return context.executeFetchRequest(request, error: nil) as NSArray
    }
    
    func updateStatus(item: NSManagedObject) {
        var completed = item.valueForKey("completed") as Bool
        item.setValue(!completed, forKey: "completed")
        save()
    }
    
    func save() {
        context.save(nil)
    }
    
    func create(name: String) {
        var newItem = NSEntityDescription.insertNewObjectForEntityForName("ToDoItem", inManagedObjectContext: context) as NSManagedObject
        newItem.setValue(name, forKey: "name")
        newItem.setValue(false, forKey: "completed")
        save()
    }
    
    func delete(item: NSManagedObject) {
        context.deleteObject(item)
    }
    
    func deleteCompleted() {
        var request = generateRequest(NSPredicate(format: "completed = %@", true))
        var toDelete = context.executeFetchRequest(request, error: nil) as NSArray
        for item in toDelete {
            if item.valueForKey("completed") as Bool == true {
                delete(item as NSManagedObject)
            }
        }
    }
}
