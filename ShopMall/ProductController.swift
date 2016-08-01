//
//  ProductDetalController.swift
//  ShopMall
//
//  Created by Brian Voong on 7/21/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class ProductController: UITableViewController {
    
    var product: Product? {
        didSet {
            self.tableView.reloadData()
            if let navBarTitle = product?.name {
                navigationItem.title = navBarTitle
            }
        }
    }
    
    var shop: Shop?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(ProductVariationCell.self, forCellReuseIdentifier: cellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: nil)

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product?.productVariations?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ProductVariationCell
        
        if !cell.hasSetupConstraints {
            if let attributes = shop?.productVariationCellAttributes {
                cell.setupConstraintsForView(cell.nameLabel, attributes: attributes)
                print("Attributes set")
            }
            cell.hasSetupConstraints = true
        }
        
        if let productVariation = product?.productVariations?[indexPath.row] {
            cell.nameLabel.text = productVariation.name
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let productVariationController = ProductVariationController()
        productVariationController.shop = shop
        let productVariation = product?.productVariations?[indexPath.row]
        productVariationController.productVariation = productVariation
        navigationController?.pushViewController(productVariationController, animated: true)
    }
    
}
