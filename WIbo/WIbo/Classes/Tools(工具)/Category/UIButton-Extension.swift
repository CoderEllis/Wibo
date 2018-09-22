//
//  UIButton-Extension.swift
//  WIbo
//
//  Created by Soul Ai on 22/9/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

extension UIButton{
    // swift中类方法是以class开头的方法.类似于OC中+开头的方法
    class func createButton(imageName : String, bgImageName : String) ->UIButton{
        // 1.创建btn
        let but = UIButton()
        
        // 2.设置btn的属性
        but.setBackgroundImage(UIImage(named: imageName), for: .normal)
        but.setBackgroundImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        but.setImage(UIImage(named: bgImageName), for: .normal)
        but.setImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        but.sizeToFit()
        return but
    }
}
