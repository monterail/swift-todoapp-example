//
//  ToDoListTableViewController.swift
//  ToDo
//
//  Created by Kamil Nicieja on 12/07/14.
//  Copyright (c) 2014 Kamil Nicieja. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    var todoItems = [ToDoItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
    }
    
    func loadInitialData() {
        var milk = ToDoItem(name: "Milk")
        var bread = ToDoItem(name: "Bread")
        var butter = ToDoItem(name: "Butter")
        todoItems = [milk, bread, butter]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    @IBAction func unwindToList(segue:UIStoryboardSegue) {
        let source = segue.sourceViewController as AddToDoItemViewController
        let item = source.newItem as ToDoItem
        if item.name != nil {
            todoItems += item
            tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        let identifier = "ListPrototypeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell
        let item = todoItems[indexPath.row]
        cell.textLabel.text = item.name
        setCellStatus(cell, item: item)
        return cell
    }
    
    func setCellStatus(cell: UITableViewCell, item: ToDoItem) {
        let checked = UITableViewCellAccessoryType.Checkmark
        let none = UITableViewCellAccessoryType.None
        cell.accessoryType = item.completed ? checked : none
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let tappedItem = todoItems[indexPath.row]
        tappedItem.completed = !tappedItem.completed
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }

}
