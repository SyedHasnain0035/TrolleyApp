//
//  AppAllData.swift
//  TrollyAppItem
//
//  Created by Rashdan Natiq on 29/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth
import  Firebase
import FirebaseDatabase

class AppAllData: NSObject {
    static let shared = AppAllData()
    var allItemInfo = [ItemInfo]()
    var userDetailInfo = [UserDetail]()
    var ordetItemInfo = [OrderItem]()
    var ref: DatabaseReference?
    var numberCount = 0
    func getUserDetail(id: String) -> [UserDetail] {
        let user = userDetailInfo.filter({
            $0.userId == id
        })
        return user
    }
    func getItemDetail(id: String) -> [ItemInfo] {
        let item = allItemInfo.filter({
            $0.id == id
        })
        return item
    }
    func getOrderItemDetail(id: String) -> [OrderItem] {
        let item = ordetItemInfo.filter({
            $0.userId == id
        })
        return item
    }
    func deleteAll() {
        allItemInfo = []
        userDetailInfo = []
        ordetItemInfo = []
    }
    func fetchItemsWithCount(number: Int, uiView: UIViewController)  {
        Database.database().reference().child("ItemDetail").observe(.childAdded, with: { (snapShot) in
            if  let dic = snapShot.value as? [String: Any] {
                self.numberCount = self.numberCount + 1
                let itemDetail1 = ItemInfo(id: dic["ItemId"] as! String, itemDetail: dic["Detail"] as! String, itemPrice: dic["Price"] as! String, itemWeight: dic["Weight"] as! String, itemType: dic["Type"] as! String, itemImage: dic["Image"] as! String, active: dic["Active"] as! Int)
                self.allItemInfo.append(itemDetail1)
                print("_______________")
                print(dic)
                if  self.numberCount == number {
                    self.numberCount = 0
                    Storyboard.hideProgressHUD()
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    uiView.performSegue(withIdentifier: "sugue", sender: self)
                }
            }
        }, withCancel: nil)
    }
    func fetchAllItem(number: Int, completion: @escaping (Bool) -> ())  {
        Database.database().reference().child("ItemDetail").observe(.childAdded, with: { (snapShot) in
            if  let dic = snapShot.value as? [String: Any] {
                self.numberCount = self.numberCount + 1
                let itemDetail1 = ItemInfo(id: dic["ItemId"] as! String, itemDetail: dic["Detail"] as! String, itemPrice: dic["Price"] as! String, itemWeight: dic["Weight"] as! String, itemType: dic["Type"] as! String, itemImage: dic["Image"] as! String, active: dic["Active"] as! Int)
                self.allItemInfo.append(itemDetail1)
                print("_______________")
                print(dic)
                if  self.numberCount == number {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }, withCancel: nil)
    
    }
    func fetchAllItem(completion: @escaping (Bool) -> ())  {
        Database.database().reference().child("ItemDetail").observe(.childAdded, with: { (snapShot) in
            if  let dic = snapShot.value as? [String: Any] {
                let itemDetail1 = ItemInfo(id: dic["ItemId"] as! String, itemDetail: dic["Detail"] as! String, itemPrice: dic["Price"] as! String, itemWeight: dic["Weight"] as! String, itemType: dic["Type"] as! String, itemImage: dic["Image"] as! String, active: dic["Active"] as! Int)
                self.allItemInfo.append(itemDetail1)
                print("_______________")
                print(dic)
                    completion(true)
            }
        }, withCancel: nil)
        
    }

}
