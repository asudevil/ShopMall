//
//  Shop.swift
//  ShopMall
//
//  Created by admin on 7/21/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
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
    var cellSpacing: CGFloat?
    var cartImage: String?
    var logoImage: String?
    var products: [Product]?
    var productNameFontSize: NSNumber?
    var catalogTextColor: String?
    var catalogContainer1Color: String?
    var catalogContainer1Alpha: CGFloat?
    var headerField: CGFloat?
    var catalogHeaderContainerAttributes: Attributes?
    var catalogNameAttributes: Attributes?
    var catalogDetailAttributes: Attributes?
    var catalogImageAttributes: Attributes?
    var catalogContainer1Attributes: Attributes?
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
        catalogTextColor = dictionary["catalogTextColor"] as? String
        catalogContainer1Color = dictionary["catalogContainer1Color"] as? String
        catalogContainer1Alpha = dictionary["catalogContainer1Alpha"] as? CGFloat
        tableCellHeight = dictionary["tableCellHeight"] as? CGFloat
        cellSpacing = dictionary["cellSpacing"] as? CGFloat
        cartImage = dictionary["cartImage"] as? String
        logoImage = dictionary["logoImage"] as? String
        productNameFontSize = dictionary["productNameFontSize"] as? NSNumber
        headerField = dictionary["headerField"] as? CGFloat
        
        if let productDictionaries = dictionary["products"] as? [[String: AnyObject]] {
            products = productDictionaries.map({return Product(dictionary: $0)})
        }
        if let catalogHeaderContainerAttributesDictionary = dictionary["catalogHeaderContainerAttributes"] as? [String: AnyObject] {
            catalogHeaderContainerAttributes = Attributes(dictionary: catalogHeaderContainerAttributesDictionary)
        }
        if let catalogNameAttributesDictionary = dictionary["catalogNameAttributes"] as? [String: AnyObject] {
            catalogNameAttributes = Attributes(dictionary: catalogNameAttributesDictionary)
        }
        if let catalogDetailAttributesDictionary = dictionary["catalogDetailAttributes"] as? [String: AnyObject] {
            catalogDetailAttributes = Attributes(dictionary: catalogDetailAttributesDictionary)
        }
        if let catalogImageAttributesDictionary = dictionary["catalogImageAttributes"] as? [String: AnyObject] {
            catalogImageAttributes = Attributes(dictionary: catalogImageAttributesDictionary)
        }
        if let catalogContainer1AttributesDictionary = dictionary["catalogContainer1Attributes"] as? [String: AnyObject] {
            catalogContainer1Attributes = Attributes(dictionary: catalogContainer1AttributesDictionary)
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
