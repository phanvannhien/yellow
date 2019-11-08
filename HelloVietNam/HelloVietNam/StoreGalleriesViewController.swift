//
//  StoreGalleriesViewController.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/28/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import Kingfisher
import ImageSlideshow

class StoreGalleriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, YellowNavigagionBarViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var storeGalleriesCollectionView: UICollectionView!
    var lstStoreGalleries = [StoreGalleries]()
    var storeName = ""
    let screenSize = UIScreen.main.bounds
    var slideShow = ImageSlideshow ()
    var yellowNavigagionBarView = YellowNavigagionBarView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if lstStoreGalleries.count > 0 {
            var imageSources = [KingfisherSource]()
            for i in 0...self.lstStoreGalleries.count - 1 {
                imageSources.append(KingfisherSource(urlString: self.lstStoreGalleries[i].img_url)!)
            }
            slideShow.setImageInputs(imageSources)
        }
    }
    
    // MARK: - Navigation
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
        yellowNavigagionBarView  = UINib(nibName: "YellowNavigagionBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! YellowNavigagionBarView
        yellowNavigagionBarView.frame.origin = CGPoint(x: 0, y: 0)
        yellowNavigagionBarView.frame.size.width = self.view.bounds.width
        yellowNavigagionBarView.yellowDelegate = self
        // Custom for account setting
        yellowNavigagionBarView.imageYellow.isHidden = true
        yellowNavigagionBarView.txtMapName.isHidden = true
        yellowNavigagionBarView.lblNavTitle.isHidden = false
        yellowNavigagionBarView.lblNavTitle.text = storeName
        yellowNavigagionBarView.buttonMap.isHidden = true
        yellowNavigagionBarView.buttonMenu.setImage(UIImage(named:"back"), for: .normal)
        self.view.addSubview(yellowNavigagionBarView)
    }
    
    func buttonMapDidTap() {
    }
    
    func buttonMenuDidTap() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func yellowLogoDidTap() {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenSize.width / 3 - 3), height: (screenSize.width / 3 - 3))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstStoreGalleries.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreGalleriesCollectionViewCell", for: indexPath) as! StoreGalleriesCollectionViewCell
        if lstStoreGalleries.count > 0 {
            cell.storeImage.kf.setImage(with: URL(string: lstStoreGalleries[indexPath.row].img_url))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        slideShow.presentFullScreenControllerWithIndex(from: self, index: indexPath.row)
    }
}
