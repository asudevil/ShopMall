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
    var itemPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var catalogImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .ScaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var catalogDetail: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(CGFloat(12))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //generic containers that can be used to contain random things where needed
    let container1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.redColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let container2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.redColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let container3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.redColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
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
        addSubview(catalogImageView)
        addSubview(dividerLineView)
        addSubview(itemPrice)
        addSubview(catalogDetail)
        self.bringSubviewToFront(catalogDetail)
        
        //generic containers that can be used to contain random things where needed
        addSubview(container1)
        addSubview(container2)
        addSubview(container3)
        backgroundColor = UIColor.whiteColor()
    }
}
