//
//  HistoryViewController.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 02/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class OrderItem {
    var img = ""
    var userId = ""
    var userName = ""
    var itemId = ""
    var itemCount = 0
    var detail = ""
    var date = ""
    var orderId = ""
    var delevered = 0
    var orderItemPrice = ""
    init(img: String, userId: String, userName: String, itemId: String,itemCount: Int, detail: String, date: String, orderId: String, delevered: Int, orderItemPrice: String ) {
        self.img = img
        self.userId = userId
        self.userName = userName
        self.itemId = itemId
        self.itemCount = itemCount
        self.detail = detail
        self.date = date
        self.orderId = orderId
        self.delevered = delevered
        self.orderItemPrice = orderItemPrice
    }
}


class HistoryViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTableView: UITableView!
    var numberOfItem = 0
    var userId = ""
    var orders = [OrderItem]()
    var refrenceItemStore: DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
         checkIfUserIsLogedIn()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func checkIfUserIsLogedIn()  {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handelLogout), with: nil, afterDelay: 0)
        } else {
            let uId = Auth.auth().currentUser?.uid
            Database.database().reference().child("User").child(uId!).observeSingleEvent(of: .value, with: { (snapShot) in
                if  let dic = snapShot.value as? [String: Any] {
                    self.userId = dic["UserId"] as! String
                    self.fetchItems(id: self.userId)
                }
            }, withCancel: nil)
        }
    }
    @objc func handelLogout()  {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
       AlertView.showLoginAlert(self)
    }
    /// Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HistroyTableViewCell", for: indexPath) as! HistroyTableViewCell
       
        cell.detailLabel.text = "Detail: \(orders[indexPath.row].detail)"
        let totalPrice = Double(orders[indexPath.row].orderItemPrice)! * Double(orders[indexPath.row].itemCount)
        cell.priceLabel.text = "Price: \(totalPrice)"
        cell.dateLabel.text = "Date: \(orders[indexPath.row].date)"
        if orders[indexPath.row].delevered == 1 {
            cell.recivedLabel.text = "Delevered:  Yes"
        } else {
           cell.recivedLabel.text = "Delevered:  No"
        }
        
        cell.itemImage.image = #imageLiteral(resourceName: "loading")
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.sd_setImage(with: URL(string: orders[indexPath.row].img))
 return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            myTableView.deleteRows(at: [indexPath], with: .fade)
            myTableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    func findNumberOfItemInDataBase() {
        Database.database().reference().child("OrderedItemDetail").observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { (datta, ggg) in
            self.numberOfItem = Int(datta.childrenCount)
         //   self.fetchItems(number: Int(self.numberOfItem))
            
        }, withCancel: nil)
        
    }
    
    func fetchItems(id: String )  {
        
        Database.database().reference().child("OrderedItemDetail").observe(.childAdded, with: { (snapShot) in
            if  let dic = snapShot.value as? [String: Any] {
                print(snapShot)
                let detailOrder = OrderItem(img: dic["imageUrl"] as! String, userId: dic["UserFKey"] as! String, userName: dic["userName"] as! String, itemId: dic["ItemFKey"] as! String, itemCount: dic["itemQuantity"] as! Int, detail: dic["Detail"] as! String,  date: dic["Date"] as! String, orderId: dic["OrderId"] as! String, delevered: dic["Delever"] as! Int, orderItemPrice: dic["Price"] as! String)
                if  detailOrder.userId == id {
                    self.orders.append(detailOrder)
                    self.myTableView.reloadData()
                }
                
            }
        }, withCancel: nil)
    }
  
   
}
