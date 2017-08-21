//
//  Trolley.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 04/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
// singelton class
class Trolley: NSObject {
    static let shared = Trolley()
    var items = [ItemInfo]()
    var allItemInfo = [ItemInfo]()
    var fruitItem = [ItemInfo]()
    var vegetableItem = [ItemInfo]()
    var price = 0.0
    var itCount = 0
    var noItem = 0
    override init() {
    }
    func addItemToTrolley(item: ItemInfo)  {
        if items.count == 0 {
            items.append(item)
            price = price + item.itemPrice.toDouble()!
             item.itemCount = item.itemCount + 1
            
            return
        }
        var found = false
        for id in items {
            if (id.itemId == item.itemId) {
                found = true
                item.itemCount = item.itemCount + 1
                price = price + item.itemPrice.toDouble()!
                
            } else {
               found = false
            }
        }
        if found == true {
        } else {
            items.append(item)
            price = price + item.itemPrice.toDouble()!
            item.itemCount = item.itemCount + 1
            
        }
    }
    func removeItemToTrolley(trolleyItem: ItemInfo)  {
        for item in items {
            if item.itemId == trolleyItem.itemId {
                noItem  =  noItem - 1
                price = price - item.itemPrice.toDouble()!
                break
            }
        }
    }
    func deleteAll () {
        allItemInfo = []
        fruitItem = []
        vegetableItem = []
    }
   }
extension String {
    func toDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        return numberFormatter.number(from: self)?.doubleValue
    }
}

