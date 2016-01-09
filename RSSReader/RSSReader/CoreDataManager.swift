//
//  CoreDataManager.swift
//  RSSReader
//
//  Created by Eugeniy Popov on 09.01.16.
//  Copyright © 2016 Eugeniy Popov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var itemEntity : NSEntityDescription? {
        get {
            return NSEntityDescription.entityForName(GC.entityName, inManagedObjectContext: context)
        }
    }
    
    var context: NSManagedObjectContext {
        get {
            return appDelegate.managedObjectContext
        }
    }
    
    
    func contextSave() {
        
        do {
            try context.save()
        } catch {
            //            abort()
        }
    }
    
    
    func addItem() {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName(itemEntity!.name!, inManagedObjectContext: context) as! Item
        
        newItem.createdate = NSDate.init()
        newItem.title = "title"
        newItem.descr = "descr"
        newItem.image = ""
        newItem.sourcetitle = ""
        newItem.sourceurl = ""
        
        contextSave()
        
        
    }
    
}