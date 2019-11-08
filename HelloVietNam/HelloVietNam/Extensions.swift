//
//  Extensions.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/3/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import Kingfisher

//MARK: TEXTFIELD
extension UITextField {
    // Extension line boder UIText field
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.init(red: 239/255, green: 198/255, blue: 136/255, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    // Extension line boder UIText field
    func setBottomBorderFlatRed() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.init(red: 231/255, green: 55/255, blue: 99/255, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
//MARK: IMAGE VIEW
extension UIImageView {
    func kfSetImage(url: String) {
        self.kf.setImage(with: URL(string: url))
    }
}

//MARK: UIWINDOW
extension UIWindow {
    //Extension remove UITransitionView for UIView
    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {
        let previousViewController = rootViewController
        if let transition = transition {
            layer.add(transition, forKey: kCATransition)
        }
        rootViewController = newRootViewController
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        if let previousViewController = previousViewController {
            previousViewController.dismiss(animated: false) {
                previousViewController.view.removeFromSuperview()
            }
        }
    }
}
//MARK: ARRAY
extension Array {
    // Extension get random element from array
    var randomElement: Element {
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}
//MARK: STRING
extension String {
    // Extension trim() a string
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    // Extension Replace string
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

//MARK: TABLEVIEW
extension UITableView {
    // Extension scrollToTop tableview
    func scrollToTop(animated: Bool) {
        setContentOffset(.zero, animated: animated)
    }
    // Extension scrollToBottom tableview
    func scrollToBottomAt(animated: Bool, section: Int) {
        if self.numberOfRows(inSection: section) > 0 {
            self.scrollToRow(at: IndexPath(item: self.numberOfRows(inSection: section), section: section), at: .bottom, animated: true)
        }
    }
    func scrollToBottom() {
        let sections = numberOfSections - 1
        if sections >= 0 {
            let rows = numberOfRows(inSection: sections)-1
            if rows >= 0 {
                let indexPath = IndexPath(row: rows, section: sections)
                DispatchQueue.main.async { [weak self] in
                    self?.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
}
//MARK: IMAGE
extension UIImage{
    // Extension apha image
    func alpha(_ value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
}
// Show alert
extension UIAlertController {
    func show() {
        present(animated: true, completion: nil)
    }
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if  let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else {
            if  let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(controller: selectedVC, animated: animated, completion: completion)
            } else {
                controller.present(self, animated: animated, completion: completion)
            }
        }
    }
}
