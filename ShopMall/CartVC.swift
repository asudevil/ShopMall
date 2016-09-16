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
    
    let cartSummary: TotalCell = {
        let total = TotalCell()
        total.translatesAutoresizingMaskIntoConstraints = false
        return total
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerClass(CartCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.navigationItem.title = "Shopping Cart"
        collectionView?.backgroundColor = UIColor.grayColor()
        let cartItems = CartModel.sharedInstance.cart.lineItemsArray()
        var totalCost = 0.00
        
        for item in cartItems {
            let qty = Double(item.quantity)
            let price = Double(item.linePrice)
            let cost = qty * price
            totalCost = totalCost + cost
        }
        setupSubTotal()
        let subTotalString = Service.sharedInstance.formatCurrency("\(totalCost)")
        cartSummary.subTotalLabel.text = "Subtotal: \(subTotalString)"
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
            if let attributes = shop?.cartItemDeleteAttributes {
                cell.setupConstraintsForView(cell.deleteButton, attributes: attributes)
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
        
        cell.deleteButton.addTarget(self, action: #selector(CartVC.deleteButton(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 170)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(1)
    }
    
    private func setupSubTotal() {
        view.addSubview(cartSummary)
        
        cartSummary.checkoutButton.addTarget(self, action: #selector(CartVC.checkOut(_:)), forControlEvents: .TouchUpInside)
        
        cartSummary.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        cartSummary.heightAnchor.constraintEqualToConstant(100).active = true
        cartSummary.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        cartSummary.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
    }
    
    func checkOut(button: UIButton) {
        
        print("Performing checkout")
        let cart = CartModel.sharedInstance.cart
        Service.sharedInstance.checkoutShopify(cart)
    }
    func deleteButton (button: UIButton) {
        let alertMessage = "Are you sure you want to delete item from cart?"
        
        let alert = UIAlertController(title: "Delete Item", message: alertMessage, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        let deleteItem = UIAlertAction(title: "Delete Item", style: .Default) { (action) in
            
///  NEED TO UPDATE THIS TO ONLY DELETE SELECTED ITEM!!
            CartModel.sharedInstance.cart.clearCart()
            
            self.collectionView?.reloadData()
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteItem)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}
