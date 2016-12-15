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
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    var cart: BUYCart!
    var selectedProduct: BUYProduct!
    
    var shopifyProductVariationVC: ShopifyProductVariationVC?
    var productVariantionVC: ProductVariationController?
    
    override init() {
        super.init()
        
        cart = CartModel.sharedInstance.cart
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OptionsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedProduct.variantsArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OptionsCell
        let setting = selectedProduct.variantsArray()[indexPath.item]
        cell.options = setting
        
        if let imgUrl = selectedProduct.imagesArray().first?.sourceURL {
            cell.iconImageView.loadImageUsingCacheWithNSURL(imgUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clickedOption = selectedProduct.variantsArray()[indexPath.item].title
        print(clickedOption ?? "")
        handleDismiss(indexPath.item)
    }
    
    func showOptions (_ product: BUYProduct) {
        
        if let window = UIApplication.shared.keyWindow {
            
            let height: CGFloat = CGFloat(product.variantsArray().count) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            collectionView.backgroundColor = UIColor.gray
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            blackView.frame = window.frame
            blackView.alpha = 0
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            selectedProduct = product
            
            print(selectedProduct.optionsArray().first?.name ?? "")
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    func handleDismiss(_ selectedOption: Int) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            
        }) { (completed: Bool) in
            
            var optionAvailable = false
            
            if selectedOption <= self.selectedProduct.variantsArray().count {
            
            if let variant = self.selectedProduct?.variants?[selectedOption] as? BUYProductVariant {
                self.cart.add(variant)
                CartModel.sharedInstance.cart = self.cart
                optionAvailable = true
            } else {
                optionAvailable = false
            }
            
            if optionAvailable {
                self.shopifyProductVariationVC?.showShoppingCartWithSelection()
                self.productVariantionVC?.showShoppingCartWithSelection()
            } else {
                let alertMessage = "The selected item type is not available.  Please select a different option"
                let alert = UIAlertController(title: "Item Unavailable", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.productVariantionVC?.present(alert, animated: true, completion: nil)
                self.shopifyProductVariationVC?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
