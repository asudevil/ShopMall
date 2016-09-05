//
//  AddToCart.swift
//  ShopMall
//
//  Created by admin on 8/31/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Buy

class AddToCart {
    
    var cart: BUYCart!
    
    init(variant: BUYProductVariant, completion: (Bool) -> ()) {
 //       if variant != nil {
        cart.addVariant(variant)
        let addedToCart = true
        completion(addedToCart)
    }
    
    func showSizes (button: UIButton) {
        
        
        
    }
    
    
    
}