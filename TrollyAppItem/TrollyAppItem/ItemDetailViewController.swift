//
//  ItemDetailViewController.swift
//  TrollyAppItem
//
//  Created by Rashdan Natiq on 15/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    @IBOutlet weak var isActiveButton: UIButton!
    @IBOutlet weak var itemTypTextField: UITextField!
    @IBOutlet weak var itemWeightTextField: UITextField!
    
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemDetailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapActiveButton(_ sender: UIButton) {
    }

}
