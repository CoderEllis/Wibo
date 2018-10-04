//
//  ComposeViewController.swift
//  WIbo
//
//  Created by Soul Ai on 4/10/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
     // MARK:- 懒加载属性
    fileprivate lazy var titleView : ComposeTitleView = ComposeTitleView()
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏
        setupNavigationBar()
        
    }
}

//MARK:- 设置UI界面
extension ComposeViewController {
    fileprivate func setupNavigationBar() {
         // 1.设置左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 2.设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
}

// MARK:- 事件监听函数
extension ComposeViewController {
    @objc fileprivate func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func sendItemClick() {
        print("sendItemClick")
    }
}
