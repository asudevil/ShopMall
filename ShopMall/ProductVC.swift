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
                navigationItem.title = navBarTitle
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
            if let attributes = shop?.productVariationCellAttributes {
                cell.setupConstraintsForView(cell.nameLabel, attributes: attributes)
            }
            if let imageAttributes = shop?.productVariationCellImageAttributes {
                cell.setupConstraintsForView(cell.catalogImageView, attributes: imageAttributes)
            }
            cell.hasSetupConstraints = true
        }
        
        if let productVariation = product?.productVariations?[indexPath.row] {
            cell.nameLabel.text = productVariation.name
            if let imgUrl = productVariation.imageUrl {
                cell.catalogImageView.loadImageUsingCacheWithUrlString(imgUrl)
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(view.frame.width, 150)
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let productVariationController = ProductVariationController()
        productVariationController.shop = shop
        let productVariation = product?.productVariations?[indexPath.row]
        productVariationController.productVariation = productVariation
        navigationController?.pushViewController(productVariationController, animated: true)
    }

}
