//
//  SearchProductViewController.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 03/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class SearchProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate{

    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var myTabelView: UITableView!
    var filterItem = [ItemInfo]()
    // for search bar
    let searcController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.basicTableViewHeaderSetting()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.totalPriceLabel.text = "\(Trolley.shared.price)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func didTapTrolleyButton(_ sender: UIButton) {
    }
    @IBAction func didTapBackArrow(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filterItem = Trolley.shared.allItemInfo.filter{ item in
            let typeMatch = ( scope == "All" ) || ( item.itemType == scope)
            return typeMatch &&  item.itemDetail.lowercased().contains(searchText.lowercased())
        }
    }
    // Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searcController.isActive && searcController.searchBar.text != ""  {
            return filterItem.count
        }
        return Trolley.shared.allItemInfo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SearchItemTableViewCell", owner: self, options: nil)?.first as! SearchItemTableViewCell
        cell.addSubView.layer.cornerRadius = 7
        cell.addSubView.layer.borderWidth = 1
        cell.countLabel.layer.borderWidth = 1
        cell.backGroundView.layer.cornerRadius = 10
        cell.backGroundView.layer.borderWidth = 1
        cell.backGroundView.layer.borderColor = UIColor.gray.cgColor
        let item: ItemInfo
        if searcController.isActive && searcController.searchBar.text != ""  {
            item = filterItem[indexPath.row]
        } else {
            item = Trolley.shared.allItemInfo[indexPath.row]
        }
        cell.detailLabel.text = item.itemDetail
        cell.itemImage.image = item.itemImage
        cell.priceLabel.text = "\(item.itemPrice!) AED"
        cell.weightLabel.text = item.itemQuantity
        cell.countLabel.text = "\(item.itemCount!)"
        cell.watchForClickHandler(completion: {index in
            if index == 0 {
                Trolley.shared.addItemToTrolley(item: Trolley.shared.allItemInfo[indexPath.row])
                cell.countLabel.text = "\(Trolley.shared.allItemInfo[indexPath.row].itemCount!)"
            }else {
                Trolley.shared.removeItemToTrolley(trolleyItem: Trolley.shared.allItemInfo[indexPath.row])
                Trolley.shared.allItemInfo[indexPath.row].itemCount =  Trolley.shared.allItemInfo[indexPath.row].itemCount - 1
                if  Trolley.shared.allItemInfo[indexPath.row].itemCount < 1 {
                   Trolley.shared.allItemInfo[indexPath.row].itemCount = 0
                    cell.countLabel.text = "\( Trolley.shared.allItemInfo[indexPath.row].itemCount!)"
                } else {
                    cell.countLabel.text = "\( Trolley.shared.allItemInfo[indexPath.row].itemCount!)"
                }
                if Trolley.shared.price < 0 {
                    Trolley.shared.price = 0.0
                }
            }
    
            self.totalPriceLabel.text = "\(Trolley.shared.price)"
        })
        return cell
    }
    // Search Bar Function
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
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
    
    func basicTableViewHeaderSetting()  {
        searcController.searchResultsUpdater = self
        searcController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        myTabelView.tableHeaderView = searcController.searchBar
        myTabelView.tableHeaderView?.tintColor = UIColor.green
        myTabelView.tableHeaderView?.backgroundColor = UIColor.green
        searcController.searchBar.delegate = self
        searcController.searchBar.barTintColor = UIColor.green
        searcController.searchBar.placeholder = "Search for product and brands"
    }
}
extension SearchProductViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
       // let searcBar = searcController.searchBar
        //let scope = searcBar.scopeButtonTitles![searcBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searcController.searchBar.text!)
    }
}
