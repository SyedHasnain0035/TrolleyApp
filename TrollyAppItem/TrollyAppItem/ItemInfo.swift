//
//  ItemInfo.swift
//  TrollyAppItem
//
//  Created by Rashdan Natiq on 16/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import Foundation
import UIKit
class ItemInfo {
    var itemDetail: String!
    var itemPrice: String!
    var itemWeight: String!
    var itemImage: String!
    var itemType: String!
    var active: Int = 0
    init( itemDetail: String, itemPrice: String, itemWeight: String,itemType: String, itemImage: String, active: Int) {
        self.itemDetail = itemDetail
        self.itemPrice = itemPrice
        self.itemWeight = itemWeight
        self.itemType = itemType
        self.itemImage = itemImage
        self.active = active
        
    }
    
    var isActive: Bool {
        get {
            return active == 1
        } set {
            active = newValue ? 1 : 0
        }
    }
}
