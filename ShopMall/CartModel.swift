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
//    private var shopDomain: String = "yoganinja.myshopify.com"
//    private var apiKey:     String = "706f85f7989134d8225e2ec4da7335b8"
//    private var appID:      String = "8"
    fileprivate var shopDomain: String = "for-me-and-baby.myshopify.com"
    fileprivate var apiKey:     String = "9cf1b349e83d14053c29a4cb3e30e499"
    fileprivate var appID:      String = "8"
    
    static let sharedInstance = CartModel()
    
    override init() {
        super.init()
        client = BUYClient(shopDomain: shopDomain, apiKey: apiKey, appId: appID)
        cart = client.modelManager.insertCart(withJSONDictionary: nil)
    }
    
    func setShopAPI(_ shopAPIInfo: [String: AnyObject]) {
        
        if let setShopDomain = shopAPIInfo["shopDomain"] as? String {
            shopDomain = setShopDomain
        }
        if let setApiKey = shopAPIInfo["apiKey"] as? String {
            apiKey = setApiKey
        }
        if let setAppID = shopAPIInfo["appID"] as? String {
            appID = setAppID
        }
    }
}
