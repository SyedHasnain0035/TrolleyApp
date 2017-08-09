//
//  ProductViewController.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 09/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var proImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didTapCrossButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
   
    @IBAction func didTapAddButton(_ sender: UIButton) {
    }

    @IBAction func didTaPRightShift(_ sender: UIButton) {
    }
    @IBAction func didTapLeftShift(_ sender: UIButton) {
    }
}
