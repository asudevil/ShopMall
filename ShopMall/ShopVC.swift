//
//  ShopVC.swift
//  ShopMall
//
//  Created by admin on 8/2/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Buy

class ShopVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    

    //Shopify
    private let shopDomain: String = "yoganinja.myshopify.com"
    private let apiKey:     String = "706f85f7989134d8225e2ec4da7335b8"
    private let appID:      String = "8"
    private var client: BUYClient!
    private var shopifyCollections: [BUYCollection]?
    private var selectedShopId = ""
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    
    var shop: Shop?

    var navBarColorSelected = "#dddddd"
    var headerHeight = CGFloat()
    var cartImageView = UIImageView()
    var cartImageURL = String()
    
    var shopId: String? {
        didSet {
            if let id = shopId {
                if id == "6" {
                    
                    Service.sharedInstance.fetchShopifyCollections(1, shopDomain: shopDomain, apiKey: apiKey, appId: appID, completion: { (collections, error) in
                        self.shopifyCollections = collections
                        self.collectionView?.reloadData()
                        
                        //handle error
                    })
                    selectedShopId = id
                }
                
                Service.sharedInstance.fetchShop(id, completion: { (shop) in
                    self.shop = shop
                    if let navBarColor = shop.navBarColor {
                        self.navBarColorSelected = navBarColor
                    }
                    self.setupNavBarWithUser(shop)
                    self.collectionView!.reloadData()
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let shop = self.shop {
            setupNavBarWithUser(shop)
        }
        collectionView?.registerClass(ProductCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.registerClass(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)

        collectionView?.backgroundColor = UIColor.whiteColor()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(navBarColorSelected)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedShopId == "6" {
            return shopifyCollections?.count ?? 0
        }
        
        return shop?.products?.count ?? 0
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ProductCell
        
        if !cell.hasSetupConstraints {
            if let attributes = shop?.catalogNameAttributes {
                cell.setupConstraintsForView(cell.nameLabel, attributes: attributes)
            }
            if let attributes = shop?.catalogDetailAttributes {
                cell.setupConstraintsForView(cell.catalogDetail, attributes: attributes)
            }
            if let attributes = shop?.catalogImageAttributes {
                cell.setupConstraintsForView(cell.catalogImageView, attributes: attributes)
            }
            if let container1Attributes = shop?.catalogContainer1Attributes {
                cell.setupConstraintsForView(cell.container1, attributes: container1Attributes)
            }
            if let cellColor = shop?.cellColor {
                cell.backgroundColor = UIColor.hexStringToUIColor(cellColor)
            }
            cell.hasSetupConstraints = true
        }
        
    // Shopify
        if selectedShopId == "6" {
            
            if let collection = shopifyCollections?[indexPath.row] {
                cell.nameLabel.text = collection.title
                                
                if let nameFontSize = shop?.catalogNameFontSize {
                    cell.nameLabel.font = UIFont.systemFontOfSize(CGFloat(nameFontSize.floatValue))
                }
                
                //Need to add this numberOfLines to JSON
                cell.nameLabel.numberOfLines = 0
                
                cell.bringSubviewToFront(cell.nameLabel)
                
                if let cellTextColor = shop?.catalogTextColor {
                    cell.nameLabel.textColor = UIColor.hexStringToUIColor(cellTextColor)
                }
                if let container1Color = shop?.catalogContainer1Color {
                    if let container1Alpha = shop?.catalogContainer1Alpha {
                        cell.container1.backgroundColor = UIColor.hexStringToUIColor(container1Color).colorWithAlphaComponent(container1Alpha)
                    }else {
                        cell.container1.backgroundColor = UIColor.hexStringToUIColor(container1Color)
                    }
                }
                if let catalogImageNSURL = collection.image.sourceURL {
                    cell.catalogImageView.loadImageUsingCacheWithNSURL(catalogImageNSURL)
                }
            }
        }
    // End shopify
        else {
            if let product = shop?.products?[indexPath.row] {
                cell.nameLabel.text = product.name
                if let nameFontSize = shop?.catalogNameFontSize {
                    cell.nameLabel.font = UIFont.systemFontOfSize(CGFloat(nameFontSize.floatValue))
                }
                
                //Need to add this numberOfLines to JSON
                cell.nameLabel.numberOfLines = 0
                
                cell.bringSubviewToFront(cell.nameLabel)
                
                if let cellTextColor = shop?.catalogTextColor {
                    cell.nameLabel.textColor = UIColor.hexStringToUIColor(cellTextColor)
                }
                if let container1Color = shop?.catalogContainer1Color {
                    if let container1Alpha = shop?.catalogContainer1Alpha {
                        cell.container1.backgroundColor = UIColor.hexStringToUIColor(container1Color).colorWithAlphaComponent(container1Alpha)
                    }else {
                        cell.container1.backgroundColor = UIColor.hexStringToUIColor(container1Color)
                    }
                }
                if let catalogImageURL = product.catalogImageUrl {
                    cell.catalogImageView.loadImageUsingCacheWithUrlString(catalogImageURL)
                }
                if let catalogDetail = product.catalogDetail {
                    cell.catalogDetail.text = catalogDetail
                }
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let cellHeight = shop?.tableCellHeight {
            return CGSizeMake(view.frame.width, cellHeight)
        }
        return CGSizeMake(view.frame.width, 230)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let product = shop?.products?[indexPath.row]
        let layout = UICollectionViewFlowLayout()
        
        //Shopify
        if selectedShopId == "6" {
            if let collection = shopifyCollections?[indexPath.row] {
                let shopifyProductController = ShopifyProductVC(collectionViewLayout: layout, collection: collection)
                shopifyProductController.shop = shop
                shopifyProductController.product = product
                navigationController?.pushViewController(shopifyProductController, animated: true)
            } else {
                
                //Need a pop up for error
                
                print("Need to handle error!!")
            }
        
        }else {
            let productController = ProductVC(collectionViewLayout: layout)
            productController.shop = shop
            productController.product = product
            navigationController?.pushViewController(productController, animated: true)
        }
    }
    
    
    //Header (Search, scrow or tab bar or advertisement)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(view.frame.width, headerHeight)
    }
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerId, forIndexPath: indexPath) as! Header
        if !header.hasSetupConstraints {
            
            if let attributes = shop?.catalogHeaderContainerAttributes {
                header.setupConstraintsForView(header.headerContainerView, attributes: attributes)
            }
            if let attributes = shop?.searchTextFieldAttributes {
                header.headerContainerView.setupConstraintsForView(header.searchTextField, attributes: attributes)
            }
            if let attributes = shop?.headerImageAttributes {
                header.headerContainerView.setupConstraintsForView(header.headerImageView, attributes: attributes)
            }
            
            header.hasSetupConstraints = true
        }
        if let headerImageUrl = shop?.headerImageUrl {
            header.headerImageView.loadImageUsingCacheWithUrlString(headerImageUrl)
        }
        
        if let headerColor = shop?.headerColor {
            header.backgroundColor = UIColor.hexStringToUIColor(headerColor)
        }
        
        return header
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        if let cellSpacing = shop?.cellSpacing {
            return cellSpacing
        }
        return 5
    }
    
    
    func setupNavBarWithUser(shop: Shop) {
                
        let title = shop.name
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
        
        if let logoImageUrl = shop.logoImage {
            logoImage.loadImageUsingCacheWithUrlString(logoImageUrl, completion: { (image) in

            })
        }
        logoImage.centerXAnchor.constraintEqualToAnchor(titleLabel.centerXAnchor).active = true
        logoImage.centerYAnchor.constraintEqualToAnchor(titleView.centerYAnchor).active = true
        logoImage.widthAnchor.constraintEqualToConstant(30).active = true
        logoImage.heightAnchor.constraintEqualToConstant(30).active = true
        
        if let cartImageName = shop.cartImage {
            
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
