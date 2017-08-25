//
//  AppTabbarControllerView.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 25/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class AppTabbarControllerView: UITabBarController {
    var previousIndex: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = self.tabBar.items
        {
            let tabBarImages = getTabBarImages() // tabBarImages: [UIImage]
            for i in 0..<items.count {
                let tabBarItem = items[i]
                let tabBarImage = tabBarImages[i]
                tabBarItem.image = tabBarImage.withRenderingMode(.alwaysOriginal)
                //tabBarItem.selectedImage = tabBarImage
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getTabBarImages()-> [UIImage]
    {
        
        let homeImage : UIImage = UIImage(named: "home_icon")!
        let search  : UIImage = UIImage(named: "search_icon")!
        let history : UIImage = UIImage(named: "history_icon")!
        let checkOut : UIImage = UIImage(named: "checkout_icon")!
        let acount : UIImage = UIImage(named: "account_icon")!
        let imageArray : [UIImage] = [acount,homeImage,search,history,checkOut]
        
        return imageArray
    }


}
