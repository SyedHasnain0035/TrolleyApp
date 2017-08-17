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
    var itemPrice: String!
    var itemWeight: String!
    var itemImage: String!
    var itemType: String!
    var itemActive: Int!
    var itemCount: Int!
    init(itemId: String, itemDetail: String, itemPrice: String, itemWeight: String,itemType: String, itemImage: String, itemActive: Int, itemCount: Int) {
        self.itemId = itemId
        self.itemDetail = itemDetail
        self.itemPrice = itemPrice
        self.itemWeight = itemWeight
        self.itemType = itemType
        self.itemImage = itemImage
        self.itemActive = itemActive
        self.itemCount = itemCount
    }
}
