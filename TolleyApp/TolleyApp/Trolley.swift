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
    var allItemInfo = [ItemInfo]()
    var fruitItem = [ItemInfo]()
    var vegetableItem = [ItemInfo]()
    var price = 0.0
    var itCount = 0
    var noItem = 0
    override init() {
        fruitItem = [ItemInfo(itemId: "0001", itemDetail: "Banana Banana",itemPrice: 3.5, itemQuantity: " 1 Kg", itemType: "Fruit", itemImage: #imageLiteral(resourceName: "banana"), itemCount: 0),
                       ItemInfo(itemId: "fru0002", itemDetail: "appricot appricot", itemPrice: 4.5 , itemQuantity: " 1.5 Kg", itemType: "Fruit",itemImage: #imageLiteral(resourceName: "appricot"), itemCount: 0),
                       ItemInfo(itemId: "fru0003", itemDetail: "grap grap", itemPrice: 5.5, itemQuantity: " 2 Kg",itemType: "Fruit", itemImage: #imageLiteral(resourceName: "grap"), itemCount: 0),
                       ItemInfo( itemId: "fru0004", itemDetail: "pear pear", itemPrice: 6.5, itemQuantity: " 2.5 Kg",itemType: "Fruit",itemImage: #imageLiteral(resourceName: "pear"), itemCount: 0)]
        vegetableItem = [ ItemInfo(itemId: "0011", itemDetail: "celiflower celiflower", itemPrice: 3.5, itemQuantity: " 1 Kg", itemType: "Veg",itemImage: #imageLiteral(resourceName: "celiflower"), itemCount: 0),
                          ItemInfo(itemId: "0012", itemDetail: "mixVeg mixVeg", itemPrice: 4.5, itemQuantity: " 1.5 Kg", itemType: "Veg",itemImage: #imageLiteral(resourceName: "mixVeg"), itemCount: 0),
                          ItemInfo(itemId: "0013", itemDetail: "carrot carrot", itemPrice: 5.5, itemQuantity: " 2 Kg",itemType: "Veg",itemImage: #imageLiteral(resourceName: "carrot"), itemCount: 0),
                          ItemInfo(itemId: "0014", itemDetail: "tomato tomato", itemPrice: 6.5, itemQuantity: " 2.5 Kg",itemType: "Veg",itemImage: #imageLiteral(resourceName: "tomato"), itemCount: 0)]
        allItemInfo = fruitItem + vegetableItem
        
    }
    func addItemToTrolley(item: ItemInfo)  {
        if items.count == 0 {
            items.append(item)
            price = price + item.itemPrice
             item.itemCount = item.itemCount + 1
            
            return
        }
        var found = false
        for id in items {
            if (id.itemId == item.itemId) {
                found = true
                item.itemCount = item.itemCount + 1
                price = price + item.itemPrice
                
            } else {
               found = false
            }
        }
        if found == true {
        } else {
            items.append(item)
            price = price + item.itemPrice
            item.itemCount = item.itemCount + 1
            
        }
    }
    func removeItemToTrolley(trolleyItem: ItemInfo)  {
        for item in items {
            if item.itemId == trolleyItem.itemId {
                noItem  =  noItem - 1
                price = price - item.itemPrice
                break
            }
        }
    }
 
   }
