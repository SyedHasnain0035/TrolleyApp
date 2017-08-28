//
//  OrderDetailViewController.swift
//  TrollyAppItem
//
//  Created by Rashdan Natiq on 28/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
    var orderDetail: OrderItem!
    
    @IBOutlet weak var orderTotalPrice: UILabel!
    @IBOutlet weak var orderWeight: UILabel!
    
    @IBOutlet weak var orderDeleveredLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderDetailLabel: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(orderDetail?.userName)'s Order"
        // Do any additional setup after loading the view.
        showOrderDetail()
    }
    func showOrderDetail()  {
        self.orderDetailLabel.text = "Order Detail: \(orderDetail.detail)"
        self.orderWeight.text = "Order Weight: \(orderDetail.itemCount)"
        self.orderTotalPrice.text = "Order Price: \(orderDetail.itemCount)"
        self.orderDateLabel.text = "Order Date: \(orderDetail.date)"
        self.orderDeleveredLabel.text = "Order Delevered: \(0)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCompleteButton(_ sender: Any) {
    }

    @IBAction func didTapCancelButton(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
