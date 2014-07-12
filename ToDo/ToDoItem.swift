//
//  ToDoItem.swift
//  ToDo
//
//  Created by Kamil Nicieja on 12/07/14.
//  Copyright (c) 2014 Kamil Nicieja. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
    var completed:Bool = false
    var name: String?
    
    init(name: String?) {
        self.name = name
    }
}
