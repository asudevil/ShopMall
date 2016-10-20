//
//  titleViewCell.swift
//  ShopMall
//
//  Created by admin on 7/29/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class TitleViewCell: UIView {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Testing Testing"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cartImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "default-cart")
        image.contentMode = .scaleAspectFill
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
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        cartImage.centerXAnchor.constraint(equalTo: self.rightAnchor, constant: 180).isActive = true
        cartImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cartImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        cartImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
}
