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
    /*
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
    */
    
    // convenience : 便利,使用convenience修饰的构造函数叫做便利构造函数
    // 遍历构造函数通常用在对系统的类进行构造函数的扩充时使用
    /*
     遍历构造函数的特点
     1.遍历构造函数通常都是写在extension里面
     2.遍历构造函数init前面需要加载convenience
     3.在遍历构造函数中需要明确的调用self.init()
     */
    convenience init (imageName : String, bgImageName : String){
        self.init()
        setBackgroundImage(UIImage(named: imageName), for: .normal)
        setBackgroundImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setImage(UIImage(named: bgImageName), for: .normal)
        setImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
    convenience init(bgColor : UIColor, fontSize : CGFloat, title : String) {
        self.init()
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
    
}
