//
//  CartVC.swift
//  ShopMall
//
//  Created by admin on 8/30/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CartVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var shop: Shop?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerClass(CartCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.navigationItem.title = "Shopping Cart"
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CartCell
        
        if !cell.hasSetupConstraints {
            if let attributes = shop?.cartItemImageAttributes {
                cell.setupConstraintsForView(cell.itemImageView, attributes: attributes)
            }
            if let attributes = shop?.cartItemNameAttributes {
                cell.setupConstraintsForView(cell.nameLabel, attributes: attributes)
            }
            if let attributes = shop?.cartItemPriceAttributes {
                cell.setupConstraintsForView(cell.priceLabel, attributes: attributes)
            }
            if let attributes = shop?.cartItemSizeAttributes {
                cell.setupConstraintsForView(cell.sizeLabel, attributes: attributes)
            }
            if let attributes = shop?.cartItemQtyAttributes {
                cell.setupConstraintsForView(cell.qtyLabel, attributes: attributes)
            }
            

            cell.hasSetupConstraints = true
        }

        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 200)
    }
}
