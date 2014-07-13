//
//  ToDoListTableViewController.swift
//  ToDo
//
//  Created by Kamil Nicieja on 12/07/14.
//  Copyright (c) 2014 Kamil Nicieja. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var toDoItems = NSMutableArray()

    @IBOutlet var addButton: UIBarButtonItem
    
    @lazy
    var fetchedResultsController: NSFetchedResultsController =
    {
        var fetch: NSFetchRequest = NSFetchRequest(entityName: "ToDoItem")
        fetch.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        
        var frc: NSFetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: ToDoItemStore.instance.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        super.viewDidLoad()
        loadData(false)
    }

    func loadData(reload: Bool) {
        var context = fetchedResultsController.managedObjectContext
        context.performBlockAndWait {
            let error: NSErrorPointer = nil
            self.fetchedResultsController.performFetch(error)
            self.toDoItems = NSMutableArray(array: self.fetchedResultsController.fetchedObjects)
            
            if reload {
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return fetchedResultsController.sections.count
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections[section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    @IBAction func unwindToList(segue:UIStoryboardSegue) {
        let source = segue.sourceViewController as AddToDoItemViewController
        let field = source.textField as UITextField
        if field.text != nil {
            loadData(true)
        }
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        var cell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as UITableViewCell

        var item: ToDoItem = fetchedResultsController.objectAtIndexPath(indexPath) as ToDoItem
        cell.textLabel.text = item.name
        
        setCellStatus(cell, item: item)
        
        return cell
    }

    func setCellStatus(cell: UITableViewCell, item: ToDoItem) {
        let checked = UITableViewCellAccessoryType.Checkmark
        let none = UITableViewCellAccessoryType.None
        var completed = item.valueForKey("completed") as Bool
        
        cell.accessoryType = completed ? checked : none
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var tappedItem: ToDoItem = fetchedResultsController.objectAtIndexPath(indexPath) as ToDoItem
        ToDoItemStore.instance.updateStatus(tappedItem)
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
    
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            var item: ToDoItem = fetchedResultsController.objectAtIndexPath(indexPath) as ToDoItem
            ToDoItemStore.instance.delete(item)
            loadData(false)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
        if editing == true {
            addButton.enabled = false
        } else {
            addButton.enabled = true
        }
    }
    
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView!, moveRowAtIndexPath sourceIndexPath: NSIndexPath!, toIndexPath destinationIndexPath: NSIndexPath!) {
        var newItem = toDoItems.objectAtIndex(sourceIndexPath.row) as ToDoItem
        var oldItem = toDoItems.objectAtIndex(destinationIndexPath.row) as ToDoItem
        ToDoItemStore.instance.updatePosition(newItem, index: destinationIndexPath.row)
        ToDoItemStore.instance.updatePosition(oldItem, index: sourceIndexPath.row)
    }
}
