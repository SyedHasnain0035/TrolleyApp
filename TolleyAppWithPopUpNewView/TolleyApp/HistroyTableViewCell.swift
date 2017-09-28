//
//  HistroyTableViewCell.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 25/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class HistroyTableViewCell: UITableViewCell {

    @IBOutlet weak var recivedLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
