//
//  OrderDetailViewController.swift
//  TrollyAppItem
//
//  Created by Rashdan Natiq on 28/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
class OrderDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var orderDetail: OrderItem!
    var orders = [OrderItem]()
    var numberOfItem = 0
    var refrenceItemStore: DatabaseReference?
    @IBOutlet weak var myTabelView: UITableView!
    @IBOutlet weak var orderTotalPrice: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.title = "\(orderDetail.userName)'s Order"
        fetchItems(id: orderDetail.userId)
        myTabelView.delegate = self
        myTabelView.dataSource = self
        // Do any additional setup after loading the view.
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCompleteButton(_ sender: Any) {
    }

    @IBAction func didTapCancelButton(_ sender: Any) {
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell", for: indexPath) as! OrderDetailTableViewCell
        cell.detailLabel.text = "Detail: \(orders[indexPath.row].detail)"
        cell.weightLabel.text = "\(orders[indexPath.row].itemCount) Kg"
        cell.orderImage.image = #imageLiteral(resourceName: "loading")
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.sd_setImage(with: URL(string: orders[indexPath.row].img))
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            myTabelView.deleteRows(at: [indexPath], with: .fade)
            myTabelView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    func fetchItems(id: String )  {
        Database.database().reference().child("OrderedItemDetail").observe(.childAdded, with: { (snapShot) in
            if  let dic = snapShot.value as? [String: Any] {
                print(snapShot)
                let detailOrder = OrderItem(img: dic["imageUrl"] as! String, userId: dic["UserFKey"] as! String, userName: dic["userName"] as! String, itemId: dic["ItemFKey"] as! String, itemCount: dic["itemQuantity"] as! Int, detail: dic["Detail"] as! String,  date: dic["Date"] as! String, orderId: dic["OrderId"] as! String)
                if  detailOrder.userId == id {
                    self.orders.append(detailOrder)
                    self.myTabelView.reloadData()
                }
            }
        }, withCancel: nil)
    }
}
