//
//  SummaryCell.swift
//  ShopMall
//
//  Created by admin on 9/11/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import PassKit

class SummaryCell: BaseCustomizableCell {
    
    var subTotalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFontOfSize(CGFloat(20))
        label.text = "Subtotal: $69.99"
        return label
    }()
    
    var checkoutButton: UIButton = {
       let button = UIButton(type: .System)
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Checkout", forState: .Normal)
        button.tintColor = UIColor.whiteColor()
        button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        button.backgroundColor = UIColor.hexStringToUIColor("#f9b905")
        button.layer.cornerRadius = 5
        return button
    }()
    let applePayButton: PKPaymentButton = {
       var appleButton = PKPaymentButton()
        if PKPaymentAuthorizationViewController.canMakePayments() {
            appleButton = PKPaymentButton(type: .Buy, style: .Black)
        } else {
            appleButton = PKPaymentButton(type: .SetUp, style: .Black)
        }
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        return appleButton
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = UIColor.hexStringToUIColor("#dfe3ee")
        addSubview(subTotalLabel)
        addSubview(applePayButton)
        addSubview(checkoutButton)
        subTotalLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        subTotalLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        
        applePayButton.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -10).active = true
        applePayButton.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor, constant: -80).active = true
        applePayButton.widthAnchor.constraintEqualToConstant(140).active = true
        applePayButton.heightAnchor.constraintEqualToConstant(50).active = true
        
        checkoutButton.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -10).active = true
        checkoutButton.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor, constant: 80).active = true
        checkoutButton.widthAnchor.constraintEqualToConstant(140).active = true
        checkoutButton.heightAnchor.constraintEqualToConstant(50).active = true
        
    }
}
