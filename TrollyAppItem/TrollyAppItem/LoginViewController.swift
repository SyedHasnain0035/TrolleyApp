//
//  LoginViewController.swift
//  TrollyAppItem
//
//  Created by Rashdan Natiq on 16/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit
import FirebaseAuth
import  Firebase
import FirebaseDatabase
import MBProgressHUD

class LoginViewController: UIViewController {

    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var segmentButton: UISegmentedControl!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    var ref: DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = "test@test.com"
        passwordTextField.text = "123321"
        ref = Database.database().reference()
    }
    @IBAction func didTapSegmentedControl(_ sender: UISegmentedControl) {
        if segmentButton.selectedSegmentIndex == 0 {
            let image1 = UIImage(named: "login") as UIImage!
            self.saveButton.setImage(image1, for: .normal)
        } else {
            let image1 = UIImage(named: "singUp") as UIImage!
            self.saveButton.setImage(image1, for: .normal)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            if segmentButton.selectedSegmentIndex == 0 {   // login
                Storyboard.showProgressHUD()
                Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                    if error == nil {
                        Storyboard.showProgressHUD()
                        self.findNumberOfItemInDataBase()
                    } else {
                        //Tells the user that there is an error and then gets firebase to tell them the error
                        Storyboard.hideProgressHUD()
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            } else { // singup
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if error == nil {
                        print("You have successfully signed up")
                        self.performSegue(withIdentifier: "sugue", sender: self)
                        let userID: String = (user?.uid)!
                        let userEmail: String = self.emailTextField.text!
                        let userPassword: String = self.passwordTextField.text!
                        self.ref?.child("AddedUser").child(userID).setValue(["Name ": userEmail, "Password": userPassword])
                    } else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    func findNumberOfItemInDataBase() {
        Database.database().reference().child("ItemDetail").observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { (datta, ggg) in
            let numberOfItem = datta.childrenCount
            self.fetchItems(number: Int(numberOfItem))
        }, withCancel: nil)
    }
    var numberCount = 0
    func fetchItems(number: Int)  {
        Database.database().reference().child("ItemDetail").observe(.childAdded, with: { (snapShot) in
            if  let dic = snapShot.value as? [String: Any] {
                 self.numberCount = self.numberCount + 1
                let itemDetail1 = ItemInfo(id: dic["ItemId"] as! String, itemDetail: dic["Detail"] as! String, itemPrice: dic["Price"] as! String, itemWeight: dic["Weight"] as! String, itemType: dic["Type"] as! String, itemImage: dic["Image"] as! String, active: dic["Active"] as! Int)
                ViewController.items.append(itemDetail1)
                print("_______________")
                print(dic)
                if  self.numberCount == number {
                    Storyboard.hideProgressHUD()
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    self.performSegue(withIdentifier: "sugue", sender: self)
                }
            }
        }, withCancel: nil)
    }


}
