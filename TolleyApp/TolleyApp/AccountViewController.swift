//
//  AccountViewController.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 02/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
class AccountViewController: UIViewController {
    var ref: DatabaseReference?
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordTextField.text = "123654"
        self.emailTextField.text = "mali@test.com"
        ref = Database.database().reference()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapCallButton(_ sender: UIButton) {
    }
    @IBAction func didTapEmailUsButton(_ sender: UIButton) {
    }
    @IBAction func didTapForgetPassword(_ sender: UIButton) {
    }
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            //self.tabBarController?.selectedIndex = 1
            
        } else {
            Storyboard.showProgressHUD()
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
                    
                    self.findNumberOfItemInDataBase() // find number of elements in data base
                } else {
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    Storyboard.hideProgressHUD()
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func didTapSingUpButton(_ sender: UIButton) {
    }
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func findNumberOfItemInDataBase() {
        Database.database().reference().child("ItemDetail").observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { (datta, ggg) in
            let numberOfItem = datta.childrenCount
            self.fetchItems(number: Int(numberOfItem))
        }, withCancel: nil)
    }
    var numberCount = 0
    func fetchItems(number: Int)  {   // fetching data from data base
        Database.database().reference().child("ItemDetail").observe(.childAdded, with: { (snapShot) in
            if  let dic = snapShot.value as? [String: Any] {
                self.numberCount = self.numberCount + 1
                let count = 0
                let itemSave = ItemInfo(itemId: dic["ItemId"] as! String,itemDetail: dic["Detail"] as! String, itemPrice: dic["Price"] as! String, itemWeight: dic["Weight"] as! String, itemType: dic["Type"] as! String, itemImage: dic["Image"] as! String, itemActive: dic["Active"] as! Int, itemCount: count )
                if itemSave.itemActive == 1 {
                    Trolley.shared.allItemInfo.append(itemSave)
                }
                if  self.numberCount == number {
                    self.numberCount = 0
                    self.goToNextVC()
                }
            }
        }, withCancel: nil)
    }
    func goToNextVC() {
        print("You have successfully logged in")
        Storyboard.hideProgressHUD()
       self.tabBarController?.selectedIndex = 1
    }
}
