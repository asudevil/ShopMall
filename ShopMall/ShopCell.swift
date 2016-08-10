//
//  ShopCell.swift
//  ShopMall
//
//  Created by admin on 7/22/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class ShopCell: UICollectionViewCell {
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let imageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "YogaNinja_icon_400_240")
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
        addSubview(nameLabel)
        addSubview(dividerLineView)
        addSubview(imageView)
        
        imageView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        nameLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        dividerLineView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        
        addConstraintsWithFormat("V:|[v0(180)]-10-[v1(20)]", views: imageView, nameLabel)
        addConstraintsWithFormat("H:|[v0]|", views: dividerLineView)
        addConstraintsWithFormat("V:[v0(1)]|", views: dividerLineView)
        
    }
}
