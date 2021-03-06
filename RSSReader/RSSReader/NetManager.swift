//
//  NetManager.swift
//  RSSReader
//
//  Created by Eugeniy Popov on 10.01.16.
//  Copyright © 2016 Eugeniy Popov. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash
import CoreData
import SwiftDate

class NetManager {
    
    static let sharedManager = NetManager()
    
    enum rssType : String {
        case lenta = "http://lenta.ru/rss"
        case gazeta = "http://www.gazeta.ru/export/rss/lenta.xml"
    }
    
    func getDataFromNet(completionBlock : () -> ()) {
        
        let arrayOfRss = [rssType.lenta.rawValue, rssType.gazeta.rawValue]
        
        for currentRSS in arrayOfRss {
            
            Alamofire.request(.GET, currentRSS)
                .response { (request, response, data, error) in
                    
                    if error == nil {
                        let xml = SWXMLHash.parse(data!)
                        
                        self.parseXmlToCoreData(xml)
                        
                    } else {
                        print(error.debugDescription)
                    }
                    
                    if currentRSS == arrayOfRss.last {
                        completionBlock()
                    }
            }
        }
    }
}



extension NetManager {
    
    func parseXmlToCoreData(xmlData:XMLIndexer) {
        
        do {
            let itemsList = try xmlData["rss"]["channel"].byKey(GC.xmlItemName)
            
            for element in itemsList {
                
                let link = try element.byKey("link").element?.text
                let title = try element.byKey("title").element?.text
                let description = try element.byKey("description").element?.text
                var imageUrl : String?
                do {
                    imageUrl = try element.byKey("enclosure").element?.attributes["url"]
                } catch { }
                
                let source = xmlData["rss"]["channel"]["title"].element?.text
                
                let dateString = try element.byKey("pubDate").element?.text
                var pubDate = NSDate()
                
                if dateString != nil {
                    let dateFormatter = NSDateFormatter()
                    /* Sun, 10 Jan 2016 03:07:11 +0300*/
                    dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
                    
                    if let date = dateFormatter.dateFromString(dateString!) {
                        pubDate = date
                    }
                }
                
                if isItNewItem(link!) {
                    
                    CoreDataManager.sharedManager.addItemWith(title!, description: description!, imageUrl: imageUrl, date: pubDate, sourceTitle: source!, link: link!)
                    
                } else  { continue }
            }
            
        } catch {  }
        
    }
    
    
    func isItNewItem(link : String) -> Bool {
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(GC.entityName, inManagedObjectContext: CoreDataManager.sharedManager.context)
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format: "link = %@", link)
        fetchRequest.predicate = predicate
        
        do {
            let results = try CoreDataManager.sharedManager.context.executeFetchRequest(fetchRequest)
            
            if results.count > 0 {
                return false
            }
            
        } catch { }
        
        return true
    }
    
    
}