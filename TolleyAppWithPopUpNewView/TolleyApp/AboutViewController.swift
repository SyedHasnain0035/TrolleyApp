//
//  AboutViewController.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 28/09/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var backGroundViewSideConstrain: NSLayoutConstraint!
    var isSideMenu = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapSideMenuButoon(_ sender: UIButton) {
        sideMenu()
    }
    @IBAction func didTapAllCategoryButton(_ sender: UIButton) {
        Trolley.shared.isVegeTabel = false
        Trolley.shared.isFruit = false
        self.tabBarController?.selectedIndex = 2
    }
   
    @IBAction func didTapFruitButton(_ sender: UIButton) {
        Trolley.shared.isFruit = true
        Trolley.shared.isVegeTabel = false
         self.tabBarController?.selectedIndex = 2
    }

    @IBAction func didTapVegetabelButton(_ sender: UIButton) {
        Trolley.shared.isVegeTabel = true
        Trolley.shared.isFruit = false
        self.tabBarController?.selectedIndex = 2
    }
    func sideMenu()  {
        
        if (isSideMenu) {
            backGroundViewSideConstrain.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            backGroundViewSideConstrain.constant = 200
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        isSideMenu = !isSideMenu
    }

}
