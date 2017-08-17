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
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPriceLabel.text = "Total: \(Trolley.shared.price) AED"
        totalPriceMenuBar.text = "\(Trolley.shared.price)"
        checkIfUserIsLogedIn()
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
            }, withCancel: nil)
        }
    }
    func handelLogout()  {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let logout = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        self.navigationController?.pushViewController(logout, animated: true)
    }
    @IBAction func didTapBackButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func tollyButtonPressed(_ sender: UIButton) {
    }
    @IBAction func didTapCheckOutButton(_ sender: UIButton) {
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
}
