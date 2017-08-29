//
//  CheckOutViewController.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 02/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
class CheckOutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var totalPriceMenuBar: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var myTabelView: UITableView!
    @IBOutlet weak var pageTitleLabel: UILabel!
    var totalPrice = 0
    var userName = ""
    var userFKey = ""
    var refrenceItemStore: DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPriceLabel.text = "Total: \(Trolley.shared.price) AED"
        totalPriceMenuBar.text = "\(Trolley.shared.price)"
        checkIfUserIsLogedIn()
        refrenceItemStore = Database.database().reference().child("OrderedItemDetail")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        myTabelView.reloadData()
        self.totalPriceLabel.text = "Total: \(Trolley.shared.price) AED"
        totalPriceMenuBar.text = "\(Trolley.shared.price)"
        checkIfUserIsLogedIn()
    }
    override func viewWillDisappear(_ animated: Bool) {
        myTabelView.reloadData()
    }
    // check out loged in user
    func checkIfUserIsLogedIn()  {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handelLogout), with: nil, afterDelay: 0)
        } else {
            let uId = Auth.auth().currentUser?.uid
            Database.database().reference().child("User").child(uId!).observeSingleEvent(of: .value, with: { (snapShot) in
                if  let dic = snapShot.value as? [String: Any] {
                    self.userName = "\(dic["FirstName"]!) \(dic["LastName"]!)"
                    self.userFKey = dic["UserId"] as! String
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
        AlertView.showLoginAlert(self)
    }
    @IBAction func didTapBackButton(_ sender: UIButton) {
        //_ = navigationController?.popViewController(animated: true)
        let appBar = self.tabBarController as? AppTabbarControllerView
        appBar?.selectedIndex = (appBar?.previousIndex)!
        appBar?.previousIndex = nil
    }
    @IBAction func tollyButtonPressed(_ sender: UIButton) {
    }
    @IBAction func didTapCheckOutButton(_ sender: UIButton) {
        alertShow()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Trolley.shared.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SearchItemTableViewCell", owner: self, options: nil)?.first as! SearchItemTableViewCell
        
        cell.addSubView.layer.cornerRadius = 7
        cell.addSubView.layer.borderWidth = 1
        cell.countLabel.layer.borderWidth = 1
        cell.backGroundView.layer.cornerRadius = 10
        cell.backGroundView.layer.borderWidth = 1
        cell.backGroundView.layer.borderColor = UIColor.gray.cgColor
        cell.detailLabel.text = Trolley.shared.items[indexPath.row].itemDetail
        cell.itemImage.image = #imageLiteral(resourceName: "loading")//Trolley.shared.items[indexPath.row].itemImage
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.sd_setImage(with: URL(string: Trolley.shared.items[indexPath.row].itemImage))
        cell.priceLabel.text = "\(Trolley.shared.items[indexPath.row].itemPrice!) AED"
        cell.weightLabel.text = Trolley.shared.items[indexPath.row].itemWeight
        cell.countLabel.text = "\(Trolley.shared.items[indexPath.row].itemCount!)"
        cell.watchForClickHandler(completion: { index in
            if index == 0 {
                Trolley.shared.items[indexPath.row].itemCount = Trolley.shared.items[indexPath.row].itemCount  + 1
                Trolley.shared.price = Trolley.shared.price + Trolley.shared.items[indexPath.row].itemPrice.toDouble()!
                cell.countLabel.text = "\(Trolley.shared.items[indexPath.row].itemCount!)"
                self.totalPriceLabel.text = "Total: \(Trolley.shared.price) AED"
                self.totalPriceMenuBar.text = "\(Trolley.shared.price)"
            } else {
                Trolley.shared.items[indexPath.row].itemCount = Trolley.shared.items[indexPath.row].itemCount  - 1
                if Trolley.shared.items[indexPath.row].itemCount < 1 {
                    Trolley.shared.items[indexPath.row].itemCount = 0
                    cell.countLabel.text = "\(Trolley.shared.items[indexPath.row].itemCount!)"
                    Trolley.shared.price = Trolley.shared.price - Trolley.shared.items[indexPath.row].itemPrice.toDouble()!
                    self.totalPriceLabel.text = "Total: \(Trolley.shared.price) AED"
                    self.totalPriceMenuBar.text = "\(Trolley.shared.price)"
                    Trolley.shared.items.remove(at: indexPath.row)
                    self.myTabelView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    cell.countLabel.text = "\(Trolley.shared.items[indexPath.row].itemCount!)"
                    cell.countLabel.text = "\(Trolley.shared.items[indexPath.row].itemCount!)"
                    Trolley.shared.price = Trolley.shared.price - Trolley.shared.items[indexPath.row].itemPrice.toDouble()!
                    self.totalPriceLabel.text = "Total: \(Trolley.shared.price) AED"
                    self.totalPriceMenuBar.text = "\(Trolley.shared.price)"
                }
            }
        })
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            Trolley.shared.items.remove(at: indexPath.row)
            myTabelView.deleteRows(at: [indexPath], with: .fade)
            myTabelView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    func currentDateSet() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let hour = dateFormatter.string(from: date)
        print(hour) // may print: 13
        return hour
    }
    func storedOrderToDataBase() {
        var detail = ""
        var noOfItem = 0
        var itemFKey = ""
        var imageUrl = ""
        var delevered = 0
        let date = currentDateSet()
        for item in Trolley.shared.items {
            detail = item.itemDetail
            noOfItem = item.itemCount
            itemFKey = item.itemId
            imageUrl = item.itemImage
            // Item Save in data base
            let keyId = (self.refrenceItemStore?.childByAutoId().key)! as String
            let itemStore = ["OrderId": keyId, "ItemFKey": itemFKey, "imageUrl": imageUrl, "Detail": detail,"userName": self.userName, "itemQuantity": noOfItem,"UserFKey": self.userFKey, "Date": date, "Delever": delevered] as [String : Any]
            self.refrenceItemStore?.child(keyId).setValue(itemStore)
        }
    }
    
    func alertShow() {
        let alert = UIAlertController(title: "Order", message: "", preferredStyle: .actionSheet)
        // First Action
        let actionOne = UIAlertAction(title: "Confrom Order", style: .default) { (action) in
            if Trolley.shared.items.count != 0 {
                self.storedOrderToDataBase()
                self.showSuccessAlert(service: "Your order is Complete")
            } else {
                self.showAlert(service: "No item Found")
            }

            }
        // Cancel Action
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // add Action
        alert.addAction(actionOne)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true , completion: nil)
    }
    func showAlert(service: String) {
        let alert = UIAlertController(title: "Error", message: " \(service)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    func showSuccessAlert(service: String) {
        let alert = UIAlertController(title: "Success", message: " \(service)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            //_ = self.navigationController?.popViewController(animated: true)
            self.tabBarController?.selectedIndex = 3
            for i in 0 ..< Trolley.shared.items.count {
                Trolley.shared.items[i].itemCount = 0
            }
            Trolley.shared.price = 0
            Trolley.shared.items = []
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }


}
