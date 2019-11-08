
//
//  ContentViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Tuesday, March 28.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import ImageSlideshow
import Photos
import SCLAlertView
import FacebookShare
import MessageUI
import Kingfisher
import ImagePicker
import SVProgressHUD
import MBProgressHUD
import SZTextView

class ContentViewController: UIViewController, YellowNavigagionBarViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, ContentCellRestaurantTitleDelegate, CommentSubViewDelegate, ContentCellUserPostDelegate, ImagePickerDelegate, ContentCellRestaurantAddressDelegate,MFMailComposeViewControllerDelegate {
    @IBOutlet weak var contentMainTableView: UITableView!
    
    // Sitemap data
    var siteMapItem1 : String!
    var siteMapItem2 : String!
    let screenSize = UIScreen.main.bounds
    
    var commentView : CommentSubView!
    var commentContentTextView = SZTextView()
    var isReplyCommentTouch = false
    
    let isAuthorizePhoto = PHPhotoLibrary.authorizationStatus()
    var userDefaults = UserDefaults()
    var storeDetailRespone = StoreDetailResponse()
    var money_unit = ""
    var lstStoreGalleries = [StoreGalleries]()
    var lstStoreServices = [StoreServices]()
    var lstStoreComments = [CommentResponse]()
    var lstStoreCommentsChild = [CommentChildResponse]()
    var storeLocation = Location()
    var currentStoreID = 0
    var numberOf101Cell = 3
    var userLocation = ""
    let imagePicker = ImagePickerController()
    var commentCellHeight = 0
    var mainSiteMap = MainSiteMap()
    var lstCommentPhoto = [UIImage]()
    var tapSliderGesture: UITapGestureRecognizer!
    var slideShow = ImageSlideshow()
    var isReplyComment = false
    var currentCommentParent = 0
    var refreshControl = UIRefreshControl()
    var listCityResponse = [CityResponse]()
    var isScrollToBottom = false
    var searchBar : UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        tapSliderGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnSlider(sender: )))
        MBProgressHUD.showAdded(to: self.view, animated: true)
        setUpSearhBarAndSiteMap()
        setUpNavigationBar()
        setUpData()
        configCommentBar()
        money_unit = NSLocalizedString("money_unit", comment: "")
        pullToRefresh()
        contentMainTableView.rowHeight = UITableViewAutomaticDimension;
        contentMainTableView.estimatedRowHeight = 281; // set to whatever your "average" cell height is

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchBar.text = ""
    }
    
    func pullToRefresh() {
        self.contentMainTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(self.refleshView(sender:)), for: .valueChanged)
        if userDefaults.object(forKey: Common.CITY_LOCATION) != nil {
            userLocation = (userDefaults.object(forKey: Common.CITY_LOCATION) as? String)!
        }
    }
    
    func refleshView(sender: Any) {
        getStoreDetailData(store_id: currentStoreID)
    }
    
    func setUpData() {
        // get all cities and show default by server response
        CityDAO.getAllCities(completeHandle: {(success, data:[CityResponse]?) in
            if success && data != nil {
                self.listCityResponse = data!
            } else {
                print("Get all city failed")
            }
        })
    }
    
    func getStoreDetailData(store_id: Int) {
        currentStoreID = store_id
        // get store detail
        var language = userDefaults.object(forKey: Common.USER_LANGUAGE) as? String
        if language == "vn" {
            language = "vi"
        }
        var lat = ""
        var lng = ""
        if userDefaults.object(forKey: Common.USER_LOCATION_LAT) != nil && userDefaults.object(forKey: Common.USER_LOCATION_LNG) != nil {
            lat = userDefaults.object(forKey: Common.USER_LOCATION_LAT) as! String
            lng = userDefaults.object(forKey: Common.USER_LOCATION_LNG) as! String
        }
        StoreDAO.getStoreDetail(store_id: store_id, language: language!, lat: lat, lng: lng,
                                completeHandle: {(success, data:StoreDetailResponse?)in
                                    self.refreshControl.endRefreshing()
                                    if success && data != nil {
                                        self.storeDetailRespone = data!
                                        self.mainSiteMap.lblItem3.text = self.storeDetailRespone.stores_name
                                        var tmpArray0 = [StoreGalleries]()
                                        var tmpArray1 = [StoreServices]()
                                        var tmpArray2 = [CommentResponse]()
                                        //StoreGalleries
                                        if self.storeDetailRespone.galleries.count > 0 {
                                            for i in 0 ... self.storeDetailRespone.galleries.count - 1 {
                                                tmpArray0.append(self.storeDetailRespone.galleries[i])
                                            }

                                        }
                                        //StoreServices
                                        if self.storeDetailRespone.services.count > 0 {
                                            for i in 0...self.self.storeDetailRespone.services.count - 1 {
                                                tmpArray1.append(self.storeDetailRespone.services[i])
                                            }
                                        }
                                        //CommentResponse
                                        if self.storeDetailRespone.comments.count > 0 {
                                            for i in 0...self.storeDetailRespone.comments.count - 1 {
                                                tmpArray2.append(self.storeDetailRespone.comments[i])
                                            }
                                        }
                                        self.lstStoreGalleries = tmpArray0
                                        self.lstStoreServices = tmpArray1
                                        self.lstStoreComments = tmpArray2
                                        self.storeLocation = Location(lat: self.storeDetailRespone.lat as NSString!,
                                                                      lng: self.storeDetailRespone.lng as NSString!)
                                        self.contentMainTableView.reloadData()
                                        if self.isScrollToBottom {
                                            self.isScrollToBottom = false
                                            self.scrollToBottom()
                                        }
                                    } else {
                                        print("Get store detail failed")
                                    }
        })
    }
    
    func getChildComment(lstCommentParent: [CommentResponse], index: Int) -> [CommentChildResponse]{
        if lstCommentParent.count > 0 {
            if lstCommentParent[index - 1].child.count > 0 {
                return lstCommentParent[index - 1].child
            }
        }
        return [CommentChildResponse]()
    }
    
    func getChildComment1(lstCommentParent: CommentResponse) -> [CommentChildResponse]{
            return lstCommentParent.child
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
        let yellowNavigagionBarView  = UINib(nibName: "YellowNavigagionBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! YellowNavigagionBarView
        yellowNavigagionBarView.frame.origin = CGPoint(x: 0, y: 0)
        yellowNavigagionBarView.frame.size.width = self.view.bounds.width
        yellowNavigagionBarView.yellowDelegate = self
        yellowNavigagionBarView.txtMapName.isHidden = true
        yellowNavigagionBarView.lblNavTitle.isHidden = true
        yellowNavigagionBarView.buttonMenu.setImage(UIImage(named:"back"), for: .normal)
        yellowNavigagionBarView.buttonMap.isHidden = true
        self.view.addSubview(yellowNavigagionBarView)
    }
    
    // MARK: SearchBar
    func setUpSearhBarAndSiteMap()  {
        let header = UIView(frame: CGRect(x: 0, y: 60, width: self.view.bounds.width, height: 70))
        let yellowColor = UIColor.init(red: 241/255, green: 186/255, blue: 17/255, alpha: 1.0)
        //image background
        header.backgroundColor = yellowColor
        // search bar
        searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = NSLocalizedString("user_looking", comment: "")
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        searchBar.barTintColor = yellowColor
        searchBar.backgroundColor = yellowColor
        searchBar.backgroundImage = UIImage(named: "bar_bg")
        header.addSubview(searchBar)
        // sitemap
        mainSiteMap = UINib(nibName: "MainSiteMap", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MainSiteMap
        mainSiteMap.frame = CGRect(x: 0, y: 40, width: screenSize.width, height: 40)
        if siteMapItem1 == NSLocalizedString("search", comment: "") {
            mainSiteMap.lblItem3.isHidden = true
            mainSiteMap.icon2.isHidden = true
            mainSiteMap.lblItem1.text = siteMapItem1
        } else {
            mainSiteMap.lblItem1.text = siteMapItem1
        }
        mainSiteMap.lblItem2.text = siteMapItem2
        header.addSubview(mainSiteMap)
        self.view.addSubview(header)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        // Switch to main from search
        let leftSideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "LeftSideMenuViewController") as! LeftSideMenuViewController
        leftSideMenuViewController.switchAppToMainFromSearch()
        
        let searchResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        searchResultViewController.searchStoreWithKeys(keywords: searchBar.text!, pageNum: 1)
        self.show(searchResultViewController, sender: self)
    }
    
    func buttonMapDidTap() {
    }
    
    func buttonMenuDidTap() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func yellowLogoDidTap() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func makeCall(phoneNumber: String) {
        var phoneNumberTrimmed = phoneNumber.removingWhitespaces()
        phoneNumberTrimmed = phoneNumberTrimmed.replace(target: ".", withString: "")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: "tel://\(phoneNumberTrimmed)")!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: "tel://\(phoneNumberTrimmed)")!)
        }
    }
    
    func buttonPreviousImageSliderDidTap() {
        let cell = getCellAtIndexPath(index: 0)
        cell.imageSlider.setPrevious()
    }
    
    func buttonNextImageSliderDidTouch() {
        let cell = getCellAtIndexPath(index: 0)
        cell.imageSlider.setNext()
    }
    
    func tapOnSlider(sender: UITapGestureRecognizer) {
        slideShow.presentFullScreenController(from: self)
    }
    
    func tapOnCmtImage(sender: UITapGestureRecognizer) {
        let cmtSlideShow = ImageSlideshow()
        let imgView =  sender.view!
        let imageWillShow = imgView as! UIImageView
        print("image: %@", imageWillShow.image!)
        cmtSlideShow.setImageInputs([
            ImageSource(image: imageWillShow.image!)
        ])
        cmtSlideShow.presentFullScreenController(from: self)
    }
    
    //MARK: TABLEVIEW DELEGATE
    func numberOfSections(in tableView: UITableView) -> Int {
        return lstStoreComments.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 9
        } else {
            if lstStoreComments.count > 0 {
                  return 1 + getChildComment1(lstCommentParent: self.lstStoreComments[section - 1]).count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                if screenSize.width == 320 {
                    return 250
                } else if screenSize.width == 375 {
                    return 270
                } else {
                    return 290
                }
            case 1:
                return 5
            case 2:
                return 145
            case 3:
                if self.storeDetailRespone.store_description.isEmpty {
                    return 0
                }
                return UITableViewAutomaticDimension
            case 4:
                if lstStoreGalleries.count  > 0 {
                    return 5
                }
                return 0
            case 5:
                if lstStoreGalleries.count  > 0 {
                    return 100
                }
                return 0
            case 6:
                if lstStoreServices.count > 0 {
                    return 5
                }
                return 0
            case 7:
                if lstStoreServices.count > 0 {
                    return 92
                }
                return 0
            case 8:
                if lstStoreComments.count > 0 {
                    return 5
                }
                return 0
            default:
                return 0;
            }

        } else {
            
//            if self.lstStoreComments.count > 0 {
                return UITableViewAutomaticDimension; //comment parent
//            }
        }
