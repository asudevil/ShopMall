//
//  Attributes.swift
//  ShopMall
//
//  Created by Brian Voong on 7/21/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class Attributes: NSObject {
    
    var centerXConstant: NSNumber?
    var leftAnchorConstant: NSNumber?
    var rightAnchorConstant: NSNumber?
    
    var centerYConstant: NSNumber?
    var topAnchorConstant: NSNumber?
    var bottomAnchorConstant: NSNumber?
    
    var width: NSNumber?
    var height: NSNumber?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        centerXConstant = dictionary["centerXConstant"] as? NSNumber
        leftAnchorConstant = dictionary["leftAnchorConstant"] as? NSNumber
        rightAnchorConstant = dictionary["rightAnchorConstant"] as? NSNumber
        
        centerYConstant = dictionary["centerYConstant"] as? NSNumber
        topAnchorConstant = dictionary["topAnchorConstant"] as? NSNumber
        bottomAnchorConstant = dictionary["bottomAnchorConstant"] as? NSNumber
        
        width = dictionary["width"] as? NSNumber
        height = dictionary["height"] as? NSNumber
    }
    
}
