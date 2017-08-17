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
        self.passwordTextField.text = "123456"
        self.emailTextField.text = "ali@test.com"
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
            
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully logged in")
                    self.fetchItems()
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(secondViewController, animated: true)
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
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
    func fetchItems()  {
        Database.database().reference().child("ItemInfo").observe(.childAdded, with: { (snapShot) in
            if  let dic = snapShot.value as? [String: Any] {
                let uId = Auth.auth().currentUser?.uid
                let count = 0
                let itemSave = ItemInfo(itemId: uId!,itemDetail: dic["Detail"] as! String, itemPrice: dic["Price"] as! String, itemWeight: dic["Weight"] as! String, itemType: dic["Type"] as! String, itemImage: dic["Image"] as! String, itemActive: dic["Active"] as! Int, itemCount: count )
                if itemSave.itemActive == 1 {
                    if  itemSave.itemType == "Fruit" {
                        Trolley.shared.fruitItem.append(itemSave)
                    } else {
                        Trolley.shared.vegetableItem.append(itemSave)
                    }
                    Trolley.shared.allItemInfo.append(itemSave)
                }
            }
            
        }, withCancel: nil)
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
