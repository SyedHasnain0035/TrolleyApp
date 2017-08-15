//
//  ItemTableViewCell.swift
//  TrollyAppItem
//
//  Created by Rashdan Natiq on 15/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemActiveImage: UIImageView!
    @IBOutlet weak var itemType: UILabel!
    @IBOutlet weak var itemWeight: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDetailLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
