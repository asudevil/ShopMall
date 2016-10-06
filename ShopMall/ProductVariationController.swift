//
//  ProductVariationController.swift
//  ShopMall
//
//  Created by admin on 7/21/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Buy

class ProductVariationController: UIViewController {
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    var itemDetails: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var itemDetailPriceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var addItemButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Cart", forState: .Normal)
        button.setTitleColor(UIColor.hexStringToUIColor("#8b9dc3"), forState: .Selected)
        button.titleLabel?.font = UIFont.systemFontOfSize(CGFloat(20))
        button.titleLabel?.textColor = UIColor.blackColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.hexStringToUIColor("000000")
        return button
    }()
    
    var productVariation: ProductVariation? {
        didSet {
            if let productImageUrl = productVariation?.imageUrl {
                productImageView.loadImageUsingCacheWithUrlString(productImageUrl)
            }
            if let navBarTitle = productVariation?.name {
                navigationItem.title = navBarTitle
            }
            if let itemDesc = productVariation?.itemDescription {
                itemDetails.text = itemDesc
            }
            if let itemPrice = productVariation?.itemDetailPrice {
                itemDetailPriceLabel.text = itemPrice
            }
        }
    }
    
    var shop: Shop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        view.layer.masksToBounds = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.addToCart(_:)))
        view.addSubview(productImageView)
        view.addSubview(itemDetails)
        view.addSubview(itemDetailPriceLabel)
        view.addSubview(addItemButton)
        addItemButton.addTarget(self, action: #selector(self.addToCart(_:)), forControlEvents: .TouchUpInside)
        if let attributes = shop?.itemDetailsImageAttributes {
            view.setupConstraintsForView(productImageView, attributes: attributes)
        }
        if let itemDescAttributes = shop?.itemDescriptionAttributes {
            view.setupConstraintsForView(itemDetails, attributes: itemDescAttributes)
        }
        if let itemDetailPriceAttributes = shop?.itemDetailPriceAttributes {
            view.setupConstraintsForView(itemDetailPriceLabel, attributes: itemDetailPriceAttributes)
        }
        if let addItemButtonAttributes = shop?.addItemButtonAttributes {
            view.setupConstraintsForView(addItemButton, attributes: addItemButtonAttributes)
        }
        if let addItemButtonColor = shop?.addItemButtonColor {
            addItemButton.backgroundColor = UIColor.hexStringToUIColor(addItemButtonColor)
        }
    }
    lazy var optionsSelector: OptionsSelector = {
        let launcher = OptionsSelector()
        launcher.productVariantionVC = self
        return launcher
    }()
    func addToCart (button: UIButton) {
        
//Placeholder for shopify!!
        let dummyProduct = BUYProduct()
        
        optionsSelector.showOptions(dummyProduct)
    }
    func showShoppingCartWithSelection() {
        print("Showing Cart with selected option Clicked")
        let layout = UICollectionViewFlowLayout()
        let cartViewController = CartVC(collectionViewLayout: layout)
        cartViewController.shop = shop
        navigationController?.pushViewController(cartViewController, animated: true)
    }
}
