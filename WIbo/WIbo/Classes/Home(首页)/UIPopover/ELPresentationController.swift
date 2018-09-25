//
//  ELPresentationController.swift
//  WIbo
//
//  Created by Soul Ai on 24/9/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

class ELPresentationController: UIPresentationController {
    // MARK:- 对外提供属性
    var presentedFrame : CGRect = CGRect.zero
    
    // MARK:- 懒加载属性
    private lazy var coverView : UIView = UIView()
    
    // MARK:- 系统回调函数
    override func containerViewWillLayoutSubviews(){
        super.containerViewWillLayoutSubviews()
        
        // 1.设置弹出View的尺寸
        presentedView?.frame = presentedFrame
        
        // 2.添加蒙版
        setupCoverView()
    }

}

// MARK:- 设置UI界面相关
extension ELPresentationController{
    private func setupCoverView(){
        // 1.添加蒙版
        containerView?.insertSubview(coverView, at: 0)
        // 2.设置蒙版的属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        
        // 3.添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(coverViewClick))
        coverView.addGestureRecognizer(tapGes)
    }
}

//MARK:- 事件监听
extension ELPresentationController{
    @objc private func coverViewClick(){
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
