//
//  CartVC.swift
//  ShopMall
//
//  Created by admin on 8/30/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Buy
import PassKit

private let reuseIdentifier = "Cell"

class CartVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, BUYPaymentProviderDelegate {

    private let merchantId: String = "merchant.com.codewithfelix.ShopMall"
    
    private var applePayHelper: BUYApplePayAuthorizationDelegate?
    private var applePayProvider: BUYApplePayPaymentProvider?

    var shop: Shop?
    
    var shopInfo: BUYShop!
    var checkout: BUYCheckout!
    var client: BUYClient!
    var cart: BUYCart!
    
    let cartSummary: SummaryCell = {
        let total = SummaryCell()
        total.translatesAutoresizingMaskIntoConstraints = false
        return total
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.registerClass(CartCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.navigationItem.title = "Shopping Cart"
        collectionView?.backgroundColor = UIColor.grayColor()
        
        Service.sharedInstance.getShopInfo({ (shopInfoOutput) in
            self.shopInfo = shopInfoOutput
        })
        
        client = Service.sharedInstance.getClient()
        
        cart = CartModel.sharedInstance.cart
        
        calculateTotalCost()
        
        Service.sharedInstance.checkoutApplePay(cart) { (checkoutOutput) in
            self.checkout = checkoutOutput
        }
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
        cell.sizeLabel.text  = "Option:     \(productVariation.variant.title)"
        cell.priceLabel.text = "Price:   $\(productVariation.variant.price.doubleValue)0"
        cell.qtyLabel.text   = "QTY:     \(productVariation.quantity.stringValue)"
        
        if let imgUrl = productVariation.variant.product.imagesArray().first?.sourceURL {
            cell.itemImageView.loadImageUsingCacheWithNSURL(imgUrl)
        }
        cell.deleteButton.tag = indexPath.row
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
        cartSummary.applePayButton.addTarget(self, action: #selector(CartVC.applePayButton(_:)), forControlEvents: .TouchUpInside)
        
        cartSummary.checkoutButton.addTarget(self, action: #selector(CartVC.checkOut(_:)), forControlEvents: .TouchUpInside)
        cartSummary.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        cartSummary.heightAnchor.constraintEqualToConstant(100).active = true
        cartSummary.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        cartSummary.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
    }
    
    private func calculateTotalCost () {
        
        let cartItems = CartModel.sharedInstance.cart.lineItemsArray()
        var totalCost = 0.00
        
        for item in cartItems {
            let qty = Double(item.quantity)
            let price = Double(item.variant.price)
            let cost = qty * price
            totalCost = totalCost + cost
        }
        
        setupSubTotal()
        let subTotalString = Service.sharedInstance.formatCurrency("\(totalCost)")
        cartSummary.subTotalLabel.text = "Subtotal: \(subTotalString)"
    }
    
    func deleteButton (button: UIButton) {
        let alertMessage = "Are you sure you want to delete item from cart?"
        
        let alert = UIAlertController(title: "Delete Item", message: alertMessage, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        let deleteItem = UIAlertAction(title: "Delete Item", style: .Default) { (action) in
            
            ///  NEED TO UPDATE THIS TO ONLY DELETE SELECTED ITEM!!
            
            var deleteVariant = BUYProductVariant()
            deleteVariant = CartModel.sharedInstance.cart.lineItemsArray()[button.tag].variant
            
            CartModel.sharedInstance.cart.removeVariant(deleteVariant)
            self.cart = CartModel.sharedInstance.cart
            
            self.calculateTotalCost()
            
            Service.sharedInstance.checkoutApplePay(self.cart) { (checkoutOutput) in
                self.checkout = checkoutOutput
            }
            
            self.collectionView?.reloadData()
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteItem)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    ////////////////////////////////////////////////
    
    func applePayButton(button: UIButton) {
        
        if self.cart.lineItems.count > 0 && checkout != nil{
            
            applePayProvider = BUYApplePayPaymentProvider(client: self.client, merchantID: self.merchantId)
            applePayProvider!.delegate = self
            let paymentNetworks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]
            if PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(paymentNetworks) {
                applePayProvider?.startCheckout(checkout)
            }
        }
        else {
            let alertMsg = "There are no items in the cart. \nPlease add items to the cart"
            let alert = UIAlertController(title: "Empty Cart", message: alertMsg, preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func paymentProvider(provider: BUYPaymentProvider, wantsControllerPresented controller: UIViewController) {
        self.presentViewController(controller, animated: true, completion: nil)
    }
    func paymentProviderWantsControllerDismissed(provider: BUYPaymentProvider) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func paymentProvider(provider: BUYPaymentProvider, didCompleteCheckout checkout: BUYCheckout, withStatus status: BUYStatus) {
        if status == .Complete {
            print("Checkout Complete!")
            CartModel.sharedInstance.cart.clearCart()
            collectionView?.reloadData()
            if let continueShoppingVC = self.navigationController?.viewControllers[2] {
                navigationController?.popToViewController(continueShoppingVC, animated: true)
            }
        }
        else {
            // status will be 'BUYStatusFailed'; handle error
            print("Checkout Cancelled or Failed!")
        }
    }
    
    func checkOut(button: UIButton) {
        
        let alertMsg = "This payment option is currently unavailable.  Please use Apple Pay"
        let alert = UIAlertController(title: "Payment Option Unavailable", message: alertMsg, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}