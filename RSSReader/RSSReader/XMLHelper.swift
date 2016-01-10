//
//  XMLHelper.swift
//  RSSReader
//
//  Created by Eugeniy Popov on 10.01.16.
//  Copyright © 2016 Eugeniy Popov. All rights reserved.
//

import Foundation
import SWXMLHash

extension XMLElement {
    func getListOfChildrens() -> [XMLElement] {
        
        let elementIndexer = XMLIndexer(self)
        var list = [XMLElement]()
        
        for child in elementIndexer.children {
            if child.element?.name == GC.xmlItemName {
                list.append(child.element!)
            }
        }
        
        return list
    }
    

}