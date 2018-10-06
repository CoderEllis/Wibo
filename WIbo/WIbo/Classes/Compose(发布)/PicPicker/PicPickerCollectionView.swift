//
//  PicPickerCollectionView.swift
//  WIbo
//
//  Created by Soul Ai on 5/10/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

fileprivate let picPickerCell = "picPickerCell"
fileprivate let edgeMargin: CGFloat = 15

class PicPickerCollectionView: UICollectionView {
    // MARK:- 定义属性
    var images : [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    
    
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置collectionView的layou
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = edgeMargin //最少间距
        layout.minimumLineSpacing = edgeMargin  //最少行距
        
         // 设置collectionView的属性  注册 cell "\(PicPickerViewCell.self)"
        register(UINib(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
//        register(UICollectionViewCell.self, forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
         
        // 设置collectionView的内边距
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
    }
}

extension PicPickerCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicPickerViewCell
        
        // 2.给cell设置数据
//        cell.backgroundColor = UIColor.lightGray
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        return cell
    }
}
