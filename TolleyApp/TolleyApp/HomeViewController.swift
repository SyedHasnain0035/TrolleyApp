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
    
    // Declar Variables
    var fruitInfo = [ItemInfo]()
    var vegetableInfo = [ItemInfo]()
    var allItemInfo = [ItemInfo]()
    var isFruit = false
    var isVegetable = false
    var allItem = true
    var popUpCount = 0
    // data base
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
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
       // self.setValueToItem()
    }
    
    ///////////////////////////////////////
    // User Define Functions
    func checkIfUserIsLogedIn()  {
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
        self.allItemInfo = Trolley.shared.allItemInfo
        self.fruitInfo = Trolley.shared.fruitItem
        self.vegetableInfo = Trolley.shared.vegetableItem
        myCollectionView.reloadData()
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
   
    ///////////////////////////////////////////////////////////////
    // Collection View Delegates
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        popUpView.layer.borderWidth = 4
        popUpView.layer.borderColor = UIColor.gray.cgColor
        popUpCenterGreenView.layer.cornerRadius = 1
        self.popUpView.alpha = 8.5
        popUpCount = indexPath.row
        if isFruit == true {
            if fruitInfo[indexPath.row].itemCount == 0 {
                popUpHideView.alpha = 0
                popUpHideView2.alpha = 0
            } else {
                popUpHideView.alpha = 0.9
                popUpHideView2.alpha = 0.7
                popUpViewCountLabel.text = "\(fruitInfo[indexPath.row].itemCount!)"
            }
            popUpViewImage.image = #imageLiteral(resourceName: "loading")//fruitInfo[indexPath.row].itemImage
            let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
            imageView.sd_setImage(with: URL(string: (fruitInfo[indexPath.row].itemImage)!))
            popUpViewPriceLabel.text = "\(fruitInfo[indexPath.row].itemPrice!) AED"
            popUpViewDetailLabel.text = fruitInfo[indexPath.row].itemDetail
            popUpViewWeightLabel.text = "per \(fruitInfo[indexPath.row].itemWeight!)"
        } else if isVegetable == true {
            if vegetableInfo[indexPath.row].itemCount == 0 {
                popUpHideView.alpha = 0
                popUpHideView2.alpha = 0
            } else {
                popUpHideView.alpha = 0.9
                popUpHideView2.alpha = 0.7
                popUpViewCountLabel.text = "\(vegetableInfo[indexPath.row].itemCount!)"
            }
            let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
            imageView.sd_setImage(with: URL(string: (vegetableInfo[indexPath.row].itemImage)!))
            popUpViewPriceLabel.text = "\(vegetableInfo[indexPath.row].itemPrice!) AED"
            popUpViewDetailLabel.text = vegetableInfo[indexPath.row].itemDetail
            popUpViewWeightLabel.text = "per \(allItemInfo[indexPath.row].itemWeight!)"
        } else {
            if allItemInfo[indexPath.row].itemCount == 0 {
                popUpHideView.alpha = 0
                popUpHideView2.alpha = 0
            } else {
                popUpHideView.alpha = 0.9
                popUpHideView2.alpha = 0.7
                popUpViewCountLabel.text = "\(allItemInfo[indexPath.row].itemCount!)"
            }
            popUpViewImage.image = #imageLiteral(resourceName: "loading")
            let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
            imageView.sd_setImage(with: URL(string: (allItemInfo[indexPath.row].itemImage)!))
            popUpViewPriceLabel.text = "\(allItemInfo[indexPath.row].itemPrice!) AED"
            popUpViewDetailLabel.text = allItemInfo[indexPath.row].itemDetail
            popUpViewWeightLabel.text = "per \(allItemInfo[indexPath.row].itemWeight!)"
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFruit == true {
            return fruitInfo.count
        } else if isVegetable == true {
            return vegetableInfo.count
        } else {
            return allItemInfo.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isFruit == true {
            self.myCollectionView.register(UINib(nibName: "AllItemsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "allItemCollection")
            let cell : AllItemsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allItemCollection", for: indexPath) as! AllItemsCollectionViewCell
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.sd_setImage(with: URL(string: fruitInfo[indexPath.row].itemImage))
            cell.allPriceLabel.text =  "\(fruitInfo[indexPath.row].itemPrice!) AED"
            cell.allDetailLabel.text = fruitInfo[indexPath.row].itemDetail
            cell.allQuantityLabel.text = "per \(fruitInfo[indexPath.row].itemWeight!)"
            cell.layer.cornerRadius = 15
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.allPriceLabel.layer.borderWidth = 1
            cell.allPriceLabel.layer.cornerRadius = 4
            cell.allPriceLabel.layer.borderColor = UIColor.gray.cgColor
            cell.addItem.tag = indexPath.row
            cell.hideViewAddItemButton.tag = indexPath.row
            if fruitInfo[indexPath.row].itemCount == 0 {
                cell.hideView.alpha = 0
            } else {
                cell.hideView.alpha = 0.7
                cell.allCountLabel.text = "\( self.fruitInfo[indexPath.row].itemCount!)"
            }
            cell.watchForClickHandler(completion: {index in
                if index == 0 {
                    cell.hideView.alpha = 0.7
                    Trolley.shared.addItemToTrolley(item: self.fruitInfo[indexPath.row])
                    cell.allCountLabel.text = "\( self.fruitInfo[indexPath.row].itemCount!)"
                }else {
                    Trolley.shared.removeItemToTrolley(trolleyItem: self.fruitInfo[indexPath.row])
                    self.fruitInfo[indexPath.row].itemCount =  self.fruitInfo[indexPath.row].itemCount - 1
                    if  self.fruitInfo[indexPath.row].itemCount < 1 {
                        cell.hideView.alpha = 0
                    } else {
                        cell.allCountLabel.text = "\( self.fruitInfo[indexPath.row].itemCount!)"
                    }
                    if Trolley.shared.price < 0 {
                        Trolley.shared.price = 0.0
                    }
                }
                
                self.homeTotalPrice.text = "\(Trolley.shared.price)"
            })
            return cell
            
        } else if isVegetable == true {
            self.myCollectionView.register(UINib(nibName: "AllItemsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "allItemCollection")
            let cell : AllItemsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allItemCollection", for: indexPath) as! AllItemsCollectionViewCell
            // sdWeb Image
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.sd_setImage(with: URL(string: vegetableInfo[indexPath.row].itemImage))
            cell.allPriceLabel.text = "\(vegetableInfo[indexPath.row].itemPrice!) AED"
            cell.allQuantityLabel.text = vegetableInfo[indexPath.row].itemWeight
            cell.allDetailLabel.text = " per \(vegetableInfo[indexPath.row].itemDetail!)"
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.cornerRadius = 15
            cell.layer.borderWidth = 1
            cell.allPriceLabel.layer.borderWidth = 1
            cell.allPriceLabel.layer.cornerRadius = 4
            cell.allPriceLabel.layer.borderColor = UIColor.gray.cgColor
            cell.addItem.tag = indexPath.row
            cell.hideViewAddItemButton.tag = indexPath.row
            if vegetableInfo[indexPath.row].itemCount == 0 {
                cell.hideView.alpha = 0
            } else {
                cell.hideView.alpha = 0.7
                cell.allCountLabel.text = "\( self.vegetableInfo[indexPath.row].itemCount!)"
            }
            cell.watchForClickHandler(completion: {index in
                if index == 0 {
                    cell.hideView.alpha = 0.7
                    Trolley.shared.addItemToTrolley(item: self.vegetableInfo[indexPath.row])
                    cell.allCountLabel.text = "\( self.vegetableInfo[indexPath.row].itemCount!)"
                }else {
                    Trolley.shared.removeItemToTrolley(trolleyItem: self.vegetableInfo[indexPath.row])
                    self.vegetableInfo[indexPath.row].itemCount =  self.vegetableInfo[indexPath.row].itemCount - 1
                    if  self.vegetableInfo[indexPath.row].itemCount < 1 {
                        cell.hideView.alpha = 0
                    } else {
                        cell.allCountLabel.text = "\( self.vegetableInfo[indexPath.row].itemCount!)"
                    }
                    if Trolley.shared.price < 0 {
                        Trolley.shared.price = 0.0
                    }
                }
                self.homeTotalPrice.text = "\(Trolley.shared.price)"
            })
            return cell
        } else {
            self.myCollectionView.register(UINib(nibName: "AllItemsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "allItemCollection")
            let cell : AllItemsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allItemCollection", for: indexPath) as! AllItemsCollectionViewCell
            // sd web image
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.sd_setImage(with: URL(string: allItemInfo[indexPath.row].itemImage))
            cell.allDetailLabel.text = allItemInfo[indexPath.row].itemDetail
            cell.allPriceLabel.text = "\(allItemInfo[indexPath.row].itemPrice!) AED"
            cell.allQuantityLabel.text = "per \(allItemInfo[indexPath.row].itemWeight!)"
            cell.layer.cornerRadius = 15
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.allPriceLabel.layer.borderWidth = 1
            cell.allPriceLabel.layer.cornerRadius = 4
            cell.allPriceLabel.layer.borderColor = UIColor.gray.cgColor
            cell.addItem.tag = indexPath.row
            cell.hideViewAddItemButton.tag = indexPath.row
            cell.subtractItemButton.tag = indexPath.row
            if allItemInfo[indexPath.row].itemCount == 0 {
                cell.hideView.alpha = 0
            } else {
                cell.hideView.alpha = 0.7
                cell.allCountLabel.text = "\( self.allItemInfo[indexPath.row].itemCount!)"
            }
            cell.watchForClickHandler(completion: {index in
                if index == 0 {
                    Trolley.shared.addItemToTrolley(item: self.allItemInfo[indexPath.row])
                    cell.hideView.alpha = 0.7
                    cell.allCountLabel.text = "\(self.allItemInfo[indexPath.row].itemCount!)"
                }else {
                    Trolley.shared.removeItemToTrolley(trolleyItem: self.allItemInfo[indexPath.row])
                    self.allItemInfo[indexPath.row].itemCount =  self.allItemInfo[indexPath.row].itemCount - 1
                    if  self.allItemInfo[indexPath.row].itemCount < 1 {
                        cell.hideView.alpha = 0
                    } else {
                        cell.allCountLabel.text = "\( self.allItemInfo[indexPath.row].itemCount!)"
                    }
                    if Trolley.shared.price < 0 {
                        Trolley.shared.price = 0.0
                    }
                }
                
                self.homeTotalPrice.text = "\(Trolley.shared.price)"
            })
            return cell
        }
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
    // Outlet Function
    
    @IBAction func didTapPopupViewLeftArrow(_ sender: UIButton) {
        if isFruit == true {
            if popUpCount > 0 && popUpCount < fruitInfo.count{
                popUpCount = popUpCount - 1
                if fruitInfo[popUpCount].itemCount == 0 {
                    popUpHideView.alpha = 0
                    popUpHideView2.alpha = 0
                } else {
                    popUpHideView.alpha = 0.9
                    popUpHideView2.alpha = 0.7
                    popUpViewCountLabel.text = "\(fruitInfo[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (fruitInfo[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(fruitInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = fruitInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(fruitInfo[popUpCount].itemWeight!)"
            } else {
                popUpCount = fruitInfo.count - 1
                if fruitInfo[popUpCount].itemCount == 0 {
                    popUpHideView.alpha = 0
                    popUpHideView2.alpha = 0
                } else {
                    popUpHideView.alpha = 0.9
                    popUpHideView2.alpha = 0.7
                    popUpViewCountLabel.text = "\(fruitInfo[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//fruitInfo[popUpCount].itemImage
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (fruitInfo[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(fruitInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = fruitInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(fruitInfo[popUpCount].itemWeight!)"
            }
        } else if isVegetable == true {
            if popUpCount > 0 && popUpCount < vegetableInfo.count{
                popUpCount = popUpCount - 1
                if vegetableInfo[popUpCount].itemCount == 0 {
                    popUpHideView.alpha = 0
                    popUpHideView2.alpha = 0
                } else {
                    popUpHideView.alpha = 0.9
                    popUpHideView2.alpha = 0.7
                    popUpViewCountLabel.text = "\(vegetableInfo[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//vegetableInfo[popUpCount].itemImage
                popUpViewPriceLabel.text = "\(vegetableInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = vegetableInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(vegetableInfo[popUpCount].itemWeight!)"
            } else {
                popUpCount = vegetableInfo.count - 1
                if vegetableInfo[popUpCount].itemCount == 0 {
                    popUpHideView.alpha = 0
                    popUpHideView2.alpha = 0
                } else {
                    popUpHideView.alpha = 0.9
                    popUpHideView2.alpha = 0.7
                    popUpViewCountLabel.text = "\(vegetableInfo[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//vegetableInfo[popUpCount].itemImage
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (vegetableInfo[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(vegetableInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = vegetableInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(vegetableInfo[popUpCount].itemWeight!)"
            }
            
        } else {
            if popUpCount > 0 && popUpCount < allItemInfo.count{
                popUpCount = popUpCount - 1
                if allItemInfo[popUpCount].itemCount == 0 {
                    popUpHideView.alpha = 0
                    popUpHideView2.alpha = 0
                } else {
                    popUpHideView.alpha = 0.9
                    popUpHideView2.alpha = 0.7
                    popUpViewCountLabel.text = "\(allItemInfo[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//allItemInfo[popUpCount].itemImage
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (allItemInfo[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(allItemInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = allItemInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(allItemInfo[popUpCount].itemWeight!)"
                
            }else {
                popUpCount = allItemInfo.count - 1
                if allItemInfo[popUpCount].itemCount == 0 {
                    popUpHideView.alpha = 0
                    popUpHideView2.alpha = 0
                } else {
                    popUpHideView.alpha = 0.9
                    popUpHideView2.alpha = 0.7
                    popUpViewCountLabel.text = "\(allItemInfo[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//allItemInfo[popUpCount].itemImage
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (allItemInfo[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(allItemInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = allItemInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(allItemInfo[popUpCount].itemWeight!)"
            }
            
        }
    }
    @IBAction func didTapPopUpViewRightArrow(_ sender: UIButton) {
        if isFruit == true {
            if popUpCount < fruitInfo.count - 1 && popUpCount >= 0 {
                popUpCount = popUpCount + 1
                if fruitInfo[popUpCount].itemCount == 0 {
                    popUpHideView.alpha = 0
                    popUpHideView2.alpha = 0
                } else {
                    popUpHideView.alpha = 0.9
                    popUpHideView2.alpha = 0.7
                    popUpViewCountLabel.text = "\(fruitInfo[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//fruitInfo[popUpCount].itemImage
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (fruitInfo[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(fruitInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = fruitInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(fruitInfo[popUpCount].itemWeight!)"
            } else {
                popUpCount = 0
                if fruitInfo[popUpCount].itemCount == 0 {
                    popUpHideView.alpha = 0
                    popUpHideView2.alpha = 0
                } else {
                    popUpHideView.alpha = 0.9
                    popUpHideView2.alpha = 0.7
                    popUpViewCountLabel.text = "\(fruitInfo[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//fruitInfo[popUpCount].itemImage
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (fruitInfo[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(fruitInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = fruitInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(fruitInfo[popUpCount].itemWeight!)"
            }
        } else if isVegetable == true {
            if popUpCount < vegetableInfo.count - 1 && popUpCount >= 0 {
                popUpCount = popUpCount + 1
                if vegetableInfo[popUpCount].itemCount == 0 {
                    popUpHideView.alpha = 0
                    popUpHideView2.alpha = 0
                } else {
                    popUpHideView.alpha = 0.9
                    popUpHideView2.alpha = 0.7
                    popUpViewCountLabel.text = "\(vegetableInfo[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//vegetableInfo[popUpCount].itemImage
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (vegetableInfo[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(vegetableInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = vegetableInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(vegetableInfo[popUpCount].itemWeight!)"
            } else {
                popUpCount = 0
                if vegetableInfo[popUpCount].itemCount == 0 {
                    popUpHideView.alpha = 0
                    popUpHideView2.alpha = 0
                } else {
                    popUpHideView.alpha = 0.9
                    popUpHideView2.alpha = 0.7
                    popUpViewCountLabel.text = "\(vegetableInfo[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (vegetableInfo[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(vegetableInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = vegetableInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(vegetableInfo[popUpCount].itemWeight!)"
            }
            
        } else {
            if popUpCount >= 0 && popUpCount < allItemInfo.count - 1   {
                popUpCount = popUpCount + 1
                if allItemInfo[popUpCount].itemCount == 0 {
                    popUpHideView.alpha = 0
                    popUpHideView2.alpha = 0
                } else {
                    popUpHideView.alpha = 0.9
                    popUpHideView2.alpha = 0.7
                    popUpViewCountLabel.text = "\(allItemInfo[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//allItemInfo[popUpCount].itemImage
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (allItemInfo[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(allItemInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = allItemInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(allItemInfo[popUpCount].itemWeight!)"
                
            }else {
                popUpCount = 0
                if allItemInfo[popUpCount].itemCount == 0 {
                    popUpHideView.alpha = 0
                    popUpHideView2.alpha = 0
                } else {
                    popUpHideView.alpha = 0.9
                    popUpHideView2.alpha = 0.7
                    popUpViewCountLabel.text = "\(allItemInfo[popUpCount].itemCount!)"
                }
                popUpViewImage.image = #imageLiteral(resourceName: "loading")//allItemInfo[popUpCount].itemImage
                let imageView = self.popUpViewImage.viewWithTag(0) as! UIImageView
                imageView.sd_setImage(with: URL(string: (allItemInfo[popUpCount].itemImage)!))
                popUpViewPriceLabel.text = "\(allItemInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = allItemInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(allItemInfo[popUpCount].itemWeight!)"
            }
            
        }
    }
    @IBAction func didTapPopUpViewAddButton(_ sender: Any) {
        self.popUpHideView.alpha = 0.9
        self.popUpHideView2.alpha = 0.5
        if isFruit == true {
            popUpItemDisplay(itemType: fruitInfo)
        } else if isVegetable == true {
            popUpItemDisplay(itemType: vegetableInfo)
        } else {
            popUpItemDisplay(itemType: allItemInfo)
        }
    }
    
    @IBAction func didTapPopUpCrossButton(_ sender: UIButton) {
        self.popUpView.alpha = 0
        myCollectionView.reloadData()
    }
    @IBAction func allItemSelected(_ sender: UIButton) {
        allItemButton.setTitleColor(UIColor.green, for: UIControlState.normal)
        fruitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        vegetableButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        allItemView.backgroundColor = UIColor.green
        fruitView.backgroundColor = UIColor.white
        vegetableView.backgroundColor = UIColor.white
        isVegetable = false
        isFruit = false
        myCollectionView.reloadData()
    }
    @IBAction func fruitSelected(_ sender: UIButton) {
        allItemButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        fruitButton.setTitleColor(UIColor.green, for: UIControlState.normal)
        vegetableButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        allItemView.backgroundColor = UIColor.white
        fruitView.backgroundColor = UIColor.green
        vegetableView.backgroundColor = UIColor.white
        isVegetable = false
        isFruit = true
        myCollectionView.reloadData()
    }
    @IBAction func vegetableSelected(_ sender: UIButton) {
        allItemButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        fruitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        vegetableButton.setTitleColor(UIColor.green, for: UIControlState.normal)
        allItemView.backgroundColor = UIColor.white
        fruitView.backgroundColor = UIColor.white
        vegetableView.backgroundColor = UIColor.green
        isVegetable = true
        isFruit = false
        myCollectionView.reloadData()
    }
    @IBAction func didTapTrolleyButton(_ sender: UIButton) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    @IBAction func sideMenuButtonClicked(_ sender: UIButton) {
        self.handelLogout()
    }
    func  popUpItemDisplay(itemType: [ItemInfo])  {
        Trolley.shared.addItemToTrolley(item: itemType[popUpCount])
        popUpViewCountLabel.text = "\(itemType[popUpCount].itemCount!)"
        homeTotalPrice.text = "\(Trolley.shared.price)"
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


