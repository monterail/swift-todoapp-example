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
