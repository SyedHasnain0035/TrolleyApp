//
//  HomeViewController.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 02/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    // OutLets
    @IBOutlet weak var popUpViewCountLabel: UILabel!
    @IBOutlet weak var popUpHideView2: UIView!
    @IBOutlet weak var popUpHideView: UIView!
    @IBOutlet weak var popUpViewImage: UIImageView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var trollyButton: UIButton!
    @IBOutlet weak var homeTotalPrice: UILabel!
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var vegetableView: UIView!
    @IBOutlet weak var fruitView: UIView!
    @IBOutlet weak var allItemView: UIView!
    @IBOutlet weak var vegetableButton: UIButton!
    @IBOutlet weak var fruitButton: UIButton!
    @IBOutlet weak var allItemButton: UIButton!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var popUpCenterGreenView: UIView!
    @IBOutlet weak var popUpViewPriceLabel: UILabel!
    @IBOutlet weak var popUpViewDetailLabel: UILabel!
    @IBOutlet weak var popUpViewWeightLabel: UILabel!
    
    // Declar Variable
    var selectedItems = [ItemInfo]()
    var allItem = true
    var popUpCount = 0
    // data base
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        // Data base refrence
        ref = Database.database().reference()
        checkIfUserIsLogedIn()
        myCollectionView.reloadData()
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        mySearchBar.resignFirstResponder()
        myCollectionView.reloadData()
        self.homeTotalPrice.text = "\(Trolley.shared.price)"
        checkIfUserIsLogedIn()
    }
    override func viewWillDisappear(_ animated: Bool) {
        mySearchBar.resignFirstResponder()
    }
    
    ///////////////////////////////////////
    // User Define Functions
    func checkIfUserIsLogedIn()  {
        // check for auth user
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handelLogout), with: nil, afterDelay: 0)
        } else {
            let uId = Auth.auth().currentUser?.uid
            self.setValueToItem()
            Database.database().reference().child("User").child(uId!).observeSingleEvent(of: .value, with: { (snapShot) in
            }, withCancel: nil)
        }
    }
    func setValueToItem() {
        self.selectedItems = Trolley.shared.allItemInfo
        myCollectionView.reloadData()
    }
    func handelLogout()  {
        do {
            try Auth.auth().signOut()
            Trolley.shared.deleteAll()
        } catch let logoutError {
            print(logoutError)
        }
        AlertView.showLoginAlert(self)
    }
    func Logout()  {
        do {
            try Auth.auth().signOut()
            Trolley.shared.deleteAll()
        } catch let logoutError {
            print(logoutError)
        }
       
    }
    ///////////////////////////////////////////////////////////////
    // Collection View Delegates
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        popUpView.layer.borderWidth = 4
        popUpView.layer.borderColor = UIColor.gray.cgColor
        popUpCenterGreenView.layer.cornerRadius = 1
        self.popUpView.alpha = 8.5
        popUpCount = indexPath.row
        if selectedItems[indexPath.row].itemCount == 0 {
            popHideZeroAlpha()
        } else {
            popHideWithAlphaOne()
            popUpViewCountLabel.text = "\(selectedItems[indexPath.row].itemCount!)"
        }
        collectionViewSetting(item: selectedItems[indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return selectedItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            self.myCollectionView.register(UINib(nibName: "AllItemsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "allItemCollection")
            let cell : AllItemsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allItemCollection", for: indexPath) as! AllItemsCollectionViewCell
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.sd_setImage(with: URL(string: selectedItems[indexPath.row].itemImage))
            cell.allPriceLabel.text =  "\(selectedItems[indexPath.row].itemPrice!) AED"
            cell.allDetailLabel.text = selectedItems[indexPath.row].itemDetail
            cell.allQuantityLabel.text = "per \(selectedItems[indexPath.row].itemWeight!)"
            cell.layer.cornerRadius = 15
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.allPriceLabel.layer.borderWidth = 1
            cell.allPriceLabel.layer.cornerRadius = 4
            cell.allPriceLabel.layer.borderColor = UIColor.gray.cgColor
            cell.addItem.tag = indexPath.row
            cell.hideViewAddItemButton.tag = indexPath.row
            if selectedItems[indexPath.row].itemCount == 0 {
                cell.hideView.alpha = 0
            } else {
                cell.hideView.alpha = 1
                cell.allCountLabel.text = "\( self.selectedItems[indexPath.row].itemCount!)"
            }
            cell.watchForClickHandler(completion: {index in
                if index == 0 {
                    cell.hideView.alpha = 1
                    Trolley.shared.addItemToTrolley(item: self.selectedItems[indexPath.row])
                    cell.allCountLabel.text = "\( self.selectedItems[indexPath.row].itemCount!)"
                }else {
                    Trolley.shared.removeItemToTrolley(trolleyItem: self.selectedItems[indexPath.row])
                    self.selectedItems[indexPath.row].itemCount =  self.selectedItems[indexPath.row].itemCount - 1
                    if  self.selectedItems[indexPath.row].itemCount < 1 {
                        cell.hideView.alpha = 0
                    } else {
                        cell.allCountLabel.text = "\( self.selectedItems[indexPath.row].itemCount!)"
                    }
                    if Trolley.shared.price < 0 {
                        Trolley.shared.price = 0.0
                    }
                }
                self.homeTotalPrice.text = "\(Trolley.shared.price)"
            })
            return cell
        }
    // Search Bar Fuctions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "SearchProductViewController", sender: self)
        mySearchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        performSegue(withIdentifier: "SearchProductViewController", sender: self)
        mySearchBar.resignFirstResponder()
        return true
    }
    
    func popHideZeroAlpha() {
        popUpHideView.alpha = 0
        popUpHideView2.alpha = 0
        
    }
    func popHideWithAlphaOne() {
        popUpHideView.alpha = 1
        popUpHideView2.alpha = 1
        
    }
    // Outlet Function
    @IBAction func didTapPopupViewLeftArrow(_ sender: UIButton) {
            if popUpCount > 0 && popUpCount < selectedItems.count{
                popUpCount = popUpCount - 1
                if selectedItems[popUpCount].itemCount == 0 {
                    popHideZeroAlpha()
                } else {
                    popHideWithAlphaOne()
                    popUpViewCountLabel.text = "\(selectedItems[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (selectedItems[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(selectedItems[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = selectedItems[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(selectedItems[popUpCount].itemWeight!)"
            } else {
                popUpCount = selectedItems.count - 1
                if selectedItems[popUpCount].itemCount == 0 {
                    popHideZeroAlpha()
                } else {
                    popHideWithAlphaOne()
                    popUpViewCountLabel.text = "\(selectedItems[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//fruitInfo[popUpCount].itemImage
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (selectedItems[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(selectedItems[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = selectedItems[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(selectedItems[popUpCount].itemWeight!)"
            }
        }
    @IBAction func didTapPopUpViewRightArrow(_ sender: UIButton) {
            if popUpCount < selectedItems.count - 1 && popUpCount >= 0 {
                popUpCount = popUpCount + 1
                if selectedItems[popUpCount].itemCount == 0 {
                    popHideZeroAlpha()
                } else {
                    popHideWithAlphaOne()
                    popUpViewCountLabel.text = "\(selectedItems[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//fruitInfo[popUpCount].itemImage
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (selectedItems[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(selectedItems[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = selectedItems[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(selectedItems[popUpCount].itemWeight!)"
            } else {
                popUpCount = 0
                if selectedItems[popUpCount].itemCount == 0 {
                    popHideZeroAlpha()
                } else {
                    popHideWithAlphaOne()
                    popUpViewCountLabel.text = "\(selectedItems[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//fruitInfo[popUpCount].itemImage
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (selectedItems[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(selectedItems[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = selectedItems[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(selectedItems[popUpCount].itemWeight!)"
            }
        }
    @IBAction func didTapPopUpViewAddButton(_ sender: Any) {
        self.popUpHideView.alpha = 1
        self.popUpHideView2.alpha = 1
        popUpItemDisplay(itemType: selectedItems)
    }
    
    @IBAction func didTapPopUpCrossButton(_ sender: UIButton) {
        self.popUpView.alpha = 0
        myCollectionView.reloadData()
    }
    @IBAction func allItemSelected(_ sender: UIButton) {
        buttonEffectOnUI("all")
        selectedItems = Trolley.shared.allItemInfo
    }
    @IBAction func fruitSelected(_ sender: UIButton) {
        buttonEffectOnUI("fruit")
        selectedItems = Trolley.shared.getFruits()
    }
    @IBAction func vegetableSelected(_ sender: UIButton) {
        buttonEffectOnUI("veg")
        selectedItems = Trolley.shared.getVegitables()
    }
    @IBAction func didTapTrolleyButton(_ sender: UIButton) {
        let apptabbarvc = self.tabBarController as? AppTabbarControllerView
        apptabbarvc?.previousIndex = apptabbarvc?.selectedIndex
        self.tabBarController?.selectedIndex = 4
    }
    @IBAction func sideMenuButtonClicked(_ sender: UIButton) {
        self.Logout()
        self.tabBarController?.selectedIndex = 0
    }
    func  popUpItemDisplay(itemType: [ItemInfo])  {
        Trolley.shared.addItemToTrolley(item: itemType[popUpCount])
        popUpViewCountLabel.text = "\(itemType[popUpCount].itemCount!)"
        homeTotalPrice.text = "\(Trolley.shared.price)"
    }
    // button selection function
    func buttonEffectOnUI(_ type: String) {
        if type == "veg" {
            allItemButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            fruitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            vegetableButton.setTitleColor(UIColor.green, for: UIControlState.normal)
            allItemView.backgroundColor = UIColor.white
            fruitView.backgroundColor = UIColor.white
            vegetableView.backgroundColor = UIColor.green
            myCollectionView.reloadData()
        } else if type == "fruit" {
            allItemButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            fruitButton.setTitleColor(UIColor.green, for: UIControlState.normal)
            vegetableButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            allItemView.backgroundColor = UIColor.white
            fruitView.backgroundColor = UIColor.green
            vegetableView.backgroundColor = UIColor.white
            myCollectionView.reloadData()
        } else {
            allItemButton.setTitleColor(UIColor.green, for: UIControlState.normal)
            fruitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            vegetableButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            allItemView.backgroundColor = UIColor.green
            fruitView.backgroundColor = UIColor.white
            vegetableView.backgroundColor = UIColor.white
            myCollectionView.reloadData()
        }
        
    }
    
    // collection view POpUp SetUp
    func collectionViewSetting(item: ItemInfo)   {
        popUpViewImage.image = #imageLiteral(resourceName: "loading")//fruitInfo[indexPath.row].itemImage
        let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
        imageView.sd_setImage(with: URL(string: (item.itemImage)!))
        popUpViewPriceLabel.text = "\(item.itemPrice!) AED"
        popUpViewDetailLabel.text = item.itemDetail
        popUpViewWeightLabel.text = "per \(item.itemWeight!)"
        
    }
}



// comments

/*
 var clickHandler: ((Int)->Void)?
 cell.addItem.addTarget(self, action: #selector(self.didSelectAddItemButton(button:)), for: .touchUpInside)
 cell.hideViewAddItemButton.addTarget(self, action: #selector(self.didSelectAddItemButton(button:)), for: .touchUpInside)
 cell.subtractItemButton.addTarget(self, action: #selector(self.didSelectReduceItemButton(button:)), for: .touchUpInside)
 cell.addItem.addTarget(self, action: #selector(self.didSelectAddItemButton(button:)), for: .touchUpInside)
 cell.hideViewAddItemButton.addTarget(self, action: #selector(self.didSelectAddItemButton(button:)), for: .touchUpInside)
 cell.addItem.addTarget(self, action: #selector(self.didSelectAddItemButton(button:)), for: .touchUpInside)
 cell.hideViewAddItemButton.addTarget(self, action: #selector(self.didSelectAddItemButton(button:)), for: .touchUpInside)
 /*func watchForClickHandler(completion: @escaping (Int)->Void) {
 self.clickHandler = completion
 }
 func didSelectAddItemButton(button: UIButton) {
 let tag = button.tag
 guard let completion = self.clickHandler else {return}
 completion(0)
 }
 func didSelectReduceItemButton(button: UIButton) {
 guard let completion = self.clickHandler else {return}
 completion(1)
 }*/
 */

/* if let itemImageUrl = allItemInfo[indexPath.row].itemImage{
 let url = NSURL(string: itemImageUrl)
 URLSession.shared.dataTask(with: url as! URL, completionHandler: { (data, reponse, error) in
 if error != nil {
 return
 }
 DispatchQueue.main.async {
 cell.allItemImage.image = UIImage(data: data!)
 }
 }).resume()
 
 }*/
// ccccc111111
/*    popUpViewImage.image = #imageLiteral(resourceName: "loading")//fruitInfo[indexPath.row].itemImage
 let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
 imageView.sd_setImage(with: URL(string: (fruitInfo[indexPath.row].itemImage)!))
 popUpViewPriceLabel.text = "\(fruitInfo[indexPath.row].itemPrice!) AED"
 popUpViewDetailLabel.text = fruitInfo[indexPath.row].itemDetail
 popUpViewWeightLabel.text = "per \(fruitInfo[indexPath.row].itemWeight!)"*/
// ccccc222222
/*let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
 imageView.sd_setImage(with: URL(string: (vegetableInfo[indexPath.row].itemImage)!))
 popUpViewPriceLabel.text = "\(vegetableInfo[indexPath.row].itemPrice!) AED"
 popUpViewDetailLabel.text = vegetableInfo[indexPath.row].itemDetail
 popUpViewWeightLabel.text = "per \(allItemInfo[indexPath.row].itemWeight!)"*/
/// cccccc333333

/*popUpViewImage.image = #imageLiteral(resourceName: "loading")
 let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
 imageView.sd_setImage(with: URL(string: (allItemInfo[indexPath.row].itemImage)!))
 popUpViewPriceLabel.text = "\(allItemInfo[indexPath.row].itemPrice!) AED"
 popUpViewDetailLabel.text = allItemInfo[indexPath.row].itemDetail
 popUpViewWeightLabel.text = "per \(allItemInfo[indexPath.row].itemWeight!)"*/
