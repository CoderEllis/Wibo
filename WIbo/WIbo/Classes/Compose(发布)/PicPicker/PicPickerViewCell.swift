//
//  PicPickerViewCellCollectionViewCell.swift
//  WIbo
//
//  Created by Soul Ai on 5/10/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {
    // MARK:- 控件的属性
    @IBOutlet weak var addPhotoBth: UIButton!
    @IBOutlet weak var removePhotoBth: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    // MARK:- 定义属性
    var image : UIImage? {
        didSet {
            if image != nil {
                imageView.image = image
                addPhotoBth.isUserInteractionEnabled = false  //用户交互 取消
                removePhotoBth.isHidden = false
            }else {
                imageView.image = nil
                addPhotoBth.isUserInteractionEnabled = true
                removePhotoBth.isHidden = true
            }
        }
    }
    
     
    // MARK:- 事件监听
    @IBAction func addPhotoChick() {// 多重传递 用通知 Notification
        NotificationCenter.default.post(name: NSNotification.Name(PicPickerAddPhotoNote), object: nil)
    }
    
    @IBAction func removePhotoCkick() {
        NotificationCenter.default.post(name: NSNotification.Name(PicPickerRemovePhotoNote), object: imageView.image)
        
    }
    
}
