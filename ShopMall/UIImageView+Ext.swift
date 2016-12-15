//
//  UIImageView+Ext.swift
//  ShopMall
//
//  Created by admin on 7/21/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

//let imageCache = NSCache()

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String, completion: ((UIImage) -> ())? = nil) {

        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    
                    completion? (downloadedImage)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
    func loadImageUsingCacheWithNSURL(_ nsURLString: URL, completion: ((UIImage) -> ())? = nil) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: nsURLString.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        URLSession.shared.dataTask(with: nsURLString, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: nsURLString.absoluteString as NSString)
                    
                    completion? (downloadedImage)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
}



