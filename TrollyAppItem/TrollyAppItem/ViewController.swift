//
//  ViewController.swift
//  TrollyAppItem
//
//  Created by Rashdan Natiq on 15/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
class ViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    var items = [ItemInfo]()
    var handle: DatabaseHandle?
    var refrence: DatabaseReference?
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        putValueInItem()
        checkIfUserIsLogedIn()
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        putValueInItem()
    }
    /////////////Table View Functions //////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        cell.backGroundView.layer.cornerRadius = 12
        cell.itemDetailLabel.text = "Detail:" + items[indexPath.row].itemDetail
        cell.itemPrice.text = "Price: " + items[indexPath.row].itemPrice
        cell.itemImage.image = #imageLiteral(resourceName: "loading")
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.sd_setImage(with: URL(string: items[indexPath.row].itemImage))
        cell.itemWeight.text = "Weight: " + items[indexPath.row].itemWeight
        cell.itemType.text = "Type: " +  items[indexPath.row].itemType
        if  items[indexPath.row].active == 1 {
            cell.itemActiveImage.image = #imageLiteral(resourceName: "checked")
        } else {
            cell.itemActiveImage.image = #imageLiteral(resourceName: "blank_box")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source and data base
            let id = items[indexPath.row].id
            refrence = Database.database().reference().child("ItemDetail").child(id!)
            refrence?.removeValue()
            items.remove(at: indexPath.row)
            AppAllData.shared.allItemInfo  = []
            AppAllData.shared.allItemInfo = items
            tableView.deleteRows(at: [indexPath], with: .fade)
            myTableView.reloadData()
        }
    }
    /////////////////////Prepare for segue//////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "sugueLogout":
            try! Auth.auth().signOut()
            items = []
            AppAllData.shared.deleteAll()
            guard segue.destination is LoginViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
        case "orderList":
            guard segue.destination is OrderListViewController else {
                fatalError("Error: \(segue.destination)")
            }
        case "AddItem":
            guard segue.destination is ItemDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
        case "showDetail":
            guard let itemDetailViewController = segue.destination as? ItemDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            itemDetailViewController.edit = true
            guard let selectedMealCell = sender as? ItemTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = myTableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedItem = items[indexPath.row]
            itemDetailViewController.item = selectedItem
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    @IBAction func didTapOrderList(_ sender: UIBarButtonItem) {
    }
    /////////////////////////////////////
    ///// User Define Functions ////////
    func checkIfUserIsLogedIn()  {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handelLogout), with: nil, afterDelay: 0)
        } else {
            let uId = Auth.auth().currentUser?.uid
            AppAllData.shared.fetchAllUserInfo()
            Database.database().reference().child("AddedUser").child(uId!).observeSingleEvent(of: .value, with: { (snapShot) in
                if  let dic = snapShot.value as? [String: Any] {
                    self.title = dic["Name"] as? String
                }
            }, withCancel: nil)
        }
    }
    func handelLogout()  {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        performSegue(withIdentifier: "sugueLogout", sender: self)
    }
    func putValueInItem()  {
        self.items = []
        self.items = AppAllData.shared.allItemInfo
        myTableView.reloadData()
    }
}

