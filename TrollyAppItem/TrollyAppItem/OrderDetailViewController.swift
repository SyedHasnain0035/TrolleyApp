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
    var totalPrice = 0.0
    var refrenceItemStore: DatabaseReference?
    @IBOutlet weak var myTabelView: UITableView!
    @IBOutlet weak var orderTotalPrice: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(orderDetail.userName)'s Order"
        setValueToOrder(id: orderDetail.userId)
        myTabelView.delegate = self
        myTabelView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCompleteButton(_ sender: Any) {
        for or in orders {
            let uid = or.orderId
            let ref = Database.database().reference().child("OrderedItemDetail").child(uid)
            let values = ["Delever": 1]
            ref.updateChildValues(values)
        }
      
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
        let currentItem = AppAllData.shared.getItemDetail(id: orders[indexPath.row].itemId)
        let currentItemPrice = Double(currentItem[0].itemPrice!)
        totalPrice = totalPrice + (currentItemPrice! * (Double(orders[indexPath.row].itemCount)))
        cell.orderImage.image = #imageLiteral(resourceName: "loading")
        self.orderTotalPrice.text = "Total Price: \(totalPrice) AED"
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
    func setValueToOrder(id: String) {
        orders = AppAllData.shared.getOrderItemDetail(id: id)
        myTabelView.reloadData()
    }

}
