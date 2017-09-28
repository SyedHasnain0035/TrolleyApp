//
//  SearchViewController.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 02/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , UISearchBarDelegate{

    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var trolleyLabel: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var myTabelView: UITableView!
    var allItemInfo = [ItemInfo]()
    var filterItem = [ItemInfo]()
    let searcController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLogedIn()
        myTabelView.delegate = self
        myTabelView.dataSource = self
        allItemInfo =   Trolley.shared.allItemInfo
        self.basicTableViewHeaderSetting()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserIsLogedIn()
        self.totalPriceLabel.text = "\(Trolley.shared.price)"
        myTabelView.reloadData()
        
    }
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
            Trolley.shared.deleteAll()
        } catch let logoutError {
            print(logoutError)
        }
    AlertView.showLoginAlert(self) 
    }
    @IBAction func didTapMenuButton(_ sender: UIButton) {
    }
    @IBAction func didTapTrolleyButton(_ sender: UIButton) {
        if Trolley.shared.price == 0.0 {
            
        } else {
            let apptabbarvc = self.tabBarController as? AppTabbarControllerView
            apptabbarvc?.previousIndex = apptabbarvc?.selectedIndex
            self.tabBarController?.selectedIndex = 5
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if searcController.isActive && searcController.searchBar.text != ""  {
            return filterItem.count
        }
        return allItemInfo.count
    }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filterItem = allItemInfo.filter{ item in
            let typeMatch = ( scope == "All" ) || ( item.itemType == scope)
            return typeMatch &&  item.itemDetail.lowercased().contains(searchText.lowercased())
            
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
        let all: ItemInfo
        if searcController.isActive && searcController.searchBar.text != ""  {
            all = filterItem[indexPath.row]
        } else {
            all = allItemInfo[indexPath.row]
        }
        cell.detailLabel.text = all.itemDetail
        cell.itemImage.image = #imageLiteral(resourceName: "loading")//all.itemImage
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.sd_setImage(with: URL(string: all.itemImage))
        cell.priceLabel.text = "\(all.itemPrice!) AED"
        cell.weightLabel.text = all.itemWeight
        cell.countLabel.text = "\(all.itemCount!)"
        cell.watchForClickHandler(completion: {index in
            if index == 0 {
                Trolley.shared.addItemToTrolley(item: self.allItemInfo[indexPath.row])
                cell.countLabel.text = "\(self.allItemInfo[indexPath.row].itemCount!)"
            }else {
                Trolley.shared.removeItemToTrolley(trolleyItem: self.allItemInfo[indexPath.row])
                self.allItemInfo[indexPath.row].itemCount =  self.allItemInfo[indexPath.row].itemCount - 1
                if self.allItemInfo[indexPath.row].itemCount < 1 {
                    self.allItemInfo[indexPath.row].itemCount = 0
                    cell.countLabel.text = "\( self.allItemInfo[indexPath.row].itemCount!)"
                } else {
                    cell.countLabel.text = "\( self.allItemInfo[indexPath.row].itemCount!)"
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
 /*   func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }*/
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            myTabelView.reloadData()
        } else {
            myTabelView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            myTabelView.reloadData()
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
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //let searcBar = searcController.searchBar
        //let scope = searcBar.scopeButtonTitles![searcBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searcController.searchBar.text!)
    }
}
