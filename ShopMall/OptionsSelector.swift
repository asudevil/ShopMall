//
//  OptionsSelector.swift
//  ShopMall
//
//  Created by admin on 9/6/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Buy

class OptionsSelector: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
        
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.whiteColor()
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    var cart: BUYCart!
    var selectedProduct: BUYProduct!
    
    var shopifyProductVariationVC: ShopifyProductVariationVC?
    var productVariantionVC: ProductVariationController?
    
    let sizeOptions: [SelectSize] = {
        let smallSetting = SelectSize(name: .Small, imageName: "Small")
        let cancelSelection = SelectSize(name: .Cancel, imageName: "Cancel")
        return [SelectSize(name: .Small, imageName: "Small"), SelectSize(name: .Medium, imageName: "Medium"), SelectSize(name: .Large, imageName: "Large"), SelectSize(name: .ExtraLarge, imageName: "Extra Large"), cancelSelection]
    }()
    
    override init() {
        super.init()
        
        cart = CartModel.sharedInstance.cart
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(OptionsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizeOptions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! OptionsCell
        
        let setting = sizeOptions[indexPath.item]
        cell.options = setting
        
        if let imgUrl = selectedProduct.imagesArray().first?.sourceURL {
            cell.iconImageView.loadImageUsingCacheWithNSURL(imgUrl)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width, cellHeight)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let size = self.sizeOptions[indexPath.item]
        handleDismiss(size)
    }
    
    func showSizeOptions (product: BUYProduct) {
        
        if let window = UIApplication.sharedApplication().keyWindow {
            
            let height: CGFloat = CGFloat(sizeOptions.count) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRectMake(0, window.frame.height, window.frame.width, height)
            collectionView.backgroundColor = UIColor.grayColor()
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            blackView.frame = window.frame
            blackView.alpha = 0
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            selectedProduct = product
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRectMake(0, y, self.collectionView.frame.width, self.collectionView.frame.height)
                }, completion: nil)
        }
    }
    func handleDismiss(size: SelectSize) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.sharedApplication().keyWindow {
                self.collectionView.frame = CGRectMake(0, window.frame.height, self.collectionView.frame.width, self.collectionView.frame.height)
            }
            
        }) { (completed: Bool) in
            
            var sizeAvailable = false
            
            switch size.name {
            case .Small:
                if let variant = self.selectedProduct?.variants?.firstObject as? BUYProductVariant {
                    self.cart.addVariant(variant)
                    sizeAvailable = true
                } else {
                    sizeAvailable = false
                }
            case .Medium:
                if let variant = self.selectedProduct?.variants?[1] as? BUYProductVariant {
                    self.cart.addVariant(variant)
                    sizeAvailable = true
                } else {
                    sizeAvailable = false
                }
            case .Large:
                if let variant = self.selectedProduct?.variants?[2] as? BUYProductVariant {
                    self.cart.addVariant(variant)
                    sizeAvailable = true
                } else {
                    sizeAvailable = false
                }
            case .ExtraLarge:
                if let variant = self.selectedProduct?.variants?[3] as? BUYProductVariant {
                    self.cart.addVariant(variant)
                    sizeAvailable = true
                } else {
                    sizeAvailable = false
                }
            case .Cancel:
                print("Cancelled")
            }
            
            if size.name != .Cancel {
                if sizeAvailable {
                    CartModel.sharedInstance.cart = self.cart
                    self.shopifyProductVariationVC?.showShoppingCartWithSelection(size)
                    self.productVariantionVC?.showShoppingCartWithSelection(size)
                } else {
                    print("Size not available")
                    
                    //Need an alert function to handle this
                }
            }
        }
    }
}
