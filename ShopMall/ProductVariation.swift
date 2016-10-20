//
//  ProductVariation.swift
//  ShopMall
//
//  Created by admin on 7/21/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class ProductVariation: NSObject {
    var id: NSNumber?
    var name: String?
    var imageUrl: String?
    var imageNSUrl: URL?
    var itemDetailPrice: String?
    var itemDescription: String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        id = dictionary["id"] as? NSNumber
        name = dictionary["name"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        itemDescription = dictionary["itemDescription"] as? String
        itemDetailPrice = dictionary["itemDetailPrice"] as? String
    }
}
