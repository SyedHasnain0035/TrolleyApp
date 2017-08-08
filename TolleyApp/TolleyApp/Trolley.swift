//
//  Trolley.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 04/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import Foundation
import UIKit
// singelton class
class Trolley: NSObject {
    static let shared = Trolley()
    var items = [ItemInfo]()
    var price = 0.0
    var itCount = 0
    var noItem = 0
    override init() {
    }
    func addItemToTrolley(item: ItemInfo)  {
        if items.count == 0 {
            items.append(item)
            price = price + item.itemPrice
             item.itemCount = item.itemCount + 1
            noItem = noItem + 1
            return
        }
        var found = false
        for id in items {
            if (id.itemId == item.itemId) {
                found = true
                item.itemCount = item.itemCount + 1
                price = price + item.itemPrice
                noItem = noItem + 1
            } else {
               found = false
            }
        }
        if found == true {
        } else {
            items.append(item)
            price = price + item.itemPrice
            item.itemCount = item.itemCount + 1
            noItem = noItem + 1
        }
    }
    func removeItemToTrolley(trolleyItem: ItemInfo)  {
        for item in items {
            if item.itemId == trolleyItem.itemId {
                noItem  =  noItem - 1
                price = price - item.itemPrice
                
                if noItem < 0 {
                    noItem = 0
                    price = 0.0
                }
                break
            }
        }
    }
 
   }
