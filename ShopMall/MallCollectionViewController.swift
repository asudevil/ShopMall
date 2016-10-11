//
//  MallCollectionViewController.swift
//  ShopMall
//
//  Created by admin on 7/22/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class MallCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var shops: [Shop]?
    
    let cellId = "cellId"
    
    let navBarColor = UIColor.redColor()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Shopping Mall"
                
        self.collectionView!.registerClass(ShopCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.backgroundColor = UIColor.whiteColor()

        Service.sharedInstance.fetchShops { (shops) in
            self.shops = shops
            self.collectionView!.reloadData()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = navBarColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        imageCache.removeAllObjects()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ShopCell
        
        let shop = shops?[indexPath.row]
        cell.nameLabel.text = shop?.name
        if let nameFontSize = shop?.storeNameFontSize {
            cell.nameLabel.font = UIFont.systemFontOfSize(CGFloat(nameFontSize.floatValue))
        }
        if let appImageUrl = shop?.appImageUrl {
            cell.imageView.loadImageUsingCacheWithUrlString(appImageUrl)
        }
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let shop = shops?[indexPath.row]
        let layout = UICollectionViewFlowLayout()
        let shopController = ShopVC(collectionViewLayout: layout)
        shopController.shopId = shop?.id?.stringValue
        if let headerOrNot = shop?.headerSize {
            shopController.headerHeight = headerOrNot
        }
        
        if let shopId = shop?.id?.stringValue {
            Service.sharedInstance.fetchShop(shopId, completion: { (shop) in
                if let navBarColor = shop.navBarColor {
                    self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(navBarColor)
                }
                shopController.shop = shop
                shopController.setupNavBarWithUser(shop)
                shopController.collectionView?.reloadData()
                self.navigationController?.pushViewController(shopController, animated: true)
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 230)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(view.frame.width, 10)
    }
}