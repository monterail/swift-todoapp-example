//
//  ToDoListTableViewController.swift
//  ToDo
//
//  Created by Kamil Nicieja on 12/07/14.
//  Copyright (c) 2014 Kamil Nicieja. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {
    var toDoItems = NSArray()
    let store = ToDoItemStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    func loadData() {
        toDoItems = store.fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }

    @IBAction func unwindToList(segue:UIStoryboardSegue) {
        let source = segue.sourceViewController as AddToDoItemViewController
        let field = source.textField as UITextField
        if field.text != nil {
            loadData()
            tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        let identifier = "ListPrototypeCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell
        var item = toDoItems[indexPath.row] as NSManagedObject
        cell.textLabel.text = item.valueForKey("name") as String
        setCellStatus(cell, item: item)
        return cell
    }

    func setCellStatus(cell: UITableViewCell, item: NSManagedObject) {
        let checked = UITableViewCellAccessoryType.Checkmark
        let none = UITableViewCellAccessoryType.None
        var completed = item.valueForKey("completed") as Bool
        cell.accessoryType = completed ? checked : none
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        var tappedItem = toDoItems[indexPath.row] as ToDoItem
        store.updateStatus(tappedItem)
        
        loadData()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }

}
