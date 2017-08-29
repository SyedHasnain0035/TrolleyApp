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
        myTableView.reloadData()
    }
    func putValueInItem()  {
        self.items = AppAllData.shared.allItemInfo
        myTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
        checkIfUserIsLogedIn()
        putValueInItem()
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: indexPath.row)
          /*  let itemStore = ["ItemId": "", "Detail": "", "Image": "", "Price": "", "Weight": "", "Type": "", "Active": "" ] as [String : Any]
            let ref = Database.database().reference().child("ItemDetail").child((items[indexPath.row].id)!)
            ref.updateChildValues(itemStore)
            */
            tableView.deleteRows(at: [indexPath], with: .fade)
            myTableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
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
            os_log("Adding a new Item.", log: OSLog.default, type: .debug)
            
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
            fetchAllUserInfo()
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
        //  let logIn = LoginViewController()
        performSegue(withIdentifier: "sugueLogout", sender: self)
    }
    func fetchAllUserInfo()  {
        Database.database().reference().child("User").observe(.childAdded, with: { (snapShot) in
            if  let dic = snapShot.value as? [String: Any] {
                let userData = UserDetail(userId: "UserId" , userTitle: "Title", userFirstName: "FirstName", userLastName: "LastName", userCountryCode: "CountryCode", userMobileCode: "MobileCode", userMobileNumber: "MobileNumber", userEmail: "Email", userBirthDay: "Birthdate", userGender: "Gender", userNationality: "Nationality", userReligon: "Religion", userAreaAddress: "Area", userApparment: "Apparment", userBuildingAddress: "BuildingNo", userSpecialInstruction: "SpecialInstruction")
                AppAllData.shared.userDetailInfo.append(userData)
                print("_______________")
                print(dic)
            }
        }, withCancel: nil)
    }
}

