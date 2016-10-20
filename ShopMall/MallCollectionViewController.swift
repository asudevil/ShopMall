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
    
    let navBarColor = UIColor.red

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Shopping Mall"
                
        self.collectionView!.register(ShopCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.backgroundColor = UIColor.white

        Service.sharedInstance.fetchShops { (shops) in
            self.shops = shops
            self.collectionView!.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = navBarColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        imageCache.removeAllObjects()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ShopCell
        
        let shop = shops?[indexPath.row]
        cell.nameLabel.text = shop?.name
        if let nameFontSize = shop?.storeNameFontSize {
            cell.nameLabel.font = UIFont.systemFont(ofSize: CGFloat(nameFontSize.floatValue))
        }
        if let appImageUrl = shop?.appImageUrl {
            cell.imageView.loadImageUsingCacheWithUrlString(appImageUrl)
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let shop = shops?[indexPath.row]
        if let shopAPIInfo = shop?.shopAPIInfoDictionary {
            Service.sharedInstance.setShopAPIInfo(shopAPIInfo)
            CartModel.sharedInstance.setShopAPI(shopAPIInfo)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 10)
    }
}
