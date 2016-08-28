//
//  Service.swift
//  ShopMall
//
//  Created by admin on 7/21/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Buy

class Service: NSObject {
    
    var products: [BUYProduct]?
    
    static let sharedInstance = Service()
    
    let useLocalJsonFiles = true
    
    let baseUrl = "https://s3.amazonaws.com/spicysuya"
    
    func loadJson(fileName: String) -> AnyObject? {
        if let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: "json") {
            if let data = NSData(contentsOfURL: url) {
                do {
                    let object = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    return object
                } catch {
                    print("Error!! Unable to parse  \(fileName).json")
                }
            }
            print("Error!! Unable to load  \(fileName).json")
        }
        return nil
    }
    
    func fetchShops(completion: ([Shop]) -> ()) {
        
        if useLocalJsonFiles {
            if let shopsDictionaries = loadJson("shops") as? [[String: AnyObject]] {
                completion(shopsDictionaries.map({return Shop(dictionary: $0)}))
                return
            }
        }
        
        let urlString = "\(baseUrl)/shops.json"
        let url = NSURL(string: urlString)!
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                if let unwrappedData = data, shopDictionaries = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: .MutableContainers) as? [[String: AnyObject]] {
                    
                    let shops = shopDictionaries.map({return Shop(dictionary: $0)})
                    dispatch_async(dispatch_get_main_queue(), { 
                        completion(shops)
                    })
                    
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    func fetchShop(id: String, completion: (Shop) ->()) {
        if useLocalJsonFiles {
            if let shopDictionary = loadJson("shop\(id)") as? [String: AnyObject] {
                completion(Shop(dictionary: shopDictionary))
                return
            }
        }
        
        let urlString = "\(baseUrl)/shop\(id).json"
        let url = NSURL(string: urlString)!
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                if let unwrappedData = data, shopDictionary = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: .MutableContainers) as? [String: AnyObject] {
                    let shop = Shop(dictionary: shopDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(shop)
                    })
                }
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    func fetchShopifyProducts(pages: UInt, shopDomain: String, apiKey: String, appId: String, completion: ([BUYProduct]?, NSError?) -> ()) {
        var client: BUYClient!
        
        
        client = BUYClient(shopDomain: shopDomain, apiKey: apiKey, appId: appId)
        
        client.getProductsPage(pages, completion: {(products: [BUYProduct]?, page: UInt, reachedEnd: Bool, error: NSError?)  -> Void in
            
            if (products != nil) && error == nil {
                completion (products, error)
            }
            else {
                print("Error fetching collections: \(error!.userInfo)")
            }
        })
    }
    func fetchShopifyCollections(pages: UInt, shopDomain: String, apiKey: String, appId: String, completion: ([BUYCollection]?, NSError?) -> ()) {
        var client: BUYClient!
        
        client = BUYClient(shopDomain: shopDomain, apiKey: apiKey, appId: appId)
        
        client.getCollectionsPage(pages, completion: {( collections:[BUYCollection]?, page: UInt, reachedEnd: Bool, error: NSError?) -> Void in
            
            if (collections != nil) && error == nil {
                completion (collections, error)
            }
            else {
                print("Error fetching collections: \(error!.userInfo)")
            }
        })
    }
    
    func fetchShopifyProductsInCollection(pages: UInt, collectionId: NSNumber, shopDomain: String, apiKey: String, appId: String, completion: ([BUYProduct]?, NSError?) -> ())  {
        var client: BUYClient!
        client = BUYClient(shopDomain: shopDomain, apiKey: apiKey, appId: appId)
        client.getProductsPage(pages, inCollection: collectionId, completion: {(products: [BUYProduct]?, page: UInt, reachedEnd: Bool, error: NSError?)  -> Void in
            
            if (products != nil) && error == nil {
                completion (products, error)
            }
            else {
                print("Error fetching collections: \(error!.userInfo)")
            }
        })
    }
}