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
        label.font = UIFont.boldSystemFont(ofSize: CGFloat(20))
        label.text = "Subtotal: $69.99"
        return label
    }()
    
    var checkoutButton: UIButton = {
       let button = UIButton(type: .system)
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Checkout", for: UIControlState())
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        button.backgroundColor = UIColor.hexStringToUIColor("#f9b905")
        button.layer.cornerRadius = 5
        return button
    }()
    let applePayButton: PKPaymentButton = {
       var appleButton = PKPaymentButton()
        if PKPaymentAuthorizationViewController.canMakePayments() {
            appleButton = PKPaymentButton(type: .buy, style: .black)
        } else {
            appleButton = PKPaymentButton(type: .setUp, style: .black)
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
        subTotalLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        subTotalLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
        applePayButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        applePayButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -80).isActive = true
        applePayButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        applePayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        checkoutButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        checkoutButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 80).isActive = true
        checkoutButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        checkoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
}
