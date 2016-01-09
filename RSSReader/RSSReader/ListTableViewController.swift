//
//  ViewController.swift
//  RSSReader
//
//  Created by Eugeniy Popov on 09.01.16.
//  Copyright © 2016 Eugeniy Popov. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataManager.sharedManager.addItem()

        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
    }
    
    func configureCell(cell: ListCell, atIndexPath indexPath: NSIndexPath) {
        
        
        cell.timeLabel.text = "15:15"
        //   let word = self.fetchedResultsController.objectAtIndexPath(indexPath) as!
        
        //        let word = DataBase.sharedManager.words[indexPath.row]
        
        //    cell.engWord.text = word.text
    }
    
}


extension ListTableViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResultsController.sections![section]
        let rows = sectionInfo.numberOfObjects
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(GC.listCellID, forIndexPath: indexPath) as! ListCell
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        
        
        return cell
    }
    
    
    
    
}

extension UITableViewDelegate {
    
}



extension ListTableViewController : NSFetchedResultsControllerDelegate {
    
    
    var fetchedResultsController: NSFetchedResultsController {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName(GC.entityName, inManagedObjectContext: CoreDataManager.sharedManager.context)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 25
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "createdate", ascending: true)
        //let sortDescriptorMemorability = NSSortDescriptor(key: "memorability", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedManager.context, sectionNameKeyPath: nil, cacheName: nil)
        
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            
            self.configureCell(self.tableView.cellForRowAtIndexPath(indexPath!) as! ListCell, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    
}