//
//  Storyboard.swift
//  TrollyAppItem
//
//  Created by Rashdan Natiq on 28/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit
import MBProgressHUD

class Storyboard: NSObject {
    private static var progressHUD: MBProgressHUD?
    private static var progressHUDRetainCount = 0
    static var screenView: UIView = {
        return (UIApplication.shared.keyWindow?.subviews.last)!
    }()
    static func showProgressHUD() {
        OperationQueue.main.addOperation {
            if progressHUD == nil {
                progressHUD = MBProgressHUD.showAdded(to: screenView, animated: true)
                progressHUDRetainCount = 1
            } else {
                progressHUDRetainCount += 1
            }
        }
    }
    static func showProgressHUDWithTitle() {
        if Storyboard.isAlreadyAvailable(in: screenView) == false {
            OperationQueue.main.addOperation {
                if progressHUD == nil {
                    progressHUD = MBProgressHUD.showAdded(to: screenView, animated: true)
                    progressHUD?.mode = MBProgressHUDMode.indeterminate
                    progressHUD?.label.text = "Please wait "
                    progressHUD?.detailsLabel.text = "Data Is Updating"
                    progressHUDRetainCount = 1
                } else {
                    progressHUDRetainCount += 1
                }
            }
        }
    }
    static func isAlreadyAvailable(in view: UIView) -> Bool {
        for subview in view.subviews {
            if subview is MBProgressHUD {
                return true
            }
        }
        return false
    }
    
    static func hideProgressHUD() {
        
        OperationQueue.main.addOperation {
            for view in screenView.subviews {
                if view is MBProgressHUD {
                    view.removeFromSuperview()
                }
            }
            if let progressHUD: MBProgressHUD = progressHUD {
                progressHUDRetainCount -= 1
                if progressHUDRetainCount == 0 {
                    progressHUD.hide(animated: true)
                    progressHUD.removeFromSuperview()
                    Storyboard.progressHUD = nil
                }
            }
        }
    }
    static func showProgressHUD(onView: UIView) {
        OperationQueue.main.addOperation {
            MBProgressHUD.showAdded(to: onView, animated: true)
        }
    }
    
    static func hideProgressHUD(onView: UIView) {
        OperationQueue.main.addOperation {
            MBProgressHUD.hide(for: onView, animated: true)
        }
    }
    
}
