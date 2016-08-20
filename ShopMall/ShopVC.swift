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
    let shopDomain: String = "yoganinja.myshopify.com"
    let apiKey:     String = "706f85f7989134d8225e2ec4da7335b8"
    let appID:      String = "8"
    private var client: BUYClient!
    private var products: [BUYProduct]?
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
//                    client = BUYClient(shopDomain: self.shopDomain, apiKey: self.apiKey, appId: self.appID)
//                    selectedShopId = id
                    
                    selectedShopId = "6"
                    
                    print("Inside didSet")
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
        
        if selectedShopId == "6" {
            print("fetching shopify$$$$")
            Service.sharedInstance.fetchShopifyProducts()
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
            print("yoga ninja products: \(products?.count)")
            return products?.count ?? 0
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
        
        if let product = shop?.products?[indexPath.row] {
            cell.nameLabel.text = product.name
            if let nameFontSize = shop?.productNameFontSize {
                cell.nameLabel.font = UIFont.systemFontOfSize(CGFloat(nameFontSize.floatValue))
            }
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
        let productController = ProductVC(collectionViewLayout: layout)
        productController.shop = shop
        productController.product = product
        navigationController?.pushViewController(productController, animated: true)
    }
    
    
    //Header (Search or scrow bar or tab bar)
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
            logoImage.loadImageUsingCacheWithUrlString(logoImageUrl)
        }
        
        logoImage.centerXAnchor.constraintEqualToAnchor(titleLabel.centerXAnchor).active = true
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
