//
//  InviteFriendsViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Friday, March 3.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import MessageUI
import FacebookShare
class InviteFriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, YellowNavigagionBarViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    var inviteFriendsTypes = [String]()
    var inviteFriendsImages = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpNavigationBar()
    }
    
    func setUpData() {
        inviteFriendsTypes.append(NSLocalizedString("invite_friend_via_sms", comment: ""))
        inviteFriendsTypes.append(NSLocalizedString("invite_friend_via_email", comment: ""))
        inviteFriendsTypes.append(NSLocalizedString("invite_friend_via_facebook", comment: ""))
        inviteFriendsTypes.append(NSLocalizedString("invite_friend_via_copy_link", comment: ""))
        
        inviteFriendsImages.append("send_sms")
        inviteFriendsImages.append("send_email")
        inviteFriendsImages.append("send_facebook")
        inviteFriendsImages.append("send_link")
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
        let yellowNavigagionBarView  = UINib(nibName: "YellowNavigagionBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! YellowNavigagionBarView
        yellowNavigagionBarView.frame.origin = CGPoint(x: 0, y: 0)
        yellowNavigagionBarView.frame.size.width = self.view.bounds.width
        yellowNavigagionBarView.yellowDelegate = self
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("invite_friend", comment: "")
        yellowNavigagionBarView.buttonMap.isHidden = true
        yellowNavigagionBarView.lblNavTitle.isHidden = false
        yellowNavigagionBarView.txtMapName.isHidden = true
        yellowNavigagionBarView.imageYellow.isHidden = true
        self.view.addSubview(yellowNavigagionBarView)
    }
    // config section title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("invite_friend_via_title", comment: "")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inviteFriendsTypes.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendCell") as! InviteFriendCell
        cell.inviteFrendVia.text = inviteFriendsTypes[indexPath.row]
        cell.inviteFriendImage.image = UIImage(named:inviteFriendsImages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            sendSMS()
            break
        case 1:
            sendEmail()
            break
        case 2:
            sendFBMessenger()
            break
        case 3:
            UIPasteboard.general.string = NSLocalizedString("app_link", comment: "")
            showAlert(title: NSLocalizedString("invite_friend", comment: ""), message: NSLocalizedString("copy_clip_board", comment: ""))
            break;
        default:
            break
        }
    }
    
    func buttonMapDidTap() {
    }
    
    func buttonMenuDidTap() {
        self.slideMenuController()?.openLeft()
    }
    
    func yellowLogoDidTap() {
    }
    
    //MARK: SendSMS and delegate
    func sendSMS()  {
        if MFMessageComposeViewController.canSendText() {
            let smsController = MFMessageComposeViewController()
            smsController.body = NSLocalizedString("invite_friend_content", comment: "")
            smsController.messageComposeDelegate = self
            self.present(smsController, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: SendEmail and delegate
    func sendEmail() {
        let mailController = configuredMail()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailController, animated: true, completion: nil)
        } else {
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let sendMailAler = UIAlertView(title: title,
                                       message: message,
                                       delegate: self, cancelButtonTitle: NSLocalizedString("ok", comment: ""))
        sendMailAler.show()
    }
    
    func configuredMail() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([NSLocalizedString("yellow_support_email", comment: "")])
        mailComposeVC.setSubject(NSLocalizedString("invite_friend_subject", comment: ""))
        mailComposeVC.setMessageBody(NSLocalizedString("invite_friend_content", comment: ""), isHTML: false)
        return mailComposeVC
    }
    
    //MARK: SendFB Messenger and delegate
    func sendFBMessenger() {
        let url = URL(string: NSLocalizedString("app_link", comment: ""))
        let shareContent = LinkShareContent(url: url!)
        do {
            try ShareDialog.show(from: self, content: shareContent)
        } catch _{
         // error
        }
    }
    
    
    
}
