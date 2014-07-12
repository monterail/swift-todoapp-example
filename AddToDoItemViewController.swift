//
//  AddToDoItemViewController.swift
//  ToDo
//
//  Created by Kamil Nicieja on 12/07/14.
//  Copyright (c) 2014 Kamil Nicieja. All rights reserved.
//

import UIKit

class AddToDoItemViewController: UIViewController {
    
    var newItem = ToDoItem(name: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet var textField: UITextField

    @IBOutlet var doneButton: UIBarButtonItem

    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (sender as? NSObject != doneButton) { return }
        
        if textField.text.utf16count > 0 {
            newItem.name = textField.text
            newItem.completed = false
        }
    }
}
