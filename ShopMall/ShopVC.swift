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
    fileprivate var client: BUYClient!
    fileprivate var shopifyCollections: [BUYCollection]?
    fileprivate var shopifyProduct: [BUYProduct]?
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    
    var shop: Shop?

    var navBarColorSelected = "#dddddd"
    var headerHeight = CGFloat()
    var cartImageView = UIImageView()
    var cartImageURL = String()
    var activityIndicator = UIActivityIndicatorView()
    
    var shopId: String? {
        didSet {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
           // activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)

            view.addSubview(activityIndicator)
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            activityIndicator.startAnimating()
            
            Service.sharedInstance.fetchShopifyCollections(1, completion: { (collections, error) in
                self.shopifyCollections = collections
                self.collectionView?.reloadData()
                
                self.activityIndicator.stopAnimating()
                
                //handle error
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let shop = self.shop {
            setupNavBarWithUser(shop)
        }
        collectionView?.register(ProductCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)

        collectionView?.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        imageCache.removeAllObjects()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopifyCollections?.count ?? 0

    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProductCell
        
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
        
        if let collection = shopifyCollections?[indexPath.row] {
            cell.nameLabel.text = collection.title
            
            if let nameFontSize = shop?.catalogNameFontSize {
                cell.nameLabel.font = UIFont.systemFont(ofSize: CGFloat(nameFontSize.floatValue))
            }
            
            //Need to add this numberOfLines to JSON
            cell.nameLabel.numberOfLines = 0
            
            cell.bringSubview(toFront: cell.nameLabel)
            
            if let cellTextColor = shop?.catalogTextColor {
                cell.nameLabel.textColor = UIColor.hexStringToUIColor(cellTextColor)
            }
            if let container1Color = shop?.catalogContainer1Color {
                if let container1Alpha = shop?.catalogContainer1Alpha {
                    cell.container1.backgroundColor = UIColor.hexStringToUIColor(container1Color).withAlphaComponent(container1Alpha)
                }else {
                    cell.container1.backgroundColor = UIColor.hexStringToUIColor(container1Color)
                }
            }
            if let catalogImageNSURL = collection.image.sourceURL {
                cell.catalogImageView.loadImageUsingCacheWithNSURL(catalogImageNSURL)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let cellHeight = shop?.tableCellHeight {
            return CGSize(width: view.frame.width, height: cellHeight)
        }
        return CGSize(width: view.frame.width, height: 230)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let product = shop?.products?[indexPath.row]
        let layout = UICollectionViewFlowLayout()
        
        if let collection = shopifyCollections?[indexPath.row] {
            let shopifyProductController = ShopifyProductVC(collectionViewLayout: layout, collection: collection)
            shopifyProductController.shop = shop
            shopifyProductController.product = product
            navigationController?.pushViewController(shopifyProductController, animated: true)
        } else {
            //Need a pop up for error
            print("Need to handle error!!")
        }
    }
    
    //Header (Search, scrow or tab bar or advertisement)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: headerHeight)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! Header
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let cellSpacing = shop?.cellSpacing {
            return cellSpacing
        }
        return 5
    }
    
    func setupNavBarWithUser(_ shop: Shop) {
                
        let title = shop.name
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
        
        if let logoImageUrl = shop.logoImage {
            logoImage.loadImageUsingCacheWithUrlString(logoImageUrl, completion: { (image) in

            })
        }
        logoImage.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        if let cartImageName = shop.cartImage {
            
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