//        return 0
    }
    
    func configCommentBar() {
        commentView = UINib(nibName: "CommentSubView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CommentSubView
        commentView.commentSubViewDelegate = self
        commentView.commentContent.inputAccessoryView = UIView()
        commentView.frame = CGRect(x: 0, y: screenSize.height - 50, width: screenSize.width, height: 50)
        commentView.commentContent.placeholderText = NSLocalizedString("write_comments", comment: "")
        self.view.addSubview(commentView)
    }
    
    // MARK: COMMENT DELEGATE
    func buttonSendDidTap() {
        if !BaseDAO.checkLogin() {
            let initView = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
            self.present(initView, animated: true, completion: nil)
            return
        }
        if commentView.commentContent.text.characters.count == 0 {
            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                     subTitle: NSLocalizedString("error_nil_comment_input", comment: ""))
            return
        }
        print("\(commentView.commentContent.text)")
        if isReplyComment { // REPLY
            isReplyComment = false
            UserDAO.commentStoreWithoutImages(store_id: currentStoreID, parent_comment: currentCommentParent, score: 10, message: commentView.commentContent.text, completeHandle: { (success, data) in
                self.commentView.commentContent.resignFirstResponder()
                if success && data != nil {
                    self.commentView.commentContent.text = ""
                    self.refleshView(sender: Any.self)
                    self.isScrollToBottom = true
                } else {
                    
                }
            })
        } else { // CMT IMAGES
            if lstCommentPhoto.count != 0 {
                UserDAO.commentStore(store_id: "\(currentStoreID)", parent_comment: "0", score: "10", message: commentView.commentContent.text, photo: lstCommentPhoto, completeHandle: { (success, data) in
                    self.commentView.commentContent.resignFirstResponder()
                    if success {
                        SVProgressHUD.dismiss()
                        self.commentView.commentContent.text = ""
                        self.refleshView(sender: Any.self)
                        self.isScrollToBottom = true
                    } else {
                        
                    }
                })
            } else { // CMT WITHOUT IMAGE
                UserDAO.commentStoreWithoutImages(store_id: currentStoreID, parent_comment: 0, score: 10, message: commentView.commentContent.text, completeHandle: { (success, data) in
                    self.commentView.commentContent.resignFirstResponder()
                    if success && data != nil {
                        self.commentView.commentContent.text = ""
                        self.refleshView(sender: Any.self)
                        self.isScrollToBottom = true
                    } else {
                        
                    }
                })
            }
        }
    }
    //MARK: ImagePickerDelegate DELEGATE
    func commentTakePhoto() {
        imagePicker.delegate = self
        imagePicker.imageLimit = 1
        present(imagePicker, animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    var tmpArray = [UIImage]()
    var img = UIImage()
        for i in images {
            img = Common().scaleImageWidth(image: i, targetSize: CGSize(width: 700, height: 700))
            tmpArray.append(img)
        }
        lstCommentPhoto = tmpArray
        imagePicker.dismiss(animated: true, completion: {
            SVProgressHUD.showSuccess(withStatus: NSLocalizedString("image_selected", comment: ""))
        })
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCellRestaurantTitle", for: indexPath) as! ContentCellRestaurantTitle
                cell.selectionStyle = .none
                if self.lstStoreGalleries.count > 0 {
                    cell.imageSlider.addGestureRecognizer(tapSliderGesture)
                    var imageSources = [KingfisherSource]()
                    if self.lstStoreGalleries.count > 4 {
                        for i in 0...4 {
                            imageSources.append(KingfisherSource(urlString: self.lstStoreGalleries[i].img_url)!)
                        }
                    } else {
                        for i in 0...self.lstStoreGalleries.count - 1 {
                            imageSources.append(KingfisherSource(urlString: self.lstStoreGalleries[i].img_url)!)
                        }
                    }
                    slideShow = cell.imageSlider
                    cell.imageSlider.setImageInputs(imageSources)
                }  else {
                    cell.imageSliderHeight.constant = 0
                }
                
                if !storeDetailRespone.lat.isEmpty {
                    cell.imageSlider.contentScaleMode = .scaleToFill
                    cell.imageSlider.slideshowInterval = 0
                    cell.lblPlaceTitle.text = self.storeDetailRespone.stores_name
                    cell.lblPlacePoint.text = "\(self.storeDetailRespone.rating_number)"
                    if storeDetailRespone.is_open == "true" {
                        cell.openTimeStatus.text = NSLocalizedString("open_now", comment: "")
                    } else if storeDetailRespone.is_open == "false" {
                        cell.openTimeStatus.text = NSLocalizedString("closed_now", comment: "")
                    } else {
                        cell.openTimeStatus.text = NSLocalizedString("not_available", comment: "")
                    }
                    cell.openTimeFromTo.text = storeDetailRespone.open_time
                    
                    if (storeDetailRespone.start_price.isEmpty && storeDetailRespone.end_price.isEmpty) || storeDetailRespone.start_price == "0" || storeDetailRespone.end_price == "0"{
                        cell.lblPrice.text = NSLocalizedString("not_available", comment: "")
                    } else if storeDetailRespone.end_price.isEmpty && storeDetailRespone.start_price != "0" {
                        cell.lblPrice.text = "\(storeDetailRespone.start_price)\(money_unit)"
                    } else {
                        cell.lblPrice.text = "\(storeDetailRespone.start_price)\(money_unit) - \(storeDetailRespone.end_price)\(money_unit)"
                    }
                    cell.contentCellRestaurantTitleDelegate = self
                    cell.placePointWrapperView.layer.cornerRadius = cell.placePointWrapperView.bounds.width / 2
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellSeperator", for: indexPath)
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCellRestaurantAddress", for: indexPath) as! ContentCellRestaurantAddress
                cell.selectionStyle = .none
                cell.contentCellRestaurantAddressDelegate = self
                if !storeDetailRespone.stores_name.isEmpty {
                    cell.lblPlaceAddress.text = self.storeDetailRespone.address
                    cell.buttonGetDirection.setTitle(NSLocalizedString("get_direction", comment: ""), for: .normal)
                    if storeDetailRespone.phone_default.count == 0 && storeDetailRespone.fax.isEmpty {
                        cell.lblPhoneNumber.text = NSLocalizedString("not_available", comment: "")
                    } else if storeDetailRespone.phone_default.count == 0 {
                        cell.lblPhoneNumber.text = "\(storeDetailRespone.fax)"
                    } else if storeDetailRespone.fax.isEmpty {
                        if !storeDetailRespone.phone_default[0].number.isEmpty {
                            cell.lblPhoneNumber.text = "\(storeDetailRespone.phone_default[0].number)"
                        } else {
                            cell.lblPhoneNumber.text = NSLocalizedString("not_available", comment: "")
                        }
                        
                    } else {
                        cell.lblPhoneNumber.text = "\(storeDetailRespone.fax) / \(storeDetailRespone.phone_default[0].number)"
                    }
                    cell.shareItem1.setImage(UIImage(named: "facebook"), for: .normal)
                    cell.shareItem2.setImage(UIImage(named: "kakao_talk"), for: .normal)
                    cell.shareItem3.setImage(UIImage(named: "email_share"), for: .normal)
                    cell.shareItem4.isHidden = true
                    cell.shareItem5.isHidden = true
                    cell.shareItem6.isHidden = true
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContentStoreDescriptionCell", for: indexPath) as! ContentStoreDescriptionCell
                cell.selectionStyle = .none
                if !storeDetailRespone.stores_name.isEmpty {
                    cell.storeDescription.text = storeDetailRespone.store_description
                }
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellSeperator1", for: indexPath)
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCellRestaurantImage", for: indexPath) as! ContentCellRestaurantImage
                cell.selectionStyle = .none
                cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row - 2)
                return cell
            case 6:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellSeperator2", for: indexPath)
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
                return cell
            case 7:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCellRestaurantServices", for: indexPath) as! ContentCellRestaurantServices
                cell.selectionStyle = .none
                cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row - 3)
                return cell
            case 8:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellSeperator3", for: indexPath)
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
                return cell
            default:
                break
            }
        } else {
            // section != 0 return cell comment
            if indexPath.row == 0 { // comment parent
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCellUserPost", for: indexPath) as! ContentCellUserPost
                cell.selectionStyle = .none
                if lstStoreComments.count > 0 {
                    cell.userAvatar.layer.cornerRadius = cell.userAvatar.bounds.width / 2
                    cell.userAvatar.layer.masksToBounds = true
                    if  !lstStoreComments[indexPath.section - 1].commentBy.avatar.isEmpty {
                        let url = URL(string: lstStoreComments[indexPath.section - 1].commentBy.avatar)
                        cell.userAvatar.kf.setImage(with: url, placeholder: UIImage(named: "user_default_icon"), options:nil, progressBlock: nil, completionHandler: nil)
                    } else {
                        cell.userAvatar.image = UIImage(named: "user_default_icon")
                    }
                    if !lstStoreComments[indexPath.section - 1].commentBy.username.isEmpty {
                        cell.userName.text = lstStoreComments[indexPath.section - 1].commentBy.username
                    } else {
                        cell.userName.text = NSLocalizedString("your_username", comment: "")
                    }
                    cell.userPoint.text = "\(lstStoreComments[indexPath.section - 1].rating_score)"
                    cell.userLocation.text = self.getCityWithCityID(cityID: lstStoreComments[indexPath.section - 1].commentBy.city)
                    cell.postDate.text = convertUTCToLocal(dateString: lstStoreComments[indexPath.section - 1].createdAt)
                    if  !lstStoreComments[indexPath.section - 1].img_url.isEmpty {
                        cell.postImageHeightConstraint.constant = 171
                        var tapCommentImage = UITapGestureRecognizer()
                        tapCommentImage = UITapGestureRecognizer(target: self, action: #selector(tapOnCmtImage(sender: )))
                        cell.postImage.addGestureRecognizer(tapCommentImage)
                        cell.postImage.layer.masksToBounds = true
                        cell.postImage.layer.cornerRadius = 5
                        let url = URL(string: lstStoreComments[indexPath.section - 1].img_url)
                        cell.postImage.kf.setImage(with: url, placeholder: UIImage(named: "store_image"), options:nil, progressBlock: nil, completionHandler: nil)
                    } else if indexPath.section != 0 && lstStoreComments[indexPath.section - 1].img_url.isEmpty{
                        cell.postImageHeightConstraint.constant = 0
                        print("section: \(indexPath.section) indexpath: \(indexPath.row)")
                    }
                    cell.postImage.layer.masksToBounds = true
                    cell.postImage.layer.cornerRadius = 3
                    cell.postContent.text = lstStoreComments[indexPath.section - 1].comment_content
                    cell.userPointWrapperView.layer.cornerRadius = cell.userPointWrapperView.frame.width / 2
                    cell.postContent.textColor = UIColor.init(red: 79/255, green: 79/255, blue: 79/255, alpha: 1.0)
                    cell.postContent.font = UIFont.systemFont(ofSize: 15)
                    cell.contentCellUserPostDelegate = self
                    cell.replyButton.tag = indexPath.section - 1
                }
                return cell
            }
            // child comment
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCommentTableViewCell", for: indexPath) as! ReplyCommentTableViewCell
            cell.selectionStyle = .none
            if lstStoreComments.count > 0 {
                if lstStoreComments[indexPath.section - 1].child.count > 0 {
                    cell.userAvatar.layer.cornerRadius = cell.userAvatar.bounds.width / 2
                    cell.userAvatar.layer.masksToBounds = true
                    if !getChildComment1(lstCommentParent: self.lstStoreComments[indexPath.section - 1])[indexPath.row - 1].commentBy.avatar.isEmpty  {
                        cell.userAvatar.kf.setImage(with: URL(string: getChildComment1(lstCommentParent: self.lstStoreComments[indexPath.section - 1])[indexPath.row - 1].commentBy.avatar), placeholder: UIImage(named: "user_default_icon"), options:nil, progressBlock: nil, completionHandler: nil)
                    } else {
                        cell.userAvatar.image = UIImage(named: "user_default_icon")
                    }
                    // comment by
                    if !getChildComment1(lstCommentParent: self.lstStoreComments[indexPath.section - 1])[indexPath.row - 1].commentBy.username.isEmpty {
                        cell.userName.text = getChildComment1(lstCommentParent: self.lstStoreComments[indexPath.section - 1])[indexPath.row - 1].commentBy.username
                    } else {
                        cell.userName.text = NSLocalizedString("your_username", comment: "")
                    }
                    cell.location.text = self.getCityWithCityID(cityID: self.lstStoreComments[indexPath.section - 1].commentBy.city)
                    // username
                    if !self.lstStoreComments[indexPath.section - 1].commentBy.username.isEmpty {
                        cell.replyFrom.setTitle("\(NSLocalizedString("in_reply_to", comment: "")) \(self.lstStoreComments[indexPath.section - 1].commentBy.username)", for: .normal)
                    } else {
                        cell.replyFrom.setTitle("\(NSLocalizedString("in_reply_to", comment: "")) \(NSLocalizedString("your_username", comment: ""))", for: .normal)
                    }
                    cell.replyContent.text = getChildComment1(lstCommentParent: self.lstStoreComments[indexPath.section - 1])[indexPath.row - 1].comment_content
                    }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: Delegate reply comment
    func replyComment(tag: Int){
        isReplyComment = true
        currentCommentParent = lstStoreComments[tag].id
        commentView.commentContent.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.commentView.commentContent.resignFirstResponder()
        if indexPath.section == 0 && indexPath.row == 2 {
            getDirection()
        }
    }
    //MARK: Delegate ContentCellRestaurantAddress
    func getDirection() {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "GetDirectionViewController") as! GetDirectionViewController
        // location
        if storeLocation.lat == nil || storeLocation.lat == nil {
            SVProgressHUD.showError(withStatus: NSLocalizedString("location_not_found", comment: ""))
        } else {
            view.destinationLocation = CLLocationCoordinate2D(latitude: storeLocation.lat.doubleValue, longitude: storeLocation.lng.doubleValue)
            view.storeName = self.storeDetailRespone.stores_name
            view.placeAddress = self.storeDetailRespone.address
            self.show(view, sender: self)
        }
    }
    
    func buttonCallStorePressed() {
        let alert = SCLAlertView()
        var lstPhoneCall = [String]()
        if storeDetailRespone.phone_default.count > 0 {
            for i in 0...storeDetailRespone.phone_default.count - 1 {
                if !storeDetailRespone.phone_default[i].number.isEmpty {
                    lstPhoneCall.append(storeDetailRespone.phone_default[i].number)
                } else {
                    SVProgressHUD.showError(withStatus: NSLocalizedString("not_available", comment: "" ))
                    return
                }
            }
            if lstPhoneCall.count > 0 {
                if lstPhoneCall.count == 1 {
                    self.makeCall(phoneNumber: lstPhoneCall[0])
                    return
                }
                for i in 0...lstPhoneCall.count - 1 {
                    alert.addButton(lstPhoneCall[i], action: {
                        self.makeCall(phoneNumber: lstPhoneCall[i])
                    })
                }
                alert.showWarning(NSLocalizedString("select_phone_number", comment: "" ), subTitle: "")
            }
        } else {
            // no phone call
            SVProgressHUD.showError(withStatus: NSLocalizedString("not_available", comment: "" ))
        }
    }
    // DB
    func shareItem1() {
        //MARK: SendFB Messenger and delegate
            let url = URL(string: NSLocalizedString("app_link", comment: ""))
            let shareContent = LinkShareContent(url: url!)
            do {
                try ShareDialog.show(from: self, content: shareContent)
            } catch _{
                // error
            }
    }
    // KK
    func shareItem2() {
        SVProgressHUD.showError(withStatus: NSLocalizedString("not_available", comment: "" ))
    }
    //EMAIL
    //MARK: SendEmail and delegate
    func shareItem3() {
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
        mailComposeVC.setSubject(NSLocalizedString("sharing", comment: ""))
        mailComposeVC.setMessageBody(NSLocalizedString("invite_friend_content", comment: ""), isHTML: false)
        return mailComposeVC
    }

    func getCellAtIndexPath(index : Int) -> ContentCellRestaurantTitle
    {
        let indexPath = IndexPath(item: index, section: 0)
        let cell =  self.contentMainTableView.cellForRow(at: indexPath)
        return cell as! ContentCellRestaurantTitle
    }
    
    func getCommentParentAtIndexPath(index : Int, section: Int) -> ContentCellUserPost
    {
        let indexPath = IndexPath(item: index, section: section)
        let cell =  self.contentMainTableView.cellForRow(at: indexPath)
        return cell as! ContentCellUserPost
    }
    
    // convert UTC lo local
    func convertUTCToLocal(dateString: String) -> String {
        // create dateFormatter with UTC time format
        let dateFormatUTC =  DateFormatter()
        dateFormatUTC.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFormatUTC.locale = Locale(identifier: "en_US_POSIX")
        dateFormatUTC.calendar = Calendar(identifier: .iso8601)
        dateFormatUTC.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatUTC.date(from: dateString)!
        // convert UTC To local date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d"
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
    }
    // get user city location
    func getCityWithCityID(cityID: Int) -> String{
        for i in listCityResponse {
            if cityID == i.id {
                return i.city_name
            }
        }
        return ""
    }
    // scroll to bottom 
    func scrollToBottom() {
        let lastCellIndex = IndexPath(item: lstStoreComments[lstStoreComments.count - 1].child.count, section: lstStoreComments.count)
        self.contentMainTableView.scrollToRow(at: lastCellIndex, at: .bottom, animated: true)
    }
    
}

// MARK: COLLECTIONVIEW DELEGATE EXTENSION
extension ContentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 101 {
            if lstStoreGalleries.count > numberOf101Cell {
                return numberOf101Cell + 1
            }
            return lstStoreGalleries.count + 1
        }
        return lstStoreServices.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var count = 0
        if collectionView.tag == 101 {
            if indexPath.row == numberOf101Cell {
                let cellMore = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantImageCellMore", for: indexPath) as! RestaurantImageCellMore
                if lstStoreGalleries.count > numberOf101Cell {
                    cellMore.restaurantImageTransparent.kf.setImage(with: URL(string: lstStoreGalleries[numberOf101Cell].img_url))
                    cellMore.restaurantImageTransparent.image? = (cellMore.restaurantImageTransparent.image?.alpha(0.7))!
                    cellMore.lblImageRemains.text = "\(lstStoreGalleries.count - numberOf101Cell)+"
                } else {
                    cellMore.isHidden = true
                }
                return cellMore
            } else {
                let cellData = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantImageCellData", for: indexPath) as! RestaurantImageCellData
                if lstStoreGalleries.count > numberOf101Cell {
                    if count <  numberOf101Cell {
                        count = count + 1
                        cellData.restaurantImage.kf.setImage(with: URL(string: lstStoreGalleries[indexPath.row].img_url))
                    }
                    return cellData
                } else if lstStoreGalleries.count > 0 {
                    if lstStoreGalleries.count > indexPath.row {
                        cellData.restaurantImage.kf.setImage(with: URL(string: lstStoreGalleries[indexPath.row].img_url))
                    }
                }
                return cellData
            }
        } else {
            if indexPath.row == lstStoreServices.count {
                let cellMore = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantServicesCellMore", for: indexPath) as! RestaurantServicesCellMore
                if lstStoreServices.count > 5 {
                    cellMore.numberOfServiceMore.text = "\(lstStoreServices.count - 5)+"
                } else {
                    cellMore.isHidden = true
                }
                return cellMore
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantServicesCell", for: indexPath) as! RestaurantServicesCell
                if lstStoreServices.count > 0 {
                    cell.serviceImage.kf.setImage(with: URL(string: lstStoreServices[indexPath.row].service_items_ico))
                    cell.serviceName.text = lstStoreServices[indexPath.row].service_items_name
                }
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // show full
        if indexPath.row == numberOf101Cell && collectionView.tag == 101 {
            numberOf101Cell = lstStoreGalleries.count
            self.contentMainTableView.reloadData()
        } else if collectionView.tag == 101 {
            let galleriesView = self.storyboard?.instantiateViewController(withIdentifier: "StoreGalleriesViewController") as! StoreGalleriesViewController
            galleriesView.lstStoreGalleries = self.lstStoreGalleries
            galleriesView.storeName = self.storeDetailRespone.stores_name
            self.show(galleriesView, sender: self)
        } else {
        
        }
    }
    
    
}
