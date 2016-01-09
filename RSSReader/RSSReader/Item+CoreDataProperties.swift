//
//  Item+CoreDataProperties.swift
//  RSSReader
//
//  Created by Eugeniy Popov on 09.01.16.
//  Copyright © 2016 Eugeniy Popov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var title: String
    @NSManaged var descr: String
    @NSManaged var image: String
    @NSManaged var createdate: NSDate
    @NSManaged var sourcetitle: String
    @NSManaged var sourceurl: String

}
