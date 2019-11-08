//
//  SearchResultViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Friday, March 24.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SVProgressHUD
import SVPullToRefresh
class SearchResultViewController: UIViewController, YellowNavigagionBarViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchResultTableView: UITableView!
    var searchKeyWord = ""
    var lstStoresResults = [BaseStoreResponse]()
    var userDefaults = UserDefaults()
    var currentPage = 1
    var home : HomeViewController! = nil
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        home = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        pullToRefresh()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
        let yellowNavigagionBarView  = UINib(nibName: "YellowNavigagionBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! YellowNavigagionBarView
        yellowNavigagionBarView.frame.origin = CGPoint(x: 0, y: 0)
        yellowNavigagionBarView.frame.size.width = self.view.bounds.width
        yellowNavigagionBarView.yellowDelegate = self
        // Custom for account setting
        yellowNavigagionBarView.imageYellow.isHidden = true
        yellowNavigagionBarView.txtMapName.isHidden = true
        yellowNavigagionBarView.lblNavTitle.isHidden = false
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("search_result", comment: "")
        yellowNavigagionBarView.buttonMenu.setImage(UIImage(named:"back"), for: .normal)
        yellowNavigagionBarView.buttonMap.isHidden = true
        self.view.addSubview(yellowNavigagionBarView)
    }
    
    func searchStoreWithKeys(keywords: String, pageNum: Int) {
        SVProgressHUD.show(withStatus: NSLocalizedString("searching", comment: ""))
        searchKeyWord = keywords
        var lat = ""
        var lng = ""
        if userDefaults.object(forKey: Common.USER_LOCATION_LAT) != nil && userDefaults.object(forKey: Common.USER_LOCATION_LNG) != nil {
            lat = (userDefaults.object(forKey: Common.USER_LOCATION_LAT) as? String)!
            lng = (userDefaults.object(forKey: Common.USER_LOCATION_LNG) as? String)!
        }
        let language = userDefaults.object(forKey: Common.USER_LANGUAGE) as? String
        let distance = "5000"
        let cityID = userDefaults.object(forKey: Common.CITY_LOCATION_ID) as? Int
        StoreDAO.searchStore(city_id: cityID!, lat: lat, lng: lng, distance: distance,
                             keywords: keywords, paged: pageNum, language: language!,
                             completeHandle: {(success, data:WrapperBaseStoreResponse? )in
                                self.refreshControl.endRefreshing()
                                if success && data != nil {
                                    if (data?.records.count)! > 0 {
                                        self.lstStoresResults = (data?.records)!
                                        self.searchResultTableView.reloadData()
                                    } else {
                                        SVProgressHUD.showError(withStatus: NSLocalizedString("search_not_found", comment: ""))
                                    }
                                    self.setUpHeaderWithResult(total: (data?.total)!)
                                    print("searchStoreWithKeys: \(keywords), result: \(self.lstStoresResults.count)items")
                                } else {
                                    print("searchStoreWithKeys failed")
                                }
        })
    }
    func pullToRefresh() {
        refreshControl.addTarget(self, action: #selector(self.refleshView(sender:)), for: .valueChanged)
        self.searchResultTableView.addSubview(refreshControl)
        
        let pull = SVPullToRefreshView()
        pull.activityIndicatorViewStyle = .gray
        self.searchResultTableView.addInfiniteScrolling(actionHandler: {
            self.loadMore(sender: Any.self)
        })
        
    }
    
    func loadMore(sender: Any)  {
        currentPage = currentPage + 1
        var lat = ""
        var lng = ""
        if userDefaults.object(forKey: Common.USER_LOCATION_LAT) != nil && userDefaults.object(forKey: Common.USER_LOCATION_LNG) != nil {
            lat = (userDefaults.object(forKey: Common.USER_LOCATION_LAT) as? String)!
            lng = (userDefaults.object(forKey: Common.USER_LOCATION_LNG) as? String)!
        }
        var language = userDefaults.object(forKey: Common.USER_LANGUAGE) as? String
        let distance = "5000" //HARDCODE
        let cityID = userDefaults.object(forKey: Common.CITY_LOCATION_ID) as? Int
        if language == "vn" {
            language = "vi"
        }
        self.searchResultTableView.infiniteScrollingView.startAnimating()
        StoreDAO.searchStore(city_id: cityID!, lat: lat, lng: lng, distance: distance,
                             keywords: searchKeyWord, paged: currentPage, language: language!,
                             completeHandle: {(success, data:WrapperBaseStoreResponse? )in
                                if success && data != nil {
                                    if data?.records.count != 0 {
                                        for i in 0...(data?.records.count)! - 1 {
                                            self.lstStoresResults.append((data?.records[i])!)
                                        }
                                    } else {
                                        SVProgressHUD.showError(withStatus: NSLocalizedString("not_more_data", comment: ""))
                                    }
                                    self.searchResultTableView.reloadData()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                        self.searchResultTableView.infiniteScrollingView.stopAnimating()
                                    })
                                    print("searchStoreWithKeys: \(self.searchKeyWord), result: \(self.lstStoresResults.count)items")
                                } else {
                                    print("searchStoreWithKeys failed")
                                }
        })
    }
    
    func refleshView(sender: Any)  {
        searchStoreWithKeys(keywords: searchKeyWord, pageNum: 1)
    }

    // MARK: SearchBar and Result number
    func setUpHeaderWithResult(total: String) {
        let header = UIView(frame: CGRect(x: 0, y: 60, width: self.view.bounds.width, height: 70))
        let yellowColor = UIColor.init(red: 241/255, green: 186/255, blue: 17/255, alpha: 1.0)
        header.backgroundColor = yellowColor
        // search bar
        let searchBar : UISearchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.text = searchKeyWord
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        searchBar.barTintColor = yellowColor
        searchBar.backgroundColor = yellowColor
        searchBar.backgroundImage = UIImage(named: "bar_bg")
        header.addSubview(searchBar)
        // Result
        let lblSearchResult = UILabel(frame: CGRect(x: 10, y: 45, width: 150, height: 20))
        lblSearchResult.textColor = UIColor.init(red: 11/255, green: 9/255, blue: 15/255, alpha: 1.0)
        lblSearchResult.text = "\(total) \(NSLocalizedString("results", comment: ""))"
        header.addSubview(lblSearchResult)
        self.view.addSubview(header)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchStoreWithKeys(keywords: searchBar.text!, pageNum: 1)
    }
    
    func buttonMapDidTap() {
    }
    
    func buttonMenuDidTap() {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    func yellowLogoDidTap() {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstStoresResults.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if lstStoresResults.count > 0 && tableView.numberOfRows(inSection: 0) == lstStoresResults.count {
                SVProgressHUD.dismiss()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! FoodPlacesTableViewCell
        cell.selectionStyle = .none
        if lstStoresResults.count > 0 {
            cell.foodPlaceImage.kf.setImage(with: URL(string: lstStoresResults[indexPath.row].logo), placeholder: UIImage(named: "store_image"), options:nil, progressBlock: nil, completionHandler: nil)
            cell.foodPlaceImage.layer.cornerRadius = 3
            cell.foodPlaceImage.layer.masksToBounds = true
            cell.foodPlaceTitle.text = lstStoresResults[indexPath.row].stores_name
            cell.foodPlaceAddress.text = lstStoresResults[indexPath.row].address
            cell.foodPlacePointMark.text = "\(lstStoresResults[indexPath.row].rating_number)"
            cell.foodPlaceDistance.text = "\(lstStoresResults[indexPath.row].distance)"
            cell.foodPlacePointView.layer.masksToBounds = true
            cell.foodPlacePointView.layer.cornerRadius = cell.foodPlacePointView.bounds.width / 2
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        contentViewController.siteMapItem1 = NSLocalizedString("search", comment: "")
        contentViewController.siteMapItem2 = self.lstStoresResults[indexPath.row].stores_name
        contentViewController.getStoreDetailData(store_id: self.lstStoresResults[indexPath.row].id)
        self.show(contentViewController, sender: self)
    }

}
