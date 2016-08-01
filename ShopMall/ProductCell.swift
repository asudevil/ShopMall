//
//  ProductCell.swift
//  ShopMall
//
//  Created by Brian Voong on 7/21/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class ProductCell: BaseCustomizableCell {
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var catalogImageView: UIImageView = {
        let image = UIImageView()
 //       image.image = UIImage(named: "YogaNinja_icon_400_240")
        image.contentMode = .ScaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(nameLabel)
        addSubview(catalogImageView)
        
        //x,y, width, height constraints
//        catalogImageView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
//        catalogImageView.topAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
//        catalogImageView.widthAnchor.constraintEqualToConstant(300).active = true
//
//        nameLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
//        nameLabel.topAnchor.constraintEqualToAnchor(catalogImageView.bottomAnchor, constant: 5).active = true
        
   //     addConstraintsWithFormat("V:|[v0(100)]-10-[v1(20)]", views: catalogImageView, nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
