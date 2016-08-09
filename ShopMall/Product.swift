//
//  Product.swift
//  ShopMall
//
//  Created by Brian Voong on 7/21/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class Product: NSObject {
    
    var id: NSNumber?
    var name: String?
    var logoImage: String?
    var catalogImageUrl: String?
    var catalogDetail: String?
    var itemPrice: String?
    var productVariations: [ProductVariation]?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        id = dictionary["id"] as? NSNumber
        name = dictionary["name"] as? String
        logoImage = dictionary["logoImage"] as? String
        catalogImageUrl = dictionary["catalogImageUrl"] as? String
        catalogDetail = dictionary["catalogDetail"] as? String
        itemPrice = dictionary["itemPrice"] as? String
        
        if let variationDictionaries = dictionary["productVariations"] as? [[String: AnyObject]] {
            productVariations = variationDictionaries.map({return ProductVariation(dictionary: $0)})
        }
    }
    
}
