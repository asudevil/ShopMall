//
//  CartVC.swift
//  ShopMall
//
//  Created by admin on 8/30/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Buy

private let reuseIdentifier = "Cell"

class CartVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var shop: Shop?
    
    var shoppingCart: BUYCart?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerClass(CartCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.navigationItem.title = "Shopping Cart"
        collectionView?.backgroundColor = UIColor.whiteColor()
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CartModel.sharedInstance.cart.lineItemsArray().count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CartCell
        
        if !cell.hasSetupConstraints {
            if let attributes = shop?.cartItemImageAttributes {
                cell.setupConstraintsForView(cell.itemImageView, attributes: attributes)
            }
            if let attributes = shop?.cartItemNameAttributes {
                cell.setupConstraintsForView(cell.nameLabel, attributes: attributes)
            }
            if let attributes = shop?.cartItemPriceAttributes {
                cell.setupConstraintsForView(cell.priceLabel, attributes: attributes)
            }
            if let attributes = shop?.cartItemSizeAttributes {
                cell.setupConstraintsForView(cell.sizeLabel, attributes: attributes)
            }
            if let attributes = shop?.cartItemQtyAttributes {
                cell.setupConstraintsForView(cell.qtyLabel, attributes: attributes)
            }
            cell.hasSetupConstraints = true
        }
        let productVariation = CartModel.sharedInstance.cart.lineItemsArray()[indexPath.row]
        
        cell.nameLabel.text  = productVariation.variant.product.title
        cell.sizeLabel.text  = "Size:     \(productVariation.variant.title)"
        cell.priceLabel.text = "Price:   $\(productVariation.linePrice.stringValue).00"
        cell.qtyLabel.text   = "QTY:     \(productVariation.quantity.stringValue)"
        
        if let imgUrl = productVariation.variant.product.imagesArray().first?.sourceURL {
            cell.itemImageView.loadImageUsingCacheWithNSURL(imgUrl)
        }
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 200)
    }
}
