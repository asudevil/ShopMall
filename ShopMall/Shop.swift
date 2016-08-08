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
    var numberOfColumns: Int?
    var cartImage: String?
    var logoImage: String?
    var products: [Product]?
    var productNameFontSize: NSNumber?
    var headerField: NSNumber?
    var catalogNameAttributes: Attributes?
    var catalogImageAttributes: Attributes?
    var productCellNameAttributes: Attributes?
    var productCellImageAttributes: Attributes?
    var itemPriceAttributes: Attributes?
    var itemDetailsImageAttributes: Attributes?
    var itemDescriptionAttributes: Attributes?
    var itemDetailPriceAttributes: Attributes?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        id = dictionary["id"] as? NSNumber
        name = dictionary["name"] as? String
        detail = dictionary["detail"] as? String
        appImageUrl = dictionary["appImageUrl"] as? String
        navBarColor = dictionary["navBarColor"] as? String
        cellColor = dictionary["cellColor"] as? String
        tableCellHeight = dictionary["tableCellHeight"] as? CGFloat
        numberOfColumns = dictionary["numberOfColumns"] as? Int
        cartImage = dictionary["cartImage"] as? String
        logoImage = dictionary["logoImage"] as? String
        productNameFontSize = dictionary["productNameFontSize"] as? NSNumber
        headerField = dictionary["headerField"] as? NSNumber
        
        if let productDictionaries = dictionary["products"] as? [[String: AnyObject]] {
            products = productDictionaries.map({return Product(dictionary: $0)})
        }
        
        if let catalogNameAttributesDictionary = dictionary["catalogNameAttributes"] as? [String: AnyObject] {
            catalogNameAttributes = Attributes(dictionary: catalogNameAttributesDictionary)
        }
        if let catalogImageAttributesDictionary = dictionary["catalogImageAttributes"] as? [String: AnyObject] {
            catalogImageAttributes = Attributes(dictionary: catalogImageAttributesDictionary)
        }
        
        if let productCellNameAttributesDictionary = dictionary["productCellNameAttributes"] as? [String: AnyObject] {
            productCellNameAttributes = Attributes(dictionary: productCellNameAttributesDictionary)
        }
        if let itemPriceAttributesDictionary = dictionary["itemPriceAttributes"] as? [String: AnyObject] {
            itemPriceAttributes = Attributes(dictionary: itemPriceAttributesDictionary)
        }
        
        if let productCellImageAttributesDictionary = dictionary["productCellImageAttributes"] as? [String: AnyObject] {
            productCellImageAttributes = Attributes(dictionary: productCellImageAttributesDictionary)
        }

        
        if let itemDetailsImageAttributesDictionary = dictionary["itemDetailsImageAttributes"] as? [String: AnyObject] {
            itemDetailsImageAttributes = Attributes(dictionary: itemDetailsImageAttributesDictionary)
        }
        if let itemDescriptionAttributesDictionary = dictionary["itemDescriptionAttributes"] as? [String: AnyObject] {
            itemDescriptionAttributes = Attributes(dictionary: itemDescriptionAttributesDictionary)
        }
        if let itemDetailPriceAttributesDictionary = dictionary["itemDetailPriceAttributes"] as? [String: AnyObject] {
            itemDetailPriceAttributes = Attributes(dictionary: itemDetailPriceAttributesDictionary)
        }
    }
    
}
