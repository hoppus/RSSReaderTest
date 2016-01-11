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
    
    func addItemWith(title : String, description : String, imageUrl : String?, date : NSDate, sourceTitle : String, link : String, type : String) {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName(itemEntity!.name!, inManagedObjectContext: context) as! Item
        
        newItem.createdate = date
        newItem.title = title
        newItem.descr = description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        newItem.image = imageUrl
        newItem.sourcetitle = sourceTitle
        newItem.link = link
        newItem.rsstype = type
        
    }
    
    
}