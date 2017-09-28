//
//  ProductViewController.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 09/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var proImage: UIImageView!
    var selectedItems = [ItemInfo]()
    var count = 0
    var hView = HomeViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.borderWidth = 4
        backView.layer.borderColor = UIColor.gray.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        backView.layer.borderWidth = 4
        backView.layer.borderColor = UIColor.gray.cgColor
        displayOnView(index: count)
        if selectedItems[count].itemCount == 0 {
            countLabel.isHidden = true
        } else {
            countLabel.isHidden = false
            countLabel.text = "\(selectedItems[count].itemCount!)"
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapCrossButton(_ sender: UIButton) {
        self.view.removeFromSuperview()
        hView.myCollectionView.reloadData()
        self.selectedItems = []
    }
    @IBAction func didTapAddButton(_ sender: UIButton) {
    Trolley.shared.addItemToTrolley(item: selectedItems[count])
    countLabel.text = "\(selectedItems[count].itemCount!)"
    countLabel.isHidden = false
    hView.homeTotalPrice.text = "\(Trolley.shared.price)"
    }

    @IBAction func didTaPRightShift(_ sender: UIButton) {
        count = count + 1
        if count < selectedItems.count {
            displayOnView(index: count)
            
        } else {
            count = 0
            displayOnView(index: count)
        }
        if selectedItems[count].itemCount == 0 {
            countLabel.isHidden = true
        } else {
            countLabel.isHidden = false
            countLabel.text = "\(selectedItems[count].itemCount!)"
        }
    }
    @IBAction func didTapLeftShift(_ sender: UIButton) {
        count = count - 1
        if count >= 0 {
            displayOnView(index: count)
        } else {
            count = selectedItems.count - 1
            displayOnView(index: count)
        }
        if selectedItems[count].itemCount == 0 {
            countLabel.isHidden = true
        } else {
            countLabel.isHidden = false
            countLabel.text = "\(selectedItems[count].itemCount!)"
            
        }
    }
    func displayOnView(index: Int) {
        proImage.image = #imageLiteral(resourceName: "loading")
        let imageView = self.proImage.viewWithTag(0) as! UIImageView
        imageView.sd_setImage(with: URL(string: (selectedItems[index].itemImage)!))
        priceLabel.text = "\(selectedItems[index].itemPrice!) AED"
        detailLabel.text = selectedItems[index].itemDetail
        weightLabel.text = "per \(selectedItems[index].itemWeight!)"
        
    }
}
