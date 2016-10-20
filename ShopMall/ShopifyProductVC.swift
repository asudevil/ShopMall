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
        
                Service.sharedInstance.fetchShopifyProductsInCollection(1, collectionId: shopifyCollectionIdentifier, completion: { (products, error) in
                    self.shopifyProducts = products
                    self.collectionView?.reloadData()
                })
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(ProductVariationCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.hexStringToUIColor(setBackgroundColor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        imageCache.removeAllObjects()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopifyProducts?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProductVariationCell
        
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
                    cell.nameLabel.font = UIFont.systemFont(ofSize: CGFloat(nameFontSize.floatValue))
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let frameDivider = product?.catalogFrameDivider {
            return CGSize(width: view.frame.width/frameDivider, height: 220)
        }
        return CGSize(width: view.frame.width, height: 220)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, 10)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let shopifyProductVariation = shopifyProducts?[indexPath.row] {
            
            let productVariationController = ShopifyProductVariationVC(selectedProduct: shopifyProductVariation)
            productVariationController.shop = shop

        navigationController?.pushViewController(productVariationController, animated: true)
        }
    }
    
    func setupNavBarWithUser(_ shopName: String, logoImageURL: String) {
        
        let title = shopName
        let titleView = UIView()
        let titleLabel = UILabel()
        titleView.addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        let logoImage = UIImageView()
        titleView.addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.contentMode = .scaleAspectFill
        logoImage.clipsToBounds = true
        
        logoImage.loadImageUsingCacheWithUrlString(logoImageURL)
        
        logoImage.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 70).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
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
            cartButton.setImage(UIImage(named: cartImageName), for: UIControlState())
            cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            cartButton.addTarget(self, action: #selector(ShopVC.clickOnCart(_:)), for: .touchUpInside)
            
            let rightBarButton = UIBarButtonItem(customView: cartButton)
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        self.navigationItem.titleView = titleView
    }
    
    func clickOnCart(_ button: UIButton) {
        let layout = UICollectionViewFlowLayout()
        let cartViewController = CartVC(collectionViewLayout: layout)
        cartViewController.shop = shop
        navigationController?.pushViewController(cartViewController, animated: true)
    }
    
}
