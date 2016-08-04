//
//  ShopVC.swift
//  ShopMall
//
//  Created by admin on 8/2/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class ShopVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var shop: Shop?
    let cellId = "cellId"
    
    var navBarColorSelected = "#dddddd"
    var cartImageView = UIImageView()
    var cartImageURL = String()
    
    var shopId: String? {
        didSet {
            if let id = shopId {
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
        
        collectionView?.registerClass(ProductCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.whiteColor()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(navBarColorSelected)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shop?.products?.count ?? 0
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ProductCell
        
        if !cell.hasSetupConstraints {
            if let attributes = shop?.productCellAttributes {
                cell.setupConstraintsForView(cell.nameLabel, attributes: attributes)
            }
            if let attributes = shop?.productCatalogImageAttributes {
                cell.setupConstraintsForView(cell.catalogImageView, attributes: attributes)
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
                cell.nameLabel.numberOfLines = 0
            }
            if let catalogImageURL = product.catalogImageUrl {
                cell.catalogImageView.loadImageUsingCacheWithUrlString(catalogImageURL)
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
        
//        let shop = shops?[indexPath.row]
//        let layout = UICollectionViewFlowLayout()
//        let shopController = ShopVC(collectionViewLayout: layout)
//        shopController.shopId = shop?.id?.stringValue
//        
//        navigationController?.pushViewController(shopController, animated: true)
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
            print("Loading logo for \(logoImageUrl)")
            logoImage.loadImageUsingCacheWithUrlString(logoImageUrl)
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ShopController.imageTapped(_:)))
        logoImage.userInteractionEnabled = true
        logoImage.addGestureRecognizer(tapGestureRecognizer)
        
        logoImage.rightAnchor.constraintEqualToAnchor(titleLabel.rightAnchor, constant: 70).active = true
        logoImage.centerYAnchor.constraintEqualToAnchor(titleView.centerYAnchor).active = true
        logoImage.widthAnchor.constraintEqualToConstant(30).active = true
        logoImage.heightAnchor.constraintEqualToConstant(30).active = true
        
        self.navigationItem.titleView = titleView
        
        let btnName = UIButton()
        titleView.addSubview(btnName)
        btnName.translatesAutoresizingMaskIntoConstraints = false
        
        print("Setting navbar items")
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
    
    func imageTapped(img: AnyObject)
    {
        print("Image tapped")
    }

}
