//
//  Header.swift
//  ShopMall
//
//  Created by admin on 8/7/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class Header: UICollectionViewCell {
    
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
        
        //need x, y, width, height constraints
        headerContainerView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        headerContainerView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        headerContainerView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        headerContainerView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
        searchTextField.leftAnchor.constraintEqualToAnchor(headerContainerView.leftAnchor, constant: 20).active = true
        searchTextField.topAnchor.constraintEqualToAnchor(headerContainerView.topAnchor, constant: 5).active = true
        searchTextField.rightAnchor.constraintEqualToAnchor(headerContainerView.rightAnchor, constant: -20).active = true
        searchTextField.bottomAnchor.constraintEqualToAnchor(headerContainerView.bottomAnchor, constant: -5).active = true

    }
}
