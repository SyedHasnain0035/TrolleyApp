//
//  AlertView.swift
//  TolleyApp
//
//  Created by Syed Qamar Abbas on 11/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class AlertView: UIView {
    var clickHandler: ((Int)-> Void)?
    @IBOutlet var itemPriceLabel: UILabel!
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itmeWeightLabel: UILabel!
    @IBOutlet var itemDetailLabel: UILabel!
    @IBAction func didTapCrossButton(_ sender: UIButton) {
    }
    @IBAction func didTapAddButton(_ sender: UIButton) {
    }
    @IBAction func didTapRightArrowButton(_ sender: UIButton) {
    }
    @IBAction func didTapLeftArrowButton(_ sender: UIButton) {
    }
    static func initWithNib() -> AlertView {
        let view = UINib(nibName: "AlerView", bundle: nil).instantiate(withOwner: self, options: nil) [0] as! AlertView
     return view
    }
    static func showAleßrt(with image: UIImage, price: String, detail: String, weight: String, buttons: [String], completion: @escaping (Int)-> Void){
        var myAlert = AlertView.initWithNib()
        myAlert.itemImage.image = image
        myAlert.itemPriceLabel.text = price
        myAlert.itemDetailLabel.text = detail
        myAlert.itmeWeightLabel.text = weight
        myAlert.clickHandler = completion
        
    }
    static func showAleßrt(onView: UIView, image: UIImage, price: String, detail: String, weight: String, buttons: [String], completion: @escaping (Int)-> Void){
        var myAlert = AlertView.initWithNib()
        myAlert.itemImage.image = image
        myAlert.itemPriceLabel.text = price
        myAlert.itemDetailLabel.text = detail
        myAlert.itmeWeightLabel.text = weight
        myAlert.clickHandler = completion
        onView.addSubview(myAlert)
        
    }
}
