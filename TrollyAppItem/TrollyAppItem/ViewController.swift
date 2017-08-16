//
//  ViewController.swift
//  TrollyAppItem
//
//  Created by Rashdan Natiq on 15/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit
import os.log
import FirebaseAuth
import Firebase
class ViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    var items = [ItemInfo]()
    var handle: DatabaseHandle?
    var refrence: DatabaseReference?
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLogedIn()
        myTableView.delegate = self
        myTableView.dataSource = self
        fetchItems()
    
    }
    func checkIfUserIsLogedIn()  {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handelLogout), with: nil, afterDelay: 0)
        } else {
           let uId = Auth.auth().currentUser?.uid
            Database.database().reference().child("AddedUser").child(uId!).observeSingleEvent(of: .value, with: { (snapShot) in
                if  let dic = snapShot.value as? [String: Any] {
                    self.navigationItem.title = dic["Name"] as? String
                }
                
            }, withCancel: nil)
            
        }
    }
    func fetchItems()  {
        Database.database().reference().child("ItemInfo").observe(.childAdded, with: { (snapShot) in
            if  let dic = snapShot.value as? [String: Any] {
                let itemDetail1 = ItemInfo(itemDetail: dic["Detail"] as! String, itemPrice: dic["Price"] as! String, itemWeight: dic["Weight"] as! String, itemType: dic["Type"] as! String, itemImage: dic["Image"] as! String, active: dic["Active"] as! Int)
                self.items.append(itemDetail1)
                self.myTableView.reloadData()
                print("_______________")
                print(dic)
            }
        }, withCancel: nil)
    }
    func handelLogout()  {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let logIn = LoginViewController()
        present(logIn, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        
        cell.itemDetailLabel.text = "Detail:" + items[indexPath.row].itemDetail
        cell.itemPrice.text = "Price: " + items[indexPath.row].itemPrice
        cell.itemImage.image = #imageLiteral(resourceName: "lunch")
        cell.itemWeight.text = "Weight: " + items[indexPath.row].itemWeight
        cell.itemType.text = "Type: " +  items[indexPath.row].itemType
        if  items[indexPath.row].active == 1 {
           cell.itemActiveImage.image = #imageLiteral(resourceName: "checked")
        } else {
            cell.itemActiveImage.image = #imageLiteral(resourceName: "blank_box")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
   
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "sugueLogout":
            try! Auth.auth().signOut()
            guard segue.destination is LoginViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
        case "AddItem":
            os_log("Adding a new Item.", log: OSLog.default, type: .debug)
            
        case "showDetail":
            guard let itemDetailViewController = segue.destination as? ItemDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
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
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ItemDetailViewController, let item = sourceViewController.item {
            
            if let selectedIndexPath = myTableView.indexPathForSelectedRow {
                // Update an existing meal.
                items[selectedIndexPath.row] = item
                myTableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: items.count, section: 0)
                
                items.append(item)
                myTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
           
        }
    }
    
}

