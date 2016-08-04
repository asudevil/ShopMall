//
//  ProductVariationController.swift
//  ShopMall
//
//  Created by Brian Voong on 7/21/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class ProductVariationController: UIViewController {
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var productVariation: ProductVariation? {
        didSet {
            if let productImageUrl = productVariation?.imageUrl {
                productImageView.loadImageUsingCacheWithUrlString(productImageUrl)
            }
            if let navBarTitle = productVariation?.name {
                navigationItem.title = navBarTitle
            }
        }
    }
    
    var shop: Shop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        view.layer.masksToBounds = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: nil)
                
        view.addSubview(productImageView)
        if let attributes = shop?.productVariationAttributes {
            view.setupConstraintsForView(productImageView, attributes: attributes)
        }
    }
}
