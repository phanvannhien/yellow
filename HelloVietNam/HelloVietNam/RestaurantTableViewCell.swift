//
//  RestaurantTableViewCell.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Thursday, March 23.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet weak var restaurantTableView: UICollectionView!
    
}

extension RestaurantTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        restaurantTableView.delegate = dataSourceDelegate
        restaurantTableView.dataSource = dataSourceDelegate
        restaurantTableView.tag = 333
        restaurantTableView.setContentOffset(restaurantTableView.contentOffset, animated:false)
        restaurantTableView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { restaurantTableView.contentOffset.x = newValue }
        get { return restaurantTableView.contentOffset.x }
    }
}
