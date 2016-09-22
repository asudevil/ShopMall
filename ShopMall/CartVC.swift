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

class CartVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, PKPaymentAuthorizationViewControllerDelegate {
    
    private let shopDomain: String = "yoganinja.myshopify.com"
    private let apiKey:     String = "706f85f7989134d8225e2ec4da7335b8"
    private let appID:      String = "8"
    private let merchantId: String = "merchant.com.codewithfelix.ShopMall"
    
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
        let cartItems = CartModel.sharedInstance.cart.lineItemsArray()
        var totalCost = 0.00
        
        for item in cartItems {
            let qty = Double(item.quantity)
            let price = Double(item.linePrice)
            let cost = qty * price
            totalCost = totalCost + cost
        }
        
        Service.sharedInstance.getShopInfo({ (shopInfoOutput) in
            self.shopInfo = shopInfoOutput
        })
        
        client = BUYClient(shopDomain: self.shopDomain, apiKey: self.apiKey, appId: self.appID)
        
        cart = CartModel.sharedInstance.cart
        
        Service.sharedInstance.checkoutApplePay(cart) { (checkoutOutput) in
            self.checkout = checkoutOutput
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
        cartSummary.applePayButton.addTarget(self, action: #selector(CartVC.applePayButton(_:)), forControlEvents: .TouchUpInside)
        
        
        cartSummary.checkoutButton.addTarget(self, action: #selector(CartVC.checkOut(_:)), forControlEvents: .TouchUpInside)
        cartSummary.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        cartSummary.heightAnchor.constraintEqualToConstant(100).active = true
        cartSummary.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        cartSummary.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
    }
    func deleteButton (button: UIButton) {
        let alertMessage = "Are you sure you want to delete item from cart?"
        
        let alert = UIAlertController(title: "Delete Item", message: alertMessage, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        let deleteItem = UIAlertAction(title: "Delete Item", style: .Default) { (action) in
            
            ///  NEED TO UPDATE THIS TO ONLY DELETE SELECTED ITEM!!
            CartModel.sharedInstance.cart.clearCart()
            self.cart = CartModel.sharedInstance.cart
            
            self.collectionView?.reloadData()
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteItem)
        self.presentViewController(alert, animated: true, completion: nil)
    }

////////////////////////////////////////////////
    
    func applePayButton(button: UIButton) {
        
        if self.cart.lineItems.count > 0 {
            
            let request = self.paymentRequest()
            let paymentController = PKPaymentAuthorizationViewController(paymentRequest: request)
            paymentController.delegate = self
            self.presentViewController(paymentController, animated: true, completion: nil)
        }
        else {
            let alertMsg = "There are no items in the cart. \nPlease add items to the cart"
            let alert = UIAlertController(title: "Empty Cart", message: alertMsg, preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func paymentRequest() -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = self.merchantId
        paymentRequest.supportedNetworks = [PKPaymentNetworkVisa, PKPaymentNetworkMasterCard]
        paymentRequest.merchantCapabilities = .Capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        
        let freeShipping = PKShippingMethod(label: "Free shipping", amount: NSDecimalNumber(double: 0.0))
        freeShipping.identifier = "freeShipping"
        freeShipping.detail = "Usually ships in 5-12 days"
        
        let expressShipping = PKShippingMethod(label: "Express shipping", amount: NSDecimalNumber(double: 7.99))
        expressShipping.identifier = "expressShipping"
        expressShipping.detail = "Usually ships in 2-3 days"
        
        paymentRequest.shippingMethods = [freeShipping, expressShipping]
        
        paymentRequest.paymentSummaryItems = self.checkout.buy_summaryItemsWithShopName(self.shopInfo!.name)
        
        return paymentRequest
    }
    
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
        completion(.Success)
        CartModel.sharedInstance.cart.clearCart()
        collectionView?.reloadData()
    }
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    func checkOut(button: UIButton) {
        
        let alertMsg = "This payment option is currently unavailable.  Please use Apple Pay"
        let alert = UIAlertController(title: "Payment Option Unavailable", message: alertMsg, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
