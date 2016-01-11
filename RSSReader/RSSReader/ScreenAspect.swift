//
//  ScreenAspect.swift
//  npfn
//
//  Created by Eugeniy Popov on 14.08.15.
//  Copyright (c) 2015 Eugeniy Popov. All rights reserved.
//

import Foundation
import UIKit

class ScreenAspect {
    
    enum heightOrWidth {
        case height
        case width
    }
    
    class func partOfScreen(part : Int, type : heightOrWidth) -> CGFloat {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = (Int)(screenSize.width)
        let screenHeight = (Int)(screenSize.height)
        
        var result : Int!
        switch type {
        case .height :
            result = screenHeight / part
        case .width :
            result = screenWidth / part
        }

        return CGFloat(result)
    }
}