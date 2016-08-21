//
//  UIImageView+Ext.swift
//  ShopMall
//
//  Created by admin on 7/21/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

let imageCache = NSCache()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String, completion: ((UIImage) -> ())? = nil) {

        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.objectForKey(urlString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString)
                    
                    completion? (downloadedImage)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
    func loadImageUsingCacheWithNSURL(nsURLString: NSURL, completion: ((UIImage) -> ())? = nil) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.objectForKey(nsURLString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        NSURLSession.sharedSession().dataTaskWithURL(nsURLString, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: nsURLString)
                    
                    completion? (downloadedImage)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
}



