//
//  ViewController.swift
//  ShopMall
//
//  Created by Brian Voong on 7/21/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class MallController: UITableViewController {
    
    var shops: [Shop]?
    
    let cellId = "cellId"
    
    let navBarColor = UIColor.redColor()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Shopping Mall"
        
        navigationController?.navigationBar.barTintColor = navBarColor
        
        tableView.registerClass(MallShopCell.self, forCellReuseIdentifier: cellId)
        
        Service.sharedInstance.fetchShops { (shops) in
            self.shops = shops
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = navBarColor
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        
        let shop = shops?[indexPath.row]
        cell.textLabel?.text = shop?.name
        cell.detailTextLabel?.text = shop?.detail
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let shop = shops?[indexPath.row]
        let shopController = ShopController()
        shopController.shopId = shop?.id?.stringValue
        navigationController?.pushViewController(shopController, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

}

class MallShopCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

