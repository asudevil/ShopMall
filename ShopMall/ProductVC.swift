//
//  ProductVC.swift
//  ShopMall
//
//  Created by admin on 8/2/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Buy

class ProductVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var setBackgroundColor = "ffffff"
    var shopifyCollectionId: NSNumber?
    
    var shop: Shop?
    let cellId = "cellId"
    
    var product: Product? {
        didSet {
            self.collectionView?.reloadData()
            if let navBarTitle = product?.name {
                if let storeLogoURL = product?.logoImage {
                    setupNavBarWithUser(navBarTitle, logoImageURL: storeLogoURL)
                }
                if let background = product?.backgroudColor {
                    self.collectionView?.backgroundColor = UIColor.hexStringToUIColor(background)
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.registerClass(ProductVariationCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.hexStringToUIColor(setBackgroundColor)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.productVariations?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ProductVariationCell
        
        if !cell.hasSetupConstraints {
            if let attributes = shop?.productCellNameAttributes {
                cell.setupConstraintsForView(cell.nameLabel, attributes: attributes)
            }
            if let imageAttributes = shop?.productCellImageAttributes {
                cell.setupConstraintsForView(cell.catalogImageView, attributes: imageAttributes)
            }
            if let priceAttributes = shop?.itemPriceAttributes {
                cell.setupConstraintsForView(cell.itemPrice, attributes: priceAttributes)
            }
            cell.hasSetupConstraints = true
        }
        
        if let productVariation = product?.productVariations?[indexPath.row] {
            cell.nameLabel.text = productVariation.name
            
            if let nameFontSize = shop?.productNameFontSize {
                cell.nameLabel.font = UIFont.systemFontOfSize(CGFloat(nameFontSize.floatValue))
            }
            
            cell.itemPrice.text = productVariation.itemDetailPrice
            if let imgUrl = productVariation.imageUrl {
                cell.catalogImageView.loadImageUsingCacheWithUrlString(imgUrl)
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let frameDivider = product?.catalogFrameDivider {
            return CGSizeMake(view.frame.width/frameDivider, 220)
        }
        
        return CGSizeMake(view.frame.width, 220)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, 10)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let productVariationController = ProductVariationController()
        productVariationController.shop = shop
        let productVariation = product?.productVariations?[indexPath.row]
        productVariationController.productVariation = productVariation
        navigationController?.pushViewController(productVariationController, animated: true)
    }
    
    func setupNavBarWithUser(shopName: String, logoImageURL: String) {
        
        let title = shopName
        let titleView = UIView()
        let titleLabel = UILabel()
        titleView.addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraintEqualToAnchor(titleView.centerXAnchor).active = true
        titleLabel.centerYAnchor.constraintEqualToAnchor(titleView.centerYAnchor).active = true
        
        let logoImage = UIImageView()
        titleView.addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.contentMode = .ScaleAspectFill
        logoImage.clipsToBounds = true
        
        logoImage.loadImageUsingCacheWithUrlString(logoImageURL)        
        
        logoImage.rightAnchor.constraintEqualToAnchor(titleLabel.rightAnchor, constant: 70).active = true
        logoImage.centerYAnchor.constraintEqualToAnchor(titleView.centerYAnchor).active = true
        logoImage.widthAnchor.constraintEqualToConstant(30).active = true
        logoImage.heightAnchor.constraintEqualToConstant(30).active = true
        
        let btnName = UIButton()
        titleView.addSubview(btnName)
        btnName.translatesAutoresizingMaskIntoConstraints = false
        
////////////??? How do I set this image to downloaded image from shops.json///////
//        let buttonImage = UIImageView()
//        
//        if let cartImageUrl = shop?.cartImage {
//            
//            buttonImage.loadImageUsingCacheWithUrlString(cartImageUrl, completion: { (image) in
//                btnName.setImage(image, forState: .Normal)
//                print("Inside btnImage completion")
//            })
//        }
//////////////////////////////////////////////////////////////////////////////////
        
        if let cartImageName = shop?.cartImage {
            
            let cartButton = UIButton()
            cartButton.setImage(UIImage(named: cartImageName), forState: .Normal)
            cartButton.frame = CGRectMake(0, 0, 30, 30)
            cartButton.addTarget(self, action: #selector(ShopVC.clickOnCart(_:)), forControlEvents: .TouchUpInside)
            
            let rightBarButton = UIBarButtonItem(customView: cartButton)
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        self.navigationItem.titleView = titleView
    }
    
    func clickOnCart(button: UIButton) {
        print("Cart Button Clicked")
        let layout = UICollectionViewFlowLayout()
        let cartViewController = CartVC(collectionViewLayout: layout)
        cartViewController.shop = shop
        navigationController?.pushViewController(cartViewController, animated: true)
    }

}
