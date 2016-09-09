//
//  ShopifyProductVariationVC.swift
//  ShopMall
//
//  Created by admin on 8/28/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Buy

class ShopifyProductVariationVC: UIViewController {
    
    private let shopDomain: String = "yoganinja.myshopify.com"
    private let apiKey:     String = "706f85f7989134d8225e2ec4da7335b8"
    private let appID:      String = "8"
    
    var product: BUYProduct?
    var client: BUYClient!
    var cart: BUYCart!
    
    
    let cartDictionary = Dictionary<String, AnyObject>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(selectedProduct: BUYProduct) {
        super.init(nibName: nil, bundle: nil)
        self.product = selectedProduct
    }

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
        button.titleLabel?.font = UIFont.systemFontOfSize(CGFloat(20))
        button.titleLabel?.textColor = UIColor.blackColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.hexStringToUIColor("000000")
        return button
    }()
    
    var shop: Shop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client = BUYClient(shopDomain: shopDomain, apiKey: apiKey, appId: appID)
        
        view.backgroundColor = UIColor.whiteColor()
        view.layer.masksToBounds = true
        
        if let navBarTitle = product?.title {
            navigationItem.title = navBarTitle
        }
        if let itemDesc = product?.stringDescription {
            itemDetails.text = itemDesc
        }
        if let itemPrice = product?.variantsArray().first?.price {
            itemDetailPriceLabel.text = "$\(itemPrice).00"
        }
        if let productImageNSURL = product?.images.firstObject?.sourceURL {
            productImageView.loadImageUsingCacheWithNSURL(productImageNSURL)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.addToCart(_:)))
        view.addSubview(productImageView)
        view.addSubview(itemDetails)
        view.addSubview(itemDetailPriceLabel)
        view.addSubview(addItemButton)
        
        cart = client.modelManager.insertCartWithJSONDictionary(cartDictionary)

        addItemButton.addTarget(self, action: #selector(self.addToCart(_:)), forControlEvents: .TouchUpInside)
        print(cart.lineItems.count)

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
        launcher.shopifyProductVariationVC = self
        return launcher
    }()

    func addToCart (button: UIButton) {
        optionsSelector.showSizeOptions()
        
        if let variant = product?.variants.firstObject as? BUYProductVariant {
            cart.setVariant(variant, withTotalQuantity: 2)
            print(cart.lineItems)
            print("Number of items: \(cart.lineItemsArray().count)")
        }
    }
    func showShoppingCartWithSelection(size: SelectSize) {
        print("Showing Cart with selected size Clicked")
        let layout = UICollectionViewFlowLayout()
        let cartViewController = CartVC(collectionViewLayout: layout)
        cartViewController.shop = shop
        navigationController?.pushViewController(cartViewController, animated: true)
    }
}
