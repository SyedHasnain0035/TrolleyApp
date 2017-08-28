//
//  OrderDetailTableViewCell.swift
//  TrollyAppItem
//
//  Created by Rashdan Natiq on 28/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var backGroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
