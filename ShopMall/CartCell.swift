//
//  CartCell.swift
//  ShopMall
//
//  Created by admin on 8/30/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class CartCell: BaseCustomizableCell {
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is the tile of item"
        
        return label
    }()
    var sizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "size is XL"
        return label
    }()
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "price is $10000"
        return label
    }()
    var qtyLabel: UILabel = {
        let label = UILabel()
        label.text = "QTY is 1000"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var itemImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .ScaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(nameLabel)
        self.addSubview(sizeLabel)
        self.addSubview(priceLabel)
        self.addSubview(qtyLabel)
        self.addSubview(itemImageView)
        
        self.backgroundColor = UIColor.whiteColor()
        itemImageView.backgroundColor = UIColor.greenColor()
    }
}
