//
//  SearchViewController.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 02/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , UISearchBarDelegate{

    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var trolleyLabel: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var myTabelView: UITableView!
    var totalPrice = 0
    var allItemInfo = [ItemInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        myTabelView.delegate = self
        myTabelView.dataSource = self
        allItemInfo =   [ItemInfo(itemId: "fru0001",itemDetail: "Banana Banana", itemPrice: 3.5, itemQuantity: " 1 Kg", itemType: "Fruit", itemImage: #imageLiteral(resourceName: "banana"), itemCount: 0),
                         ItemInfo(itemId: "fru0002", itemDetail: "appricot appricot", itemPrice: 4.5 , itemQuantity: " 1.5 Kg", itemType: "Fruit", itemImage: #imageLiteral(resourceName: "appricot"), itemCount: 0),
                         ItemInfo(itemId: "fru0003", itemDetail: "grap grap", itemPrice: 5.5, itemQuantity: " 2 Kg",itemType: "Fruit", itemImage: #imageLiteral(resourceName: "grap"), itemCount: 0),
                         ItemInfo( itemId: "fru0004", itemDetail: "pear pear", itemPrice: 6.5, itemQuantity: " 2.5 Kg",itemType: "Fruit",itemImage: #imageLiteral(resourceName: "pear"), itemCount: 0),
                         ItemInfo(itemId: "0011", itemDetail: "celiflower celiflower", itemPrice: 3.5, itemQuantity: " 1 Kg", itemType: "Veg",itemImage: #imageLiteral(resourceName: "celiflower"), itemCount: 0),
                         ItemInfo(itemId: "0012", itemDetail: "mixVeg mixVeg", itemPrice: 4.5, itemQuantity: " 1.5 Kg", itemType: "Veg",itemImage: #imageLiteral(resourceName: "mixVeg"), itemCount: 0),
                         ItemInfo(itemId: "0013", itemDetail: "carrot carrot", itemPrice: 5.5, itemQuantity: " 2 Kg",itemType: "Veg",itemImage: #imageLiteral(resourceName: "carrot"), itemCount: 0),
                         ItemInfo(itemId: "0014", itemDetail: "tomato tomato", itemPrice: 6.5, itemQuantity: " 2.5 Kg",itemType: "Veg",itemImage: #imageLiteral(resourceName: "tomato"), itemCount: 0)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func didTapMenuButton(_ sender: UIButton) {
    }
    @IBAction func didTapTrolleyButton(_ sender: UIButton) {
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text == "" {
            return 0
        } else {
            return allItemInfo.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SearchItemTableViewCell", owner: self, options: nil)?.first as! SearchItemTableViewCell
        cell.addSubView.layer.cornerRadius = 7
        cell.addSubView.layer.borderWidth = 1
        cell.countLabel.layer.borderWidth = 1
        cell.backGroundView.layer.cornerRadius = 10
        cell.backGroundView.layer.borderWidth = 1
        cell.backGroundView.layer.borderColor = UIColor.gray.cgColor
        cell.detailLabel.text = allItemInfo[indexPath.row].itemDetail
        cell.itemImage.image = allItemInfo[indexPath.row].itemImage
        cell.priceLabel.text = "\(allItemInfo[indexPath.row].itemPrice!) AED"
        cell.weightLabel.text = allItemInfo[indexPath.row].itemQuantity
        return cell

    }
    // Search Bar Function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
        } else {
            myTabelView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
        } else {
            myTabelView.reloadData()
        }
    }

}
