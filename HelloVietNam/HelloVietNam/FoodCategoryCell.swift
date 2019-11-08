//
//  FoodCategoryCell.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Thursday, March 23.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit

class FoodCategoryCell: UITableViewCell {
    @IBOutlet weak var foodCategoryCollectionView: UICollectionView!

}

extension FoodCategoryCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        foodCategoryCollectionView.delegate = dataSourceDelegate
        foodCategoryCollectionView.dataSource = dataSourceDelegate
        foodCategoryCollectionView.tag = 111
        foodCategoryCollectionView.setContentOffset(foodCategoryCollectionView.contentOffset, animated:false)
        foodCategoryCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { foodCategoryCollectionView.contentOffset.x = newValue }
        get { return foodCategoryCollectionView.contentOffset.x }
    }
}
