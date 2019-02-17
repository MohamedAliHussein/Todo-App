//
//  CoreDataStack.swift
//  To Do App
//
//  Created by Mohamed Ali on 2/6/19.
//  Copyright © 2019 mohamed ali. All rights reserved.
//

import Foundation
import CoreData



class CoreDataStack {
    var container : NSPersistentContainer {
        let container = NSPersistentContainer(name: "Todos")
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("Error :\(error!)")
            return
            }
        }
        return container
    }
    
    var managecontext : NSManagedObjectContext {
        return container.viewContext
    }
}
