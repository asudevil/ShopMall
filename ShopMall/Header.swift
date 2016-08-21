//
//  Header.swift
//  ShopMall
//
//  Created by admin on 8/7/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class Header: BaseCustomizableCell {
    
    let headerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.textAlignment = .Center
        textField.backgroundColor = UIColor.whiteColor()
        textField.layer.cornerRadius = 5
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    var headerImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .ScaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = UIColor.blueColor()
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
        addSubview(headerContainerView)
        headerContainerView.addSubview(searchTextField)
        headerContainerView.addSubview(headerImageView)
        
        //need x, y, width, height constraints

    }
}
