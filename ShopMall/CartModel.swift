//
//  CartModel.swift
//  ShopMall
//
//  Created by admin on 9/10/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Buy

class CartModel: NSObject {
    var cartDictionary: NSNumber?
    var client: BUYClient!
    var cart: BUYCart!
    private let shopDomain: String = "yoganinja.myshopify.com"
    private let apiKey:     String = "706f85f7989134d8225e2ec4da7335b8"
    private let appID:      String = "8"
    
    static let sharedInstance = CartModel()
    
    override init() {
        super.init()
        client = BUYClient(shopDomain: shopDomain, apiKey: apiKey, appId: appID)
        cart = client.modelManager.insertCartWithJSONDictionary(nil)
    }
}
