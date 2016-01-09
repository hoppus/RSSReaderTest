//
//  ViewController.swift
//  RSSReader
//
//  Created by Eugeniy Popov on 09.01.16.
//  Copyright © 2016 Eugeniy Popov. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {
    
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    var pullToRefresh = UIRefreshControl()
    
    let unselectedCellRowHeight : CGFloat = ScreenAspect.partOfScreen(GC.partOfImageToScreenStateClose, type: .width) - 20
    var selectedCellIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pullToRefresh.addTarget(self, action: "pullToRefreshAction", forControlEvents: .ValueChanged)
        tableView.addSubview(pullToRefresh)
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
    }
    
    func pullToRefreshAction() {
        CoreDataManager.sharedManager.addItem()
        pullToRefresh.endRefreshing()
    }
    
    func configureCell(cell: ListCell, atIndexPath indexPath: NSIndexPath) {
        
        
        cell.timeLabel.text = "15:15"
        //   let word = self.fetchedResultsController.objectAtIndexPath(indexPath) as!
        
        //        let word = DataBase.sharedManager.words[indexPath.row]
        
        //    cell.engWord.text = word.text
    }
    
}


extension ListTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResultsController.sections![section]
        let rows = sectionInfo.numberOfObjects
        return rows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(GC.listCellID, forIndexPath: indexPath) as! ListCell
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        
        
        return cell
    }
    
    
    
    
}

extension ListTableViewController {
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let selectedCellIndexPath = selectedCellIndexPath {
            if selectedCellIndexPath == indexPath {
                return UITableViewAutomaticDimension
            }
        }
        return unselectedCellRowHeight
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectedCellIndexPath = selectedCellIndexPath {
            if selectedCellIndexPath == indexPath {
                self.selectedCellIndexPath = nil
            } else {
                self.selectedCellIndexPath = indexPath
            }
        } else {
            selectedCellIndexPath = indexPath
        }
        tableView.beginUpdates()
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ListCell
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            if self.selectedCellIndexPath != nil {
                cell.cellChangeState(.open)
            } else {
                cell.cellChangeState(.close)
            }
            cell.updateTextContainerFrame()
        })
        
        
        tableView.endUpdates()
    }
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