//
//  UIView+Attributes.swift
//  ShopMall
//
//  Created by admin on 7/21/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

extension UIView {
    
    func setupConstraintsForView(view: UIView, attributes: Attributes) {
        if let centerXConstant = attributes.centerXConstant?.CGFloatValue() {
            view.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor, constant: centerXConstant).active = true
        } else if let leftAnchorConstant = attributes.leftAnchorConstant?.CGFloatValue() {
            view.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: leftAnchorConstant).active = true
        } else if let rightAnchorConstant = attributes.rightAnchorConstant?.CGFloatValue() {
            view.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -rightAnchorConstant).active = true
        }
        
        if let centerYConstant = attributes.centerYConstant?.CGFloatValue() {
            view.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor, constant: centerYConstant).active = true
        } else if let topAnchorConstant = attributes.topAnchorConstant?.CGFloatValue() {
            view.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: topAnchorConstant).active = true
        } else if let bottomAnchorConstant = attributes.bottomAnchorConstant?.CGFloatValue() {
            view.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -bottomAnchorConstant).active = true
        }
        
        if let width = attributes.width?.CGFloatValue() {
            view.widthAnchor.constraintEqualToConstant(width).active = true
        }
        if let width = attributes.widthAnchor {
            if width == "widthAnchor" {
                view.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
            }
        }
        if let height = attributes.height?.CGFloatValue() {
            view.heightAnchor.constraintEqualToConstant(height).active = true
        }
        if let height = attributes.heightAnchor {
            if height == "heightAnchor" {
                view.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
            }
        }
    }
}
