//
//  ForgotPasswordViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Thursday, March 2.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import HMSegmentedControl
import SCLAlertView
import MBProgressHUD
class ForgotPasswordViewController: UIViewController{
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var lblFotgotPasswordMessage: UILabel!
    @IBOutlet weak var segmentLineBorder: UIView!
    let screenSize = UIScreen.main.bounds
    let inventorySegment = HMSegmentedControl()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let initialViewController = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        initialViewController.dismiss(animated:false, completion: nil)
        setUpSegmentControl()
        // Fix layout 6+
        if screenSize.width == 414 {
            inventorySegment.frame.origin.y = inventorySegment.frame.origin.y + 2.5
            segmentLineBorder.frame.origin.y = segmentLineBorder.frame.origin.y + 2.5
        } else if screenSize.width == 320 {
            inventorySegment.frame.origin.y = inventorySegment.frame.origin.y - 7
            segmentLineBorder.frame.origin.y = segmentLineBorder.frame.origin.y - 7
        }
        buttonSend.setTitle(NSLocalizedString("send", comment: ""), for: .normal)
        lblFotgotPasswordMessage.text = NSLocalizedString("enter_email_address", comment: "")
        txtEmailAddress.placeholder = NSLocalizedString("email_address", comment: "")
    }
    
    func setUpAnimation() {
        // Animation view begin
        lblFotgotPasswordMessage.center.y = self.view.frame.height + (self.view.frame.height + 30)
        txtEmailAddress.center.y = self.view.frame.height + (self.view.frame.height + 30)
        buttonSend.center.y = self.view.frame.height + (self.view.frame.height + 30)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.lblFotgotPasswordMessage.center.y  = self.view.frame.height / 2
            self.txtEmailAddress.center.y  = self.view.frame.height / 2
            self.buttonSend.center.y  = self.view.frame.height / 2
        }, completion: nil)
        // Animation view end
        txtEmailAddress.layer.borderColor = UIColor.init(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0).cgColor
        txtEmailAddress.layer.borderWidth = 0.5
    }

    
    func setUpSegmentControl() {
        var listSegmentValues = [String]()
        listSegmentValues.append(NSLocalizedString("forget_password", comment: ""))
        inventorySegment.sectionTitles = listSegmentValues
        inventorySegment.backgroundColor = UIColor(white: 1, alpha: 0)
        inventorySegment.selectedSegmentIndex = 0
        if #available(iOS 8.2, *) {
            inventorySegment.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(14), weight: UIFontWeightSemibold)]
        } else {
            inventorySegment.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(14))]
        }
        inventorySegment.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(14))]
        inventorySegment.frame = CGRect(x: 0, y: self.view.bounds.height * 0.335, width: self.view.bounds.width, height: 45)
        segmentLineBorder.frame = CGRect(x: 0, y: self.view.bounds.height * 0.335 - 1, width: self.view.bounds.width, height: 0.5)
        inventorySegment.selectionStyle = HMSegmentedControlSelectionStyle.textWidthStripe
        inventorySegment.selectionIndicatorColor = UIColor.init(red: 255/255, green: 225/255, blue: 1/255, alpha: 1.0)
        inventorySegment.selectionIndicatorHeight = 3
        inventorySegment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        inventorySegment.tag = 1
        self.view.addSubview(inventorySegment)
    }

    @IBAction func buttonBackDidTouch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonSendDidTouch(_ sender: Any) {
        let common = Common()
        if !common.checkNetworkConnect() {
            SCLAlertView().showError(NSLocalizedString("error", comment: ""),
                                     subTitle: NSLocalizedString("error_network", comment: ""))
            return
        }
        if (txtEmailAddress.text?.isEmpty)! {
            SCLAlertView().showError(NSLocalizedString("error", comment: ""),
                                     subTitle: NSLocalizedString("error_nil_forgot_password", comment: ""))
        } else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            UserDAO.forgotPassword(email: txtEmailAddress.text!, completeHandle: {(success) in
                if success {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.txtEmailAddress.text = ""
                    SCLAlertView().showWarning(NSLocalizedString("success", comment: ""),
                                               subTitle: NSLocalizedString("forgot_password_success", comment: ""))
                }
            })
         }
    }
}
