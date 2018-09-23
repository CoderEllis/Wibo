//
//  UIBarButtonItem-Extension.swift
//  WIbo
//
//  Created by Soul Ai on 23/9/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
//    convenience init(imageName : String) {//方法 1
//        self.init()
//        let bth = UIButton()
//        bth.setImage(UIImage (named: imageName), for: .normal)
//        bth.setImage(UIImage (named: imageName + "_highlighted"), for: .highlighted)
//        bth.sizeToFit()
//        self.customView = bth
    
    convenience  init(imageName : String) {//方法 2
        let bth = UIButton()
        bth.setImage(UIImage (named: imageName), for: .normal)
        bth.setImage(UIImage (named: imageName + "_highlighted"), for: .highlighted)
        bth.sizeToFit()
        
        self.init(customView: bth)
    }
    
}
