//
//  RestaurantCellServices.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Wednesday, March 29.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit

class ContentCellRestaurantServices: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
}

extension ContentCellRestaurantServices {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = 102
        collectionView.setContentOffset(collectionView.contentOffset, animated:false)
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
}
