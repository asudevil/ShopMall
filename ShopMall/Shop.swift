//
//  Shop.swift
//  ShopMall
//
//  Created by Brian Voong on 7/21/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class Shop: NSObject {

    var id: NSNumber?
    var name: String?
    var detail: String?
    var appImageUrl: String?
    var navBarColor: String?
    var cellColor: String?
    var tableCellHeight: CGFloat?
    var cartImage: String?
    var logoImage: String?
    var products: [Product]?
    var productNameFontSize: NSNumber?
    var productCellAttributes: Attributes?
    var productCatalogImageAttributes: Attributes?
    var productVariationCellAttributes: Attributes?
    var productVariationAttributes: Attributes?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        id = dictionary["id"] as? NSNumber
        name = dictionary["name"] as? String
        detail = dictionary["detail"] as? String
        appImageUrl = dictionary["appImageUrl"] as? String
        navBarColor = dictionary["navBarColor"] as? String
        cellColor = dictionary["cellColor"] as? String
        tableCellHeight = dictionary["tableCellHeight"] as? CGFloat
        cartImage = dictionary["cartImage"] as? String
        logoImage = dictionary["logoImage"] as? String
        productNameFontSize = dictionary["productNameFontSize"] as? NSNumber
        
        if let productDictionaries = dictionary["products"] as? [[String: AnyObject]] {
            products = productDictionaries.map({return Product(dictionary: $0)})
        }
        
        if let productCellAttributesDictionary = dictionary["productCellAttributes"] as? [String: AnyObject] {
            productCellAttributes = Attributes(dictionary: productCellAttributesDictionary)
        }
        if let productCatalogImageAttributesDictionary = dictionary["productCatalogImageAttributes"] as? [String: AnyObject] {
            productCatalogImageAttributes = Attributes(dictionary: productCatalogImageAttributesDictionary)
        }
        
        if let productVariationCellAttributesDictionary = dictionary["productVariationCellAttributes"] as? [String: AnyObject] {
            productVariationCellAttributes = Attributes(dictionary: productVariationCellAttributesDictionary)
        }
        
        if let productVariationAttributesDictionary = dictionary["productVariationAttributes"] as? [String: AnyObject] {
            productVariationAttributes = Attributes(dictionary: productVariationAttributesDictionary)
        }
    }
    
}
