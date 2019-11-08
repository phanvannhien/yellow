//
//  SelectCityViewController.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/4/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SCLAlertView
import MBProgressHUD
protocol SelectCityViewControllerDelegate {
    func closeSelectCity()
    func doneSelectCity(cityName: String)
}
class SelectCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate{
    @IBOutlet weak var topWrapperView: UIView!
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityTableView: UITableView!
    var selectCityDelegate : SelectCityViewControllerDelegate!
    var cityName = ""
    var lstCity = [String]()
    var cityFilter = [String]()
    var searchController : UISearchController!
    var shouldShowSearchResults = false
    // Sortby
    var isSortBy = false
    var lstSortConditionTitle = [String]()
    var lstSortConditionImg = [String]()
    var currentCity = ""
    var currentSortBy = ""
    var userDefaults = UserDefaults()
    let screenSize = UIScreen.main.bounds

    var lstCityResponse = [CityResponse]()

    override func viewDidLoad() {
        super.viewDidLoad()
            setUpData()
            configSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isSortBy {
            cityTableView.register(UINib(nibName: "SortByTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
            if userDefaults.object(forKey: Common.SORT_BY) != nil {
                currentSortBy = (userDefaults.object(forKey: Common.SORT_BY) as? String)!
            }
        } else {
            if userDefaults.object(forKey: Common.CITY_LOCATION) != nil {
                currentCity = (userDefaults.object(forKey: Common.CITY_LOCATION) as? String)!
            }
            cityTableView.register(UINib(nibName: "SelectCityTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        }
    }
    func setUpData()  {
        buttonDone.setTitle(NSLocalizedString("done", comment: ""), for: .normal)
        buttonClose.setTitle(NSLocalizedString("close", comment: ""), for: .normal)
        
        lstSortConditionTitle.append("DISTANCE")
        lstSortConditionTitle.append("PRICE")
        lstSortConditionTitle.append("SERVICES")
        lstSortConditionTitle.append("FOOD QUALITY")

        lstSortConditionImg.append("sort_by")
        lstSortConditionImg.append("sort_by")
        lstSortConditionImg.append("sort_by")
        lstSortConditionImg.append("sort_by")
    }
    
    // MARK SEARCH BAR
    func configSearch() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = NSLocalizedString("search_city_name", comment: "")
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
//        cityTableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
//        cityTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        cityTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            cityTableView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        cityFilter = lstCity.filter({(city) -> Bool in
            let cityText:NSString = city as NSString
            return (cityText.range(of: searchString!,
                    options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        cityTableView.reloadData()
        print("ToaNT1:cityFilter \(cityFilter.count)")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBAction func buttonCloseDidTouch(_ sender: Any) {
        selectCityDelegate.closeSelectCity()
    }

    @IBAction func buttonDoneDidTouch(_ sender: Any) {
        if !isSortBy {
            if cityName == "" {
                cityName = (userDefaults.object(forKey: Common.CITY_LOCATION) as? String)!
            }
        } else {
            cityName = currentSortBy
        }
        selectCityDelegate.doneSelectCity(cityName:cityName)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !isSortBy {
            return 0
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let citySearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        citySearchBar.placeholder = NSLocalizedString("search_city_name", comment: "")
        headerView.addSubview(citySearchBar)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSortBy {
            return lstSortConditionTitle.count
        } else {
            if shouldShowSearchResults {
                return cityFilter.count
            } else {
                return lstCity.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSortBy {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SortByTableViewCell
            cell.sortConditionImg.image = UIImage(named: lstSortConditionImg[indexPath.row])
            cell.sortConditionTitle.text = lstSortConditionTitle[indexPath.row]
            if cell.sortConditionTitle.text == currentSortBy {
                cell.check_mark.isHidden = false
            } else {
                cell.check_mark.isHidden = true
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectCityTableViewCell
            if shouldShowSearchResults {
                cell.cityName.text = cityFilter[indexPath.row]
            } else {
                cell.cityName.text = lstCity[indexPath.row]
            }
            if cell.cityName.text == currentCity {
                cell.checkMark.isHidden = false
            } else {
                cell.checkMark.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        if isSortBy {
            let cell = getCellSortAtIndexPath(index: indexPath.row)
            cityName = cell.sortConditionTitle.text!
            userDefaults.set(cell.sortConditionTitle.text, forKey: Common.SORT_BY)
            currentSortBy  = (userDefaults.object(forKey: Common.SORT_BY) as? String)!
        } else {
            changeCityAtIndex(index: indexPath.row)
        }
        tableView.reloadData()
    }
    // Change city
    func changeCityAtIndex(index: Int) {
        let common = Common()
        if !common.checkNetworkConnect() {
            SCLAlertView().showError(NSLocalizedString("error", comment: ""),
                                     subTitle: NSLocalizedString("error_network", comment: ""))
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let userID = userDefaults.object(forKey: Common.USER_ID) as? String
        let city_id = self.lstCityResponse[index].id
        UserDAO.changeCity(user_id: userID!, city_id: "\(city_id)", completeHandle: {success in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success {
                self.userDefaults.set(self.lstCityResponse[index].city_name, forKey: Common.CITY_LOCATION)
                self.userDefaults.set(self.lstCityResponse[index].lat, forKey: Common.USER_LOCATION_LAT)
                self.userDefaults.set(self.lstCityResponse[index].lng, forKey: Common.USER_LOCATION_LNG)
                self.userDefaults.set(self.lstCityResponse[index].id, forKey: Common.CITY_LOCATION_ID)
                self.currentCity  = self.lstCityResponse[index].city_name
                self.cityName = self.currentCity
                self.cityTableView.reloadData()
            }
        })
    }
    
    func getCellAtIndexPath(index : Int) -> SelectCityTableViewCell
    {
        let indexPath = IndexPath(item: index, section: 0)
        let cell =  self.cityTableView.cellForRow(at: indexPath)
        return cell as! SelectCityTableViewCell
    }
    
    func getCellSortAtIndexPath(index : Int) -> SortByTableViewCell
    {
        let indexPath = IndexPath(item: index, section: 0)
        let cell =  self.cityTableView.cellForRow(at: indexPath)
        return cell as! SortByTableViewCell
    }
    
}
