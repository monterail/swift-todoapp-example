//
//  AddToDoItemViewController.swift
//  ToDo
//
//  Created by Kamil Nicieja on 12/07/14.
//  Copyright (c) 2014 Kamil Nicieja. All rights reserved.
//

import UIKit
import CoreData

class AddToDoItemViewController: UIViewController {
    @IBOutlet var textField: UITextField
    @IBOutlet var doneButton: UIBarButtonItem
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (sender as? NSObject != doneButton) { return }
        
        if textField.text.utf16count > 0 {
            var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            var context: NSManagedObjectContext = appDelegate.managedObjectContext
            
            var newItem = NSEntityDescription.insertNewObjectForEntityForName("ToDoItem", inManagedObjectContext: context) as ToDoItem
            
            newItem.setValue(textField.text, forKey: "name")
            newItem.setValue(false, forKey: "completed")
        }
    }
}
