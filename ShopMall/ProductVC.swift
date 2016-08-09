//
//  ProductVC.swift
//  ShopMall
//
//  Created by admin on 8/2/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class ProductVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var numberOfColumns = 1
    
    var product: Product? {
        didSet {
            self.collectionView?.reloadData()
            if let navBarTitle = product?.name {
              //  navigationItem.title = navBarTitle
                if let storeLogoURL = product?.logoImage {
                    setupNavBarWithUser(navBarTitle, logoImageURL: storeLogoURL)
                }
            }
        }
    }
    
    var shop: Shop?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.registerClass(ProductVariationCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: nil)
        collectionView?.backgroundColor = UIColor.whiteColor()
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
            if let imgUrl = productVariation.imageUrl {
                cell.catalogImageView.loadImageUsingCacheWithUrlString(imgUrl)
            }
        }
        if let productPrice = product?.itemPrice {
            cell.itemPrice.text = productPrice
        }        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(view.frame.width, 220)
        
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
        
        self.navigationItem.titleView = titleView
        
        let btnName = UIButton()
        titleView.addSubview(btnName)
        btnName.translatesAutoresizingMaskIntoConstraints = false
        
        // btnName.setImage(cartImageView.image, forState: .Normal)
        
        //??? How do I set this image to downloaded image from shops.json
        let btnImage = UIImage(named: "default-cart")
        btnName.setImage(btnImage, forState: .Normal)
        btnName.addTarget(self, action: nil, forControlEvents: .TouchUpInside)
        btnName.rightAnchor.constraintEqualToAnchor(titleLabel.rightAnchor, constant: 150).active = true
        btnName.centerYAnchor.constraintEqualToAnchor(titleView.centerYAnchor).active = true
        btnName.widthAnchor.constraintEqualToConstant(30).active = true
        btnName.heightAnchor.constraintEqualToConstant(30).active = true
    }

}
