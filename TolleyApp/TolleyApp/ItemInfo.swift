//
//  ItemInfo.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 03/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import Foundation
import UIKit
class ItemInfo {
    var itemId: String!
    var itemDetail: String!
    var itemPrice: Double!
    var itemQuantity: String!
    var itemImage: UIImage!
    var itemType: String!
    var itemCount: Int!
    init(itemId: String, itemDetail: String, itemPrice: Double, itemQuantity: String,itemType: String, itemImage: UIImage, itemCount: Int) {
        self.itemId = itemId
        self.itemDetail = itemDetail
        self.itemPrice = itemPrice
        self.itemQuantity = itemQuantity
        self.itemType = itemType
        self.itemImage = itemImage
        self.itemCount = itemCount
    }
}
