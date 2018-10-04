//
//  PicCollectionView.swift
//  WIbo
//
//  Created by Soul Ai on 3/10/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

class PicCollectionView: UICollectionView {
    // MARK:- 定义属性
    var picURLs : [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    

    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
    }

}

// MARK:- collectionView的数据源方法
extension PicCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.获取cell  注册 Identifier 标识
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell  //默认取的是普通的 cell    强转自己的 cell
        
        // 2.给cell设置数据
        cell.picURL = picURLs[indexPath.item]
    
        return cell
    }
}


class PicCollectionViewCell : UICollectionViewCell {
    // MARK:- 定义模型属性
    var picURL : URL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            
            iconView.sd_setImage(with: picURL , placeholderImage: UIImage (named: "empty_picture"))
        }
    }
    // MARK:- 控件的属性
    @IBOutlet weak var iconView: UIImageView!
    
}
