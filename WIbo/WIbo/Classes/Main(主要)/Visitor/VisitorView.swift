//
//  VisitorView.swift
//  WIbo
//
//  Created by Soul Ai on 23/9/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

class VisitorView: UIView {

 // MARK:- 提供快速通过xib创建的类方法
    class func visitorView() -> VisitorView{
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)? .first as! VisitorView
    }
   
    //MARK:- 控件属性
    
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBth: UIButton!
    @IBOutlet weak var loginBth: UIButton!
    
    
    // MARK:- 自定义函数
    func setupVisitorViewInfo(iconName : String, title : String){
        iconView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotationView .isHidden = true
    }
    
    func addRotationAnim(){
        //创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画的属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 5
        rotationAnim.isRemovedOnCompletion = false
        
        // 3.将动画添加到layer中
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
}
