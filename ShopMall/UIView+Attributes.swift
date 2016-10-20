//
//  UIView+Attributes.swift
//  ShopMall
//
//  Created by admin on 7/21/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

extension UIView {
    
    func setupConstraintsForView(_ view: UIView, attributes: Attributes) {
        if let centerXConstant = attributes.centerXConstant?.CGFloatValue() {
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: centerXConstant).isActive = true
        } else if let leftAnchorConstant = attributes.leftAnchorConstant?.CGFloatValue() {
            view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: leftAnchorConstant).isActive = true
        } else if let rightAnchorConstant = attributes.rightAnchorConstant?.CGFloatValue() {
            view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -rightAnchorConstant).isActive = true
        }
        
        if let centerYConstant = attributes.centerYConstant?.CGFloatValue() {
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: centerYConstant).isActive = true
        } else if let topAnchorConstant = attributes.topAnchorConstant?.CGFloatValue() {
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: topAnchorConstant).isActive = true
        } else if let bottomAnchorConstant = attributes.bottomAnchorConstant?.CGFloatValue() {
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomAnchorConstant).isActive = true
        }
        
        if let width = attributes.width?.CGFloatValue() {
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let width = attributes.widthAnchor {
            if width == "widthAnchor" {
                view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            }
        }
        if let height = attributes.height?.CGFloatValue() {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let height = attributes.heightAnchor {
            if height == "heightAnchor" {
                view.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            }
        }
    }
}
