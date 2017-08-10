//
//  HomeViewController.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 02/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

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
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        setItemValues()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        mySearchBar.resignFirstResponder()
        myCollectionView.reloadData()
        self.homeTotalPrice.text = "\(Trolley.shared.price)"
    }
    override func viewWillDisappear(_ animated: Bool) {
        mySearchBar.resignFirstResponder()
    }
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
            popUpViewImage.image = fruitInfo[indexPath.row].itemImage
            popUpViewPriceLabel.text = "\(fruitInfo[indexPath.row].itemPrice!) AED"
            popUpViewDetailLabel.text = fruitInfo[indexPath.row].itemDetail
            popUpViewWeightLabel.text = "per \(fruitInfo[indexPath.row].itemQuantity!)"
        } else if isVegetable == true {
            if vegetableInfo[indexPath.row].itemCount == 0 {
                popUpHideView.alpha = 0
                popUpHideView2.alpha = 0
            } else {
                popUpHideView.alpha = 0.9
                popUpHideView2.alpha = 0.7
                popUpViewCountLabel.text = "\(vegetableInfo[indexPath.row].itemCount!)"
            }
            popUpViewImage.image = vegetableInfo[indexPath.row].itemImage
            popUpViewPriceLabel.text = "\(vegetableInfo[indexPath.row].itemPrice!) AED"
            popUpViewDetailLabel.text = vegetableInfo[indexPath.row].itemDetail
            popUpViewWeightLabel.text = "per \(allItemInfo[indexPath.row].itemQuantity!)"
        } else {
            if allItemInfo[indexPath.row].itemCount == 0 {
                popUpHideView.alpha = 0
                popUpHideView2.alpha = 0
            } else {
                popUpHideView.alpha = 0.9
                popUpHideView2.alpha = 0.7
                popUpViewCountLabel.text = "\(allItemInfo[indexPath.row].itemCount!)"
            }
            popUpViewImage.image = allItemInfo[indexPath.row].itemImage
            popUpViewPriceLabel.text = "\(allItemInfo[indexPath.row].itemPrice!) AED"
            popUpViewDetailLabel.text = allItemInfo[indexPath.row].itemDetail
            popUpViewWeightLabel.text = "per \(allItemInfo[indexPath.row].itemQuantity!)"
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
            cell.allItemImage.image = fruitInfo[indexPath.row].itemImage
            cell.allPriceLabel.text =  "\(fruitInfo[indexPath.row].itemPrice!) AED"
            cell.allDetailLabel.text = fruitInfo[indexPath.row].itemDetail
            cell.allQuantityLabel.text = "per \(fruitInfo[indexPath.row].itemQuantity!)"
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
            cell.allItemImage.image = vegetableInfo[indexPath.row].itemImage
            cell.allPriceLabel.text = "\(vegetableInfo[indexPath.row].itemPrice!) AED"
            cell.allQuantityLabel.text = vegetableInfo[indexPath.row].itemQuantity
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
            cell.allItemImage.image = allItemInfo[indexPath.row].itemImage
            cell.allDetailLabel.text = allItemInfo[indexPath.row].itemDetail
            cell.allPriceLabel.text = "\(allItemInfo[indexPath.row].itemPrice!) AED"
            cell.allQuantityLabel.text = "per \(allItemInfo[indexPath.row].itemQuantity!)"
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchProductViewController") as! SearchProductViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        mySearchBar.resignFirstResponder()
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
                popUpViewImage.image = fruitInfo[popUpCount].itemImage
                popUpViewPriceLabel.text = "\(fruitInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = fruitInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(fruitInfo[popUpCount].itemQuantity!)"
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
                popUpViewImage.image = fruitInfo[popUpCount].itemImage
                popUpViewPriceLabel.text = "\(fruitInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = fruitInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(fruitInfo[popUpCount].itemQuantity!)"
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
                popUpViewImage.image = vegetableInfo[popUpCount].itemImage
                popUpViewPriceLabel.text = "\(vegetableInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = vegetableInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(vegetableInfo[popUpCount].itemQuantity!)"
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
                popUpViewImage.image = vegetableInfo[popUpCount].itemImage
                popUpViewPriceLabel.text = "\(vegetableInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = vegetableInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(vegetableInfo[popUpCount].itemQuantity!)"
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
                popUpViewImage.image = allItemInfo[popUpCount].itemImage
                popUpViewPriceLabel.text = "\(allItemInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = allItemInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(allItemInfo[popUpCount].itemQuantity!)"
                
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
                popUpViewImage.image = allItemInfo[popUpCount].itemImage
                popUpViewPriceLabel.text = "\(allItemInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = allItemInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(allItemInfo[popUpCount].itemQuantity!)"
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
                popUpViewImage.image = fruitInfo[popUpCount].itemImage
                popUpViewPriceLabel.text = "\(fruitInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = fruitInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(fruitInfo[popUpCount].itemQuantity!)"
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
                popUpViewImage.image = fruitInfo[popUpCount].itemImage
                popUpViewPriceLabel.text = "\(fruitInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = fruitInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(fruitInfo[popUpCount].itemQuantity!)"
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
                popUpViewImage.image = vegetableInfo[popUpCount].itemImage
                popUpViewPriceLabel.text = "\(vegetableInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = vegetableInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(vegetableInfo[popUpCount].itemQuantity!)"
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
                popUpViewImage.image = vegetableInfo[popUpCount].itemImage
                popUpViewPriceLabel.text = "\(vegetableInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = vegetableInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(vegetableInfo[popUpCount].itemQuantity!)"
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
                popUpViewImage.image = allItemInfo[popUpCount].itemImage
                popUpViewPriceLabel.text = "\(allItemInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = allItemInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(allItemInfo[popUpCount].itemQuantity!)"
                
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
                popUpViewImage.image = allItemInfo[popUpCount].itemImage
                popUpViewPriceLabel.text = "\(allItemInfo[popUpCount].itemPrice!) AED"
                popUpViewDetailLabel.text = allItemInfo[popUpCount].itemDetail
                popUpViewWeightLabel.text = "per \(allItemInfo[popUpCount].itemQuantity!)"
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
    func  popUpItemDisplay(itemType: [ItemInfo])  {
        Trolley.shared.addItemToTrolley(item: itemType[popUpCount])
        popUpViewCountLabel.text = "\(itemType[popUpCount].itemCount!)"
        homeTotalPrice.text = "\(Trolley.shared.price)"
    }
    func setItemValues()  {
        fruitInfo = [ItemInfo(itemId: "0001", itemDetail: "Banana Banana",itemPrice: 3.5, itemQuantity: " 1 Kg", itemType: "Fruit", itemImage: #imageLiteral(resourceName: "banana"), itemCount: 0),
                     ItemInfo(itemId: "fru0002", itemDetail: "appricot appricot", itemPrice: 4.5 , itemQuantity: " 1.5 Kg", itemType: "Fruit",itemImage: #imageLiteral(resourceName: "appricot"), itemCount: 0),
                     ItemInfo(itemId: "fru0003", itemDetail: "grap grap", itemPrice: 5.5, itemQuantity: " 2 Kg",itemType: "Fruit", itemImage: #imageLiteral(resourceName: "grap"), itemCount: 0),
                     ItemInfo( itemId: "fru0004", itemDetail: "pear pear", itemPrice: 6.5, itemQuantity: " 2.5 Kg",itemType: "Fruit",itemImage: #imageLiteral(resourceName: "pear"), itemCount: 0)]
        
        vegetableInfo = [ ItemInfo(itemId: "0011", itemDetail: "celiflower celiflower", itemPrice: 3.5, itemQuantity: " 1 Kg", itemType: "Veg",itemImage: #imageLiteral(resourceName: "celiflower"), itemCount: 0),
                          ItemInfo(itemId: "0012", itemDetail: "mixVeg mixVeg", itemPrice: 4.5, itemQuantity: " 1.5 Kg", itemType: "Veg",itemImage: #imageLiteral(resourceName: "mixVeg"), itemCount: 0),
                          ItemInfo(itemId: "0013", itemDetail: "carrot carrot", itemPrice: 5.5, itemQuantity: " 2 Kg",itemType: "Veg",itemImage: #imageLiteral(resourceName: "carrot"), itemCount: 0),
                          ItemInfo(itemId: "0014", itemDetail: "tomato tomato", itemPrice: 6.5, itemQuantity: " 2.5 Kg",itemType: "Veg",itemImage: #imageLiteral(resourceName: "tomato"), itemCount: 0)]
        allItemInfo = fruitInfo + vegetableInfo
    }
    
    // Aler View
    
    
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



