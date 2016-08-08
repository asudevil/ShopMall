//
//  titleViewCell.swift
//  ShopMall
//
//  Created by admin on 7/29/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class TitleViewCell: UIView {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Testing Testing"
        label.textColor = UIColor.whiteColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cartImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "default-cart")
        image.contentMode = .ScaleAspectFill
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
        addSubview(titleLabel)
        addSubview(cartImage)
        titleLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        titleLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        
        cartImage.centerXAnchor.constraintEqualToAnchor(self.rightAnchor, constant: 180).active = true
        cartImage.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        cartImage.widthAnchor.constraintEqualToConstant(25).active = true
        cartImage.heightAnchor.constraintEqualToConstant(25).active = true
        
        
       // addConstraintsWithFormat("V:|[v0]", views: titleLabel)
    }
}