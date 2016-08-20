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
    
    let shopDomain: String = "yoganinja.myshopify.com"
    let apiKey:     String = "706f85f7989134d8225e2ec4da7335b8"
    let appID:      String = "8"
    
    
    
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
    
    func fetchShopifyProducts() {
        var client: BUYClient!
        
        
        client = BUYClient(shopDomain: shopDomain, apiKey: apiKey, appId: appID)
        
        print("inside fetchShopifyProduct")

        
        client.getProductsPage(1, completion: {(products: [BUYProduct]?, page: UInt, reachedEnd: Bool, error: NSError?)  -> Void in
            if (products != nil) && error == nil {
                print("Inside getCollectionsPage \(products)")
            }
            else {
                print("Error fetching collections: \(error!.userInfo)")
            }
        })
    }
}