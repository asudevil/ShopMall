//
//  ShopifyProductVC.swift
//  ShopMall
//
//  Created by admin on 8/28/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Buy

private let reuseIdentifier = "Cell"

class ShopifyProductVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let shopDomain: String = "yoganinja.myshopify.com"
    private let apiKey:     String = "706f85f7989134d8225e2ec4da7335b8"
    private let appID:      String = "8"
    
    var setBackgroundColor = "ffffff"
    var shopifyCollectionId: NSNumber?
    var shopifyProducts: [BUYProduct]?
    
    var shop: Shop?
    let cellId = "cellId"
    
    init(collectionViewLayout: UICollectionViewLayout, collection: BUYCollection) {
        super.init(collectionViewLayout: collectionViewLayout)
        
        self.shopifyCollectionId = collection.identifier
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            if let shopifyCollectionIdentifier = shopifyCollectionId {
        
                Service.sharedInstance.fetchShopifyProductsInCollection(1, collectionId: shopifyCollectionIdentifier, shopDomain: shopDomain, apiKey: apiKey, appId: appID, completion: { (products, error) in
                    self.shopifyProducts = products
                    self.collectionView?.reloadData()
                })
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.registerClass(ProductVariationCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.hexStringToUIColor(setBackgroundColor)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopifyProducts?.count ?? 0
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
        
        if shopifyCollectionId != nil {
            
            if let productVariation = shopifyProducts?[indexPath.row] {
                cell.nameLabel.text = productVariation.title                
                if let nameFontSize = shop?.productNameFontSize {
                    cell.nameLabel.font = UIFont.systemFontOfSize(CGFloat(nameFontSize.floatValue))
                }
                
                if let price = productVariation.variantsArray().first?.price {
                    cell.itemPrice.text = "$\(price).00"
                }
                if let imgUrl = productVariation.imagesArray().first?.sourceURL {
                    cell.catalogImageView.loadImageUsingCacheWithNSURL(imgUrl)
                }
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
        if let shopifyProductVariation = shopifyProducts?[indexPath.row] {
            
            let productVariationController = ShopifyProductVariationVC(selectedProduct: shopifyProductVariation)
            productVariationController.shop = shop
  //          let productVariation = product?.productVariations?[indexPath.row]
    
  //      productVariationController.productVariation = productVariation
        navigationController?.pushViewController(productVariationController, animated: true)
        }
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
            cartButton.addTarget(self, action: #selector(ShopVC.clickOnButton(_:)), forControlEvents: .TouchUpInside)
            
            let rightBarButton = UIBarButtonItem(customView: cartButton)
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        self.navigationItem.titleView = titleView
    }
    
    func clickOnButton(button: UIButton) {
        print("Cart Button Clicked")
    }
    
}
