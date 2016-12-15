//
//  Ser.swift
//  ShopMall
//
//  Created by admin on 7/21/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Buy

class Service: NSObject {
    
//    private let shopDomain: String = "yoganinja.myshopify.com"
//    private let apiKey:     String = "706f85f7989134d8225e2ec4da7335b8"
//    private let appID:      String = "8"
    
    //for-me-and-baby.myshopify.com
    fileprivate var shopDomain: String = "for-me-and-baby.myshopify.com"
    fileprivate var apiKey:     String = "9cf1b349e83d14053c29a4cb3e30e499"
    fileprivate var appID:      String = "8"
    
    fileprivate var shop = BUYShop()
    fileprivate var checkout = BUYCheckout()
    static let sharedInstance = Service()
    
    let useLocalJsonFiles = false
    
    let baseUrl = "https://s3.amazonaws.com/spicysuya"
    
    func setShopAPIInfo(_ shopAPIInfo: [String: AnyObject]) {
        
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
    
    func loadJson(_ fileName: String) -> AnyObject? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                do {
                    let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    return object as AnyObject?
                } catch {
                    print("Error!! Unable to parse  \(fileName).json")
                }
            }
            print("Error!! Unable to load  \(fileName).json")
        }
        return nil
    }
    
    func fetchShops(_ completion: @escaping ([Shop]) -> ()) {
        
        if useLocalJsonFiles {
            if let shopsDictionaries = loadJson("shops") as? [[String: AnyObject]] {
                completion(shopsDictionaries.map({return Shop(dictionary: $0)}))
                return
            }
        }
        
        let urlString = "\(baseUrl)/shops.json"
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            do {
                if let unwrappedData = data, let shopDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String: AnyObject]] {
                    
                    let shops = shopDictionaries.map({return Shop(dictionary: $0)})
                    DispatchQueue.main.async(execute: { 
                        completion(shops)
                    })
                }
            } catch let jsonError {
                print(jsonError)
            }
        }) .resume()
    }
    
    func fetchShop(_ id: String, completion: @escaping (Shop) ->()) {
        if useLocalJsonFiles {
            if let shopDictionary = loadJson("shop\(id)") as? [String: AnyObject] {
                completion(Shop(dictionary: shopDictionary))
                return
            }
        }
        
        let urlString = "\(baseUrl)/shop\(id).json"
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            do {
                if let unwrappedData = data, let shopDictionary = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [String: AnyObject] {
                    let shop = Shop(dictionary: shopDictionary)
                    DispatchQueue.main.async(execute: {
                        completion(shop)
                    })
                }
            } catch let jsonError {
                print(jsonError)
            }
            }) .resume()
    }
    
    func fetchShopifyProducts(_ pages: UInt, completion: @escaping ([BUYProduct]?, Error?) -> ()) {
        var client: BUYClient!
        
        client = BUYClient(shopDomain: self.shopDomain, apiKey: self.apiKey, appId: self.appID)

        client.getProductsPage(pages, completion: {(products: [BUYProduct]?, page: UInt, reachedEnd: Bool, error: Error?)  -> Void in
            
            if (products != nil) && error == nil {
                completion (products, error)
            }
            else {
                print("Error fetching collections: \(error!.localizedDescription)")
            }
        })
    }
    func fetchShopifyCollections(_ pages: UInt, completion: @escaping ([BUYCollection]?, Error?) -> ()) {
        var client: BUYClient!
        
        client = BUYClient(shopDomain: self.shopDomain, apiKey: self.apiKey, appId: self.appID)
        client.getCollectionsPage(pages, completion: {( collections:[BUYCollection]?, page: UInt, reachedEnd: Bool, error: Error?) -> Void in
            
            if (collections != nil) && error == nil {
                completion (collections, error)
            }
            else {
                print("Error fetching collections: \(error!.localizedDescription)")
            }
        })
    }
    func fetchShopifyProductsInCollection(_ pages: UInt, collectionId: NSNumber, completion: @escaping ([BUYProduct]?, Error?) -> ())  {
        
        var client: BUYClient!
        client = BUYClient(shopDomain: self.shopDomain, apiKey: self.apiKey, appId: self.appID)
        client.getProductsPage(pages, inCollection: collectionId, completion: {(products: [BUYProduct]?, page: UInt, reachedEnd: Bool, error: Error?)  -> Void in
            
            if (products != nil) && error == nil {
                completion (products, error)
            }
            else {
                print("Error fetching collections: \(error!.localizedDescription)")
            }
        })
    }
    func formatCurrency(_ string: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = Locale(identifier: "en_US")
        let numberFromField = (NSString(string: string).doubleValue)
        if let returnString = formatter.string(from: numberFromField as NSNumber) {
            return returnString
        }
        return "0"
    }
    
    func getShopInfo (_ completion: @escaping (BUYShop) -> ()) {
        var client: BUYClient!
        client = BUYClient(shopDomain: self.shopDomain, apiKey: self.apiKey, appId: self.appID)
        
        client.getShop { (shop, error) in
            if error == nil {
                if let shop1 = shop {
                    self.shop = shop1
                    completion(shop1)
                }
            } else {
                //Handle error
            }
        }
    }
    
    func checkoutApplePay (_ cart: BUYCart, completion: @escaping (BUYCheckout) -> ()) {
        var client: BUYClient!
        client = BUYClient(shopDomain: self.shopDomain, apiKey: self.apiKey, appId: self.appID)
        let checkout1 = client.modelManager.checkout(with: cart)
        
        client.createCheckout(checkout1) { (checkout, error) in
            if error == nil && checkout != nil {
                completion(checkout!)
            } else {
                print("Error performing checkout")
                print(error ?? "")
            }
        }
    }
    
    func getClient () -> BUYClient {
        
        var client: BUYClient!
        client = BUYClient(shopDomain: self.shopDomain, apiKey: self.apiKey, appId: self.appID)
        
        return client
    }
    
    func addToCart (_ button: UIButton) {
        print("Clicked on addToCart")
    }
 }
