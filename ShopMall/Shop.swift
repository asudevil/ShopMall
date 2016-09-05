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
    var headerColor: String?
    var tableCellHeight: CGFloat?
    var cellSpacing: CGFloat?
    var cartImage: String?
    var logoImage: String?
    var headerImageUrl: String?
    var products: [Product]?
    var storeNameFontSize: NSNumber?
    var catalogNameFontSize: NSNumber?
    var productNameFontSize: NSNumber?
    var catalogTextColor: String?
    var catalogContainer1Color: String?
    var addItemButtonColor: String?
    var catalogContainer1Alpha: CGFloat?
    var headerSize: CGFloat?
    var catalogHeaderContainerAttributes: Attributes?
    var searchTextFieldAttributes: Attributes?
    var headerImageAttributes: Attributes?
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
    var addItemButtonAttributes: Attributes?
    var cartItemNameAttributes: Attributes?
    var cartItemImageAttributes: Attributes?
    var cartItemPriceAttributes: Attributes?
    var cartItemSizeAttributes: Attributes?
    var cartItemQtyAttributes: Attributes?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        id = dictionary["id"] as? NSNumber
        name = dictionary["name"] as? String
        detail = dictionary["detail"] as? String
        appImageUrl = dictionary["appImageUrl"] as? String
        navBarColor = dictionary["navBarColor"] as? String
        cellColor = dictionary["cellColor"] as? String
        headerColor = dictionary["headerColor"] as? String
        catalogTextColor = dictionary["catalogTextColor"] as? String
        catalogContainer1Color = dictionary["catalogContainer1Color"] as? String
        catalogContainer1Alpha = dictionary["catalogContainer1Alpha"] as? CGFloat
        addItemButtonColor = dictionary["addItemButtonColor"] as? String
        tableCellHeight = dictionary["tableCellHeight"] as? CGFloat
        cellSpacing = dictionary["cellSpacing"] as? CGFloat
        cartImage = dictionary["cartImage"] as? String
        logoImage = dictionary["logoImage"] as? String
        headerImageUrl = dictionary["headerImageUrl"] as? String
        storeNameFontSize = dictionary["storeNameFontSize"] as? NSNumber
        catalogNameFontSize = dictionary["catalogNameFontSize"] as? NSNumber
        productNameFontSize = dictionary["productNameFontSize"] as? NSNumber
        headerSize = dictionary["headerSize"] as? CGFloat
        
        if let productDictionaries = dictionary["products"] as? [[String: AnyObject]] {
            products = productDictionaries.map({return Product(dictionary: $0)})
        }
        if let catalogHeaderContainerAttributesDictionary = dictionary["catalogHeaderContainerAttributes"] as? [String: AnyObject] {
            catalogHeaderContainerAttributes = Attributes(dictionary: catalogHeaderContainerAttributesDictionary)
        }
        if let searchTextFieldAttributesDictionary = dictionary["searchTextFieldAttributes"] as? [String: AnyObject] {
            searchTextFieldAttributes = Attributes(dictionary: searchTextFieldAttributesDictionary)
        }
        if let headerImageAttributesDictionary = dictionary["headerImageAttributes"] as? [String: AnyObject] {
            headerImageAttributes = Attributes(dictionary: headerImageAttributesDictionary)
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
        if let addItemButtonAttributesDictionary = dictionary["addItemButtonAttributes"] as? [String: AnyObject] {
            addItemButtonAttributes = Attributes(dictionary: addItemButtonAttributesDictionary)
        }
        if let cartItemNameAttributesDictionary = dictionary["cartItemNameAttributes"] as? [String: AnyObject] {
            cartItemNameAttributes = Attributes(dictionary: cartItemNameAttributesDictionary)
        }
        if let cartItemImageAttributesDictionary = dictionary["cartItemImageAttributes"] as? [String: AnyObject] {
            cartItemImageAttributes = Attributes(dictionary: cartItemImageAttributesDictionary)
        }
        if let cartItemPriceAttributesDictionary = dictionary["cartItemPriceAttributes"] as? [String: AnyObject] {
            cartItemPriceAttributes = Attributes(dictionary: cartItemPriceAttributesDictionary)
        }
        if let cartItemSizeAttributesDictionary = dictionary["cartItemSizeAttributes"] as? [String: AnyObject] {
            cartItemSizeAttributes = Attributes(dictionary: cartItemSizeAttributesDictionary)
        }
        if let cartItemQtyAttributesDictionary = dictionary["cartItemQtyAttributes"] as? [String: AnyObject] {
            cartItemQtyAttributes = Attributes(dictionary: cartItemQtyAttributesDictionary)
        }
    }
    
}
