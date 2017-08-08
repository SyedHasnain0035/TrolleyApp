//
//  AllItemsCollectionViewCell.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 03/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class AllItemsCollectionViewCell: UICollectionViewCell {
    var clickHandler: ((Int)-> Void)?
    @IBOutlet var hideViewAddItemButton: UIButton!
    @IBOutlet var subtractItemButton: UIButton!
    @IBOutlet weak var addItem: UIButton!
    @IBOutlet weak var allCountLabel: UILabel!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var allQuantityLabel: UILabel!
    @IBOutlet weak var allDetailLabel: UILabel!
    @IBOutlet weak var allPriceLabel: UILabel!
    @IBOutlet weak var allItemImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   func watchForClickHandler(completion: @escaping (Int)->Void) {
        self.clickHandler = completion
    }
    
    @IBAction func addItemButton(_ sender: UIButton) {
        guard let completion = self.clickHandler else {return}
        completion(0)
    }
    @IBAction func hideMinusButtonClicked(_ sender: UIButton) {
        guard let completion = self.clickHandler else {return}
        completion(1)
    }
    @IBAction func hideAddButtonClicked(_ sender: UIButton) {
        guard let completion = self.clickHandler else {return}
        completion(0)
    } 
}
