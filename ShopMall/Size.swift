//
//  Size.swift
//  ShopMall
//
//  Created by admin on 9/10/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class SelectSize: NSObject {
    let name: sizeName
    let imageName: String
    
    init(name: sizeName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

enum sizeName: String {
    case Cancel = "Cancel"
    case Small = "Small"
    case Medium = "Medium"
    case Large = "Large"
    case ExtraLarge = "Extra Large"
}
