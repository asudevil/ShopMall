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

    fileprivate let merchantId: String = "merchant.com.codewithfelix.ShopMall"
    
    fileprivate var applePayHelper: BUYApplePayAuthorizationDelegate?
    fileprivate var applePayProvider: BUYApplePayPaymentProvider?

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
        
        self.collectionView!.register(CartCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.navigationItem.title = "Shopping Cart"
        collectionView?.backgroundColor = UIColor.gray
        
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CartModel.sharedInstance.cart.lineItemsArray().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CartCell
        
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
        if let selectedOption = productVariation.variant.title {
            cell.sizeLabel.text  = "Option:     \(selectedOption)"
        }
        cell.priceLabel.text = "Price:   $\(productVariation.variant.price.doubleValue)0"
        cell.qtyLabel.text   = "QTY:     \(productVariation.quantity.stringValue)"
        
        if let imgUrl = productVariation.variant.product.imagesArray().first?.sourceURL {
            cell.itemImageView.loadImageUsingCacheWithNSURL(imgUrl)
        }
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(CartVC.deleteButton(_:)), for: .touchUpInside)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(1)
    }
    
    fileprivate func setupSubTotal() {
        view.addSubview(cartSummary)
        cartSummary.applePayButton.addTarget(self, action: #selector(CartVC.applePayButton(_:)), for: .touchUpInside)
        
        cartSummary.checkoutButton.addTarget(self, action: #selector(CartVC.checkOut(_:)), for: .touchUpInside)
        cartSummary.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        cartSummary.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cartSummary.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cartSummary.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    fileprivate func calculateTotalCost () {
        
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
    
    func deleteButton (_ button: UIButton) {
        let alertMessage = "Are you sure you want to delete item from cart?"
        
        let alert = UIAlertController(title: "Delete Item", message: alertMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let deleteItem = UIAlertAction(title: "Delete Item", style: .default) { (action) in
            
            ///  NEED TO UPDATE THIS TO ONLY DELETE SELECTED ITEM!!
            
            var deleteVariant = BUYProductVariant()
            deleteVariant = CartModel.sharedInstance.cart.lineItemsArray()[button.tag].variant
            
            CartModel.sharedInstance.cart.remove(deleteVariant)
            self.cart = CartModel.sharedInstance.cart
            
            self.calculateTotalCost()
            
            Service.sharedInstance.checkoutApplePay(self.cart) { (checkoutOutput) in
                self.checkout = checkoutOutput
            }
            
            self.collectionView?.reloadData()
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteItem)
        self.present(alert, animated: true, completion: nil)
    }
    
    ////////////////////////////////////////////////
    
    func applePayButton(_ button: UIButton) {
        
        if self.cart.lineItems.count > 0 && checkout != nil{
            
            applePayProvider = BUYApplePayPaymentProvider(client: self.client, merchantID: self.merchantId)
            applePayProvider!.delegate = self
            let paymentNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
                applePayProvider?.start(checkout)
            }
        }
        else {
            let alertMsg = "There are no items in the cart. \nPlease add items to the cart"
            let alert = UIAlertController(title: "Empty Cart", message: alertMsg, preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func paymentProvider(_ provider: BUYPaymentProvider, wantsControllerPresented controller: UIViewController) {
        self.present(controller, animated: true, completion: nil)
    }
    func paymentProviderWantsControllerDismissed(_ provider: BUYPaymentProvider) {
        self.dismiss(animated: true, completion: nil)
    }
    func paymentProvider(_ provider: BUYPaymentProvider, didComplete checkout: BUYCheckout, with status: BUYStatus) {
        if status == .complete {
            print("Checkout Complete!")
            CartModel.sharedInstance.cart.clear()
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
    
    func checkOut(_ button: UIButton) {
        
        let alertMsg = "This payment option is currently unavailable.  Please use Apple Pay"
        let alert = UIAlertController(title: "Payment Option Unavailable", message: alertMsg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
